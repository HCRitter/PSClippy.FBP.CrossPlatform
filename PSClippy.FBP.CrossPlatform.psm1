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
Get-ScriptFeedbackProvider |Where-Object Name -eq 'Cross-Platform EnvironmentVariables' | Unregister-ScriptFeedbackProvider

$EnvironmentVariablesScriptBlock=(get-command "$PSSCriptroot\Private\FBP.CP.Environment.ps1").ScriptBlock

Register-ScriptFeedbackProvider -Name 'Cross-Platform EnvironmentVariables' -Trigger Success -ScriptBlock $EnvironmentVariablesScriptBlock
Write-Host 'FeedbackProvider(s) for CrossPlattform has been registered' -ForegroundColor Green