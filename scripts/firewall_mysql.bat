@echo off
setlocal enabledelayedexpansion
set RuleName=MySql
set RulePort=3306
REM Profile can be any one of these: public, private, domain, any
set RuleProfile=domain

netsh.exe advfirewall firewall show rule name="%RuleName%" | find.exe /i "-----" >NUL
if not errorlevel 1 (
	echo Rule '%RuleName%' already set, exiting.
	exit /b 0
)
echo Rule '%RuleName%' not set, will add ...
whoami.exe /groups | find.exe "S-1-16-12288" >NUL
if errorlevel 1 (
	echo ERROR: Not running elevated, unable to change firewall rules.
	exit /b 1
)
netsh.exe advfirewall firewall add rule name="%RuleName%" dir=in action=allow protocol=TCP localport=%RulePort% profile=%RuleProfile%
if errorlevel 1 (
	echo ERROR: Could not set the firewall rule.
	exit /b 1
)