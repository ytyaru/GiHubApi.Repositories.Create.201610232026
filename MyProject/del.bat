@echo off
set DIR_PROJECT=%~dp0
set USER_NAME=user1
for %%I in (.) do set REPO_NAME=%%~nI%%~xI

set DIR_AUTO=C:/GiHubApi.Repositories.Create.201610232026/Automation/GitHub/CreateRepository/
set BAT_PUSH=%DIR_AUTO%/GiHubApi.Repository.Delete.bat
call %BAT_PUSH% %DIR_PROJECT% %USER_NAME% %REPO_NAME%
pause
@echo on
