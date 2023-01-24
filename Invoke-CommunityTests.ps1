# Invoke all tests
$script:DocsRepo = "$PSScriptRoot\..\PowerShell-Docs"

if (Test-Path $script:DocsRepo) {
    Invoke-Pester .\tests\*
}
else {
    Write-Error "Missing PowerShell-Docs repo above the scriptroot." -ErrorAction Stop
}