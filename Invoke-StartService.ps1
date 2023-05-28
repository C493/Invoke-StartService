<#
    .SYNOPSIS
        Checks if a specified service is running, and if not, attempts a certain number of times to start it.

    .DESCRIPTION
        Checks if a specified service is running, this can be specified using the ServiceName parameter or from the pipeline.
        If the service is not running, a specified number of attempts (default: 5) are made to start it.
        The number of attempts can be specified using the -NumberOfAttempts parameter

        Returns a zero value for success or a non-zero value for failure
        1 - No such service found
        2 - An unknown error has occurred
        3 - Service is neither running or stopped (may be starting or stopping)
        4 - All attempts failed, manual intervention required

    .NOTES
        Author  :   Patrick Cage (patrick@patrickcage.com)
        Version :   1.0.0 (2022-10-30)
        License :   GNU General Public License (GPL) v3
    
    .INPUTS
        System.ServiceProcess.ServiceController
    
    .PARAMETER ServiceName
        <string> [Required] The name of the Service to be started

        Aliases:    Service
    
    .PARAMETER NumberOfAttempts
        <int32> [Optional] The number of times to attempt to start before failing

        Default:    5

        Aliases:    Attempts
    
    .PARAMETER CheckDelay
        <double> [Optional] The number of seconds to wait when starting the service before checking if it has started

        Default:    10

        Aliases:    Delay
    
    .EXAMPLE
        Invoke-StartService.ps1 "Print Spooler"
    
    .EXAMPLE
        Invoke-StartService.ps1 -ServiceName "Print Spooler" -NumberOfAttempts 3 -CheckDelay 15
    
    .EXAMPLE
        Invoke-StartService.ps1 -Service "Print Spooler" -Attempts 3
    
    .EXAMPLE
        Invoke-StartService.ps1 "Print Spooler" 3
    
    .EXAMPLE
        Get-Service -Name "Print Spooler" | Invoke-StartService.ps1
    
    .LINK
        https://www.patrickcage.com/invoke-startservice
    #>

[CmdletBinding()]
Param(
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0, HelpMessage = "The name of the Service to be started")]
    [Alias("Service")]
    [string] $ServiceName,
    [Parameter(Position = 1, HelpMessage = "The number of times to attempt to start before failing (Default = 5)")]
    [Alias("Attempts")]
    [int32] $NumberOfAttempts = 5,
    [Parameter(Position = 2, HelpMessage = "The number of seconds to wait when starting the service before checking if it has started (Default = 10)")]
    [Alias("Delay")]
    [double] $CheckDelay = 10
)

# Get the service named above as a Service Object
try { $Service = (Get-Service -Name $ServiceName -ErrorAction Stop) }
catch [Microsoft.PowerShell.Commands.ServiceCommandException] {
    # If the service with a DisplayName as given above does not exist, output error and exit
    Write-Host "ERROR: No such service found ($($ServiceName))"
    Return 1
}
catch {
    # If some other error occurs, outpur error and exit
    Write-Host "ERROR: An unknown error occurred."
    Return 2
}

# Check the status of the Service
if ($Service.Status -eq "Stopped") {
    # If "Stopped", initialise counter variable and begin attempts to start
    $attemptCounter = 0
    Write-Host "$($Service.DisplayName) is Stopped"
    while ($Service.Status -eq "Stopped" -and $attemptCounter -le $NumberOfAttempts) {
        $attemptCounter += 1
        $Service | Start-Service
        # Delay to give the service time to start before checking again
        Start-Sleep -Seconds $CheckDelay
    }
    # If "Running", the attempts to start were successful
    if ($Service.Status -eq "Running") {
        Write-Host "SUCCESS: The service was started (Attempts: $($attemptCounter))"
        Return 0
    }
    # If status is not "Running", the attempts to start failed and intervention is needed
    else {
        Write-Host "FAILED: The Service could not be started, manual intervention required (Attempts: $($attemptCounter))"
        Return 4
    }
}
elseif ($Service.Status -eq "Running") {
    # If initial status is "Running", there is no action required
    Write-Host "$($Service.DisplayName) is Running, no intervention required"
    Return 0
}
else {
    # If the initial status is not "Stopped" or "Running" there is a problem that will need intervention
    Write-Host "$($Service.DisplayName) is $($Service.Status), manual intervention may be required"
    Return 3
}


