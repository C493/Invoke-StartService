# Invoke-StartService Changelog

All notable changes to this project will be documented in this file
(newer entries on top)

_The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/)._

---

## [1.0.0] (2022-10-30)

### ADDED

- Support for taking ServiceName by parameter
- Support for taking ServiceName by pipeline
- Support for taking NumberOfAttempts by parameter
- Support for taking CheckDelay by parameter
- Comment Based Help
- Return values (0,1,2,3,4)

### CHANGED

- Renamed from Check-Service to Invoke-ServiceStart
- Changed to advanced function
- Output messages to Write-Host to keep pipeline clear for return values
- 'serviceCheck' variable to 'Service' for clarity

---

## [v0.1.0] (2020-07-15) _Initial Version_

- Checks the "Print Spooler" service to see if it is started
- Attempts 5 times to start the service if it is stopped