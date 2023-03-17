# Community driven tests for the PowerShell-Docs repository

The [PowerShell-docs](https://github.com/MicrosoftDocs/PowerShell-Docs/) hosts a community driven project called [PowerShell Docs Quality Contributions](https://github.com/orgs/MicrosoftDocs/projects/15)

This module verifies a level of quality to the PowerShell-Docs repo, making it easy for you as a community contributor to know what to focus on.

Example:

```powershell
Set-Location $env:USERPROFILE

git clone https://github.com/username/PowerShell-Docs-CommunityTests

Import-Module PowerShell-Docs-CommunityModule

Find-MissingAliasNotes -Verbose
```


## Step-by-step

1. Install the PowerShell-Docs-CommunityModule
2. Clone PowerShell-Docs under it:
```text
systemroot/userprofile
└───gitfolder
    ├───PowerShell-Docs
    └───PowerShell-Docs-CommunityTests
```
3. Run the commands to figure out what to work on
4. Follow the [Contribution Guidelines](https://learn.microsoft.com/powershell/scripting/community/contributing/quality-improvements?view=powershell-7.2#aliases)

## Planned functions
- [Find-MissingAliasNotes](https://learn.microsoft.com/powershell/scripting/community/contributing/quality-improvements?view=powershell-7.2#aliases)
- [Find-LegacyLinkReference](https://learn.microsoft.com/powershell/scripting/community/contributing/quality-improvements?view=powershell-7.2#link-references)
- [Find-DocsTypo](https://learn.microsoft.com/powershell/scripting/community/contributing/quality-improvements?view=powershell-7.2#spelling)

## Contribute to this repository

Any contributions are welcome!
