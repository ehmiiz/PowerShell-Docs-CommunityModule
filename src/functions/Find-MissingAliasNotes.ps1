<#
    1. Find the PowerShell-Docs repo path locally, store in var
    2. Find all cmdlets with aliases
    3. Look for alias notes pattern in ## NOTES, should start with 'Windows PowerShell includes the following aliases for' for 5.1 cmdlets, and 'PowerShell includes the following aliases for' for newer versions
    4. Loop through all cmdlets from step 2 and see if they match the pattern in step 3
    5. Return result
#>

# Build patterns
$aliasPattern51 = "## NOTES`r`n.+?Windows PowerShell includes the following aliases for.+?`r`n"
$aliasPatternNew = "## NOTES`r`n.+?PowerShell includes the following aliases for.+?`r`n"

# Find the local PowerShell-Docs path
Write-Verbose -Message "Searching for Local PowerShell-Docs repo path.."

$LocalPowerShellDocsPath = (Get-ChildItem -Path $env:USERPROFILE -Filter "PowerShell-Docs" -Recurse).FullName

if ( -not $LocalPowerShellDocsPath) {
    $LocalPowerShellDocsPath = (Get-ChildItem -Path $env:SystemDrive -Filter "PowerShell-Docs" -Recurse).FullName
}

if ( -not $LocalPowerShellDocsPath) { 
    Write-Error "This function only supports having the PowerShell-Docs repo in the system drive." -ErrorAction Stop
}

Write-Verbose -Message "Building alias cmdlet arrays.."

if ($IsWindows) {
    $WindowsPowerShellAliases = powershell -NoProfile -c "Get-Alias | Select-Object -ExpandProperty Definition" | Where-Object { $_ -match '^[A-Z][a-z]+(-[A-Z][a-z]+)+$' }
    $WindowsPowerShellAliases = $WindowsPowerShellAliases + "Get-Clipboard", "Get-ComputerInfo", "Get-TimeZone", "Set-Clipboard", "Set-TimeZone"
}
else {
    Write-Warning "Skipping 5.1 since we're not on windows."
}

$PowerShellAliases = pwsh -NoProfile -c "Get-Alias | Select-Object -ExpandProperty Definition" | Where-Object { $_ -match '^[A-Z][a-z]+(-[A-Z][a-z]+)+$' }
$PowerShellAliases = $PowerShellAliases + "Get-Clipboard", "Get-ComputerInfo", "Get-TimeZone", "Set-Clipboard", "Set-TimeZone"

if ($WindowsPowerShellAliases) {
    $WindowsPowerShellCmdletPath = @()
    $WindowsPowerShellAliases | ForEach-Object {
        $WindowsPowerShellCmdletPath += Get-ChildItem -Path "$LocalPowerShellDocsPath\reference\5.1" -Filter "*$($_).md" -Recurse | Select-Object -ExpandProperty FullName
    }

    foreach ($wp in $WindowsPowerShellCmdletPath) {
        if (Select-String -Path $wp -Pattern $aliasPattern51) {
            # TODO Fix this so it works
            "$wp has alias notes!"
        }
        else {
            "$wp lacks alias notes :("
        }
    }
    

}