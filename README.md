# Community driven tests for the PowerShell-Docs repository

The [PowerShell-docs](https://github.com/MicrosoftDocs/PowerShell-Docs/) hosts a community driven project called [PowerShell Docs Quality Contributions](https://github.com/orgs/MicrosoftDocs/projects/15)

This repository performs (pester) tests against the PowerShell-Docs repo, making it easier to know what to focus on as an individual contributor. The main goal of this repository, as a start, is to test the [Alias notes section](https://learn.microsoft.com/en-gb/powershell/scripting/community/contributing/quality-improvements?view=powershell-7.2#aliases).

## List of tests

- Test if there are any alias notes
- Test if they are following the agreed format
  - 5.1 alias sections should contain `Windows PowerShell`
  - 7.x alias sections should contain `PowerShell`
- Test if the aliases work as the docs describe

## Contribute to this repository

Any contributions are welcome!