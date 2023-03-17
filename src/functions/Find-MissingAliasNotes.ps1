<#
    1. Find the PowerShell-Docs repo path locally, store in var
    2. Find all cmdlets with aliases
    3. Look for alias notes pattern in ## NOTES, should start with 'Windows PowerShell includes the following aliases for' for 5.1 cmdlets, and 'PowerShell includes the following aliases for' for newer versions
    4. Loop through all cmdlets from step 2 and see if they match the pattern in step 3
    5. Return result
#>

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

    if ($IsWindows) {
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
    if ($WindowsPowerShellAliases) {
        $WindowsPowerShellCmdletPath = @()
        $WindowsPowerShellAliases | ForEach-Object {
            $WindowsPowerShellCmdletPath += Get-ChildItem -Path "$LocalPowerShellDocsPath\reference\5.1" -Filter "*$($_).md" -Recurse | Select-Object -ExpandProperty FullName
        }

        foreach ($wp in $WindowsPowerShellCmdletPath) {
            if (-not (Get-Content $wp | Where-Object { $_ -match $aliasPattern51 })) {
                $wp       
            }
        }
    }

    Write-Verbose -Message "Displaying output for 7+ cmdlets.."
    Write-Output "PowerShell 7+: The following files lacks alias notes:"
    if ($PowerShellAliases) {
        $PowerShellCmdletPath = @()
        $PowerShellAliases | ForEach-Object { # Update Path when PowerShell 8 
            $PowerShellCmdletPath += Get-ChildItem -Path "$LocalPowerShellDocsPath\reference\7*" -Filter "*$($_).md" -Recurse | Select-Object -ExpandProperty FullName
        }

        foreach ($pp in $PowerShellCmdletPath) {
            if (-not (Get-Content $pp | Where-Object { $_ -match $aliasPatternNew })) {
                $pp
            }
        }
    }
}