Function Find-MissingAliasNotes {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    # Build patterns
    $aliasPattern51 = "Windows PowerShell includes the following aliases for"
    $aliasPatternNew = "PowerShell includes the following aliases for"

    # Find the local PowerShell-Docs path
    Write-Verbose -Message "Searching for Local PowerShell-Docs repo path.."

    $LocalPowerShellDocsPath = (Get-ChildItem -Path $env:USERPROFILE -Filter "PowerShell-Docs" -Recurse).FullName

    if ( -not $LocalPowerShellDocsPath) {
        $LocalPowerShellDocsPath = (Get-ChildItem -Path $env:SystemDrive -Filter "PowerShell-Docs" -Recurse).FullName
    }

    if ( -not $LocalPowerShellDocsPath) { 
        Write-Error "This cmdlet requires you to clone the PowerShell-Docs repo in $env:USERPROFILE, or $env:SystemDrive (Looks recursivly). Fix this and try again!" -ErrorAction Stop
    }

    Write-Verbose -Message "Building alias cmdlet arrays.."

    if ($IsWindows -or $PSVersionTable.PSVersion.Major -ge 5) {
        $WindowsPowerShellAliases = powershell -NoProfile -c "Get-Alias | Select-Object -ExpandProperty Definition" | Where-Object { $_ -match '^[A-Z][a-z]+(-[A-Z][a-z]+)+$' }
        $WindowsPowerShellAliases = $WindowsPowerShellAliases + "Get-Clipboard", "Get-ComputerInfo", "Get-TimeZone", "Set-Clipboard", "Set-TimeZone"
    }
    else {
        Write-Warning "Skipping 5.1 since we're not on windows."
    }

    $PowerShellAliases = pwsh -NoProfile -c "Get-Alias | Select-Object -ExpandProperty Definition" | Where-Object { $_ -match '^[A-Z][a-z]+(-[A-Z][a-z]+)+$' }
    $PowerShellAliases = $PowerShellAliases + "Get-Clipboard", "Get-ComputerInfo", "Get-TimeZone", "Set-Clipboard", "Set-TimeZone"

    Write-Verbose -Message "Displaying output for 5.1 cmdlets.."
    Write-Output "PowerShell 5.1: The following files lacks alias notes:"

    $WinPowerShellCmdletPath = @()
    $WindowsPowerShellAliases | ForEach-Object {
        $CurrentAliasCmdlet = $_
        $WinPowerShellCmdletPath += Get-ChildItem  "$LocalPowerShellDocsPath\reference\5.1\*$_*.md" -Depth 3 | Select-Object -ExpandProperty FullName | Where-Object { $_ -clike "*$CurrentAliasCmdlet.md" }
    }

    foreach ($ww in $WinPowerShellCmdletPath) {
        if (-not (Get-Content $ww | Where-Object { $_ -match $aliasPattern51 })) {
            $ww
        }
    }

    Write-Verbose -Message "Displaying output for 7+ cmdlets.."
    Write-Output "PowerShell 7+: The following files lacks alias notes:"

    $PowerShellCmdletPath = @()
    $PowerShellAliases | ForEach-Object {
        $CurrentAliasCmdlet = $_
        $PowerShellCmdletPath += Get-ChildItem  "$LocalPowerShellDocsPath\reference\7*\*$_*.md" -Depth 3 | Select-Object -ExpandProperty FullName | Where-Object { $_ -clike "*$CurrentAliasCmdlet.md" }
    }

    foreach ($pp in $PowerShellCmdletPath) {
        if (-not (Get-Content $pp | Where-Object { $_ -match $aliasPatternNew })) {
            $pp
        }
    }

}