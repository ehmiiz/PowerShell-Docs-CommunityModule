<#
    - Test if there are any alias notes
    - Test if they are following the agreed format
    - 5.1 alias sections should contain `Windows PowerShell`
    - 7.x alias sections should contain `PowerShell`
    - Test if the aliases work as the docs describe
#>

BeforeAll {
    $Global:DocsPath = (Get-Item "$PSScriptRoot\..\..\PowerShell-Docs").FullName
    $Global:WinPowerShellPath = "$Global:DocsPath\reference\5.1"
    $Global:ShouldHaveAliasNotes = powershell -NoProfile -c "Get-Alias | Select-Object Definition -Unique" | Where-Object {$_ -like "*-*"} #TODO: Make this more exact 
}

Describe '5.1 Alias Notes' {
    
    It 'Has a valid local path' {
        Test-Path $Global:WinPowerShellPath | Should -Be $true
    }

    # Bulk approach
    It 'Contains new alias notes style' -ForEach $Global:ShouldHaveAliasNotes {

        $ModuleForPath = powershell -c "Get-Command $_ | Select-Object -Expandproperty Source" #TODO: This is not optimal, should be more exact
        $PathToCmdletDoc = "$Global:WinPowerShellPath\$ModuleForPath\$($_.trim(" ")).md"

        if (Test-Path $PathToCmdletDoc) {
            $TestContent = Get-Content $PathToCmdletDoc | Select-String -Pattern '## NOTES' -Context 0, 2
            $TestContent | Should -Match 'Windows PowerShell includes the following aliases for' #TODO: Fix output so it's clear what needs to be added
        }
        else {
            Write-Warning "Could not find path: $PathToCmdletDoc"
        }
    }
}