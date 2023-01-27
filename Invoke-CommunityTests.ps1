# Invoke all tests
$script:DocsRepo = (Get-Item "$PSScriptRoot\..\PowerShell-Docs").FullName

if (Test-Path $script:DocsRepo) {
    "found $script:DocsRepo"
    Invoke-Pester $PSScriptRoot\tests\*
}
else {
    Write-Error "Missing PowerShell-Docs repo above the scriptroot." -ErrorAction Stop
}