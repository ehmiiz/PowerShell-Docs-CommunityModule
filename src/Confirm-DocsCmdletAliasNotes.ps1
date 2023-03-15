<#
    - Test if there are any alias notes
    - Test if they are following the agreed format
    - 5.1 alias sections should contain `Windows PowerShell`
    - 7.x alias sections should contain `PowerShell`
    - Test if the aliases work as the docs describe
#>

$Global:DocsPath = (Get-Item "$PSScriptRoot\..\..\PowerShell-Docs").FullName
$Global:WinPowerShellPath = "$Global:DocsPath\reference\5.1"
$Global:ShouldHaveAliasNotes = powershell -NoProfile -c "Get-Alias | Select-Object Definition -Unique" | Where-Object {$_ -like "*-*"}

if (Test-Path $Global:WinPowerShellPath)
{
    $ModuleForPath = powershell -c "Get-Command $_ | Select-Object -Expandproperty Source"
    $PathToCmdletDoc = "$Global:WinPowerShellPath\$ModuleForPath\$($_.trim(" ")).md"

    if (Test-Path $PathToCmdletDoc) {
        $TestContent = Get-Content $PathToCmdletDoc | Select-String -Pattern '## NOTES' -Context 0, 2
        $TestContent -match 'Windows PowerShell includes the following aliases for'
    }
    else {
        Write-Warning "Could not find path: $PathToCmdletDoc"
    }
}