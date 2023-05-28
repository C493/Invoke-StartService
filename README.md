# Invoke-StartService
[![PowerShell](https://img.shields.io/badge/Code-PowerShell-blue?&style=flat-square&logo=powershell)](https://learn.microsoft.com/en-us/powershell/)

Checks if a specified service is running, and if not, attempts a certain number of times to start it.

---

## DESCRIPTION

Checks if a specified service is running, this can be specified using the ServiceName parameter or from the pipeline.  
If the service is not running, a specified number of attempts (default: 5) are made to start it.  
The number of attempts can be specified using the -NumberOfAttempts parameter.  

Returns a zero value for success or a non-zero value for failure  
- 1 - No such service found
- 2 - An unknown error has occurred
- 3 - Service is neither running or stopped (may be starting or stopping)
- 4 - All attempts failed, manual intervention required

### NOTES

**Author  :**   Patrick Cage (patrick@patrickcage.com)  
**Version :**   1.0.0 (2022-10-30)  
**License :**   GNU General Public License (GPL) v3  

### INPUTS

System.ServiceProcess.ServiceController

### PARAMETER ServiceName

\<string> [Required] The name of the Service to be started

**Aliases :**   Service

### PARAMETER NumberOfAttempts

\<int32> [Optional] The number of times to attempt to start before failing

**Default :**   5

**Aliases :**   Attempts

### PARAMETER CheckDelay

\<double> [Optional] The number of seconds to wait when starting the service before checking if it has started

**Default :**   10

**Aliases :**   Delay

### EXAMPLE

```powershell
Invoke-StartService.ps1 "Print Spooler"
```

### EXAMPLE

```powershell
Invoke-StartService.ps1 -ServiceName "Print Spooler" -NumberOfAttempts 3 -CheckDelay 15
```

### EXAMPLE

```powershell
Invoke-StartService.ps1 -Service "Print Spooler" -Attempts 3
```

### EXAMPLE

```powershell
Invoke-StartService.ps1 "Print Spooler" 3
```

### EXAMPLE

```powershell
Get-Service -Name "Print Spooler" | Invoke-StartService.ps1
```

---

If this has helped you, please consider [buying me a coffee](https://www.buymeacoffee.com/patrickcage)