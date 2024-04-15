<#
    All Feedback Providers (Scriptblocks) to register for EnvironmentVariables
#>



param($context)
if ($context) { 
    $Messages = Switch -Regex ($context.CommandLineAst.Extent.Text.ToString()){
        '.*\$Env:Temp.*|.*\$Env:Tmp.*'{
            $MatchingWord = if($_ -Match '\$Env:(Temp|Tmp)'){$Matches[1]}
            [PSCustomObject]@{
                Command     = "Execution:`t"+$_
                Advisement  = "Replace:`t`t`$env:$MatchingWord with [System.IO.Path]::GetTempPath()"
            }
        }
        '.*\$env:USERPROFILE*|.*\$env:Home|.*\$home*'{
            $MatchingWord = if($_ -Match '\$Env:(home|Userprofile)'){'$env:'+$Matches[1]}else {
                '$home'
            }
            [PSCustomObject]@{
                Command     = "Execution:`t"+$_
                Advisement  = "Replace:`t`t$MatchingWord with [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::UserProfile)"
            }
        }
    }
    $Messages.ForEach({
        [FeedbackItem]::new("Consider to switch:",     
            @(
                $_.Command,
                $_.Advisement
            )
        )
    })
}
