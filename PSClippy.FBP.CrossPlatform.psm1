using namespace System.Management.Automation.Subsystem.Feedback

try {
    if($null -ne (Get-Module -Name ScriptFeedbackProvider)){
        Import-Module ScriptFeedbackProvider -ErrorAction Stop
    }
}
catch {
    Write-Error 'Module: ScriptFeedBackProver  - must be installed!'
    return
}

try {
    if((Get-ExperimentalFeature -Name PSFeedbackProvider).Enabled -eq $false){
        Throw 'Experimental Feature PSFeedBackProvider is required'
    }
}
catch {
    return
}


foreach($ProviderFile in (Get-Childitem -Path "$PSSCriptroot\Private\")){
    $ProviderScriptBlock = (get-command $ProviderFile.FullName).ScriptBlock
    # get the ProviderName 
    $ProviderName = ($ProviderScriptBlock.Ast.Extent.StartScriptPosition.GetFullScript().Split("`n") | Where-Object { $_.TrimStart().StartsWith('#ProviderName: ')  }).split('#ProviderName: ')[1]
    if([string]::isNullOrEmpty($ProviderName)){
        continue
    }
    # Unregister and register all FeedBackProver inside of 'Private' folder
    Get-ScriptFeedbackProvider |Where-Object Name -eq $ProviderName | Unregister-ScriptFeedbackProvider
    Register-ScriptFeedbackProvider -Name $ProviderName -Trigger Success -ScriptBlock $ProviderScriptblock
}
Write-Host 'FeedbackProvider(s) for CrossPlattform has been registered' -ForegroundColor Green