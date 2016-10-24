:: ���|�W�g���폜
:: 
:: �����ꗗ
:: %1 DIR_PROJECT	�v���W�F�N�g�f�B���N�g���p�X
:: %2 USER_NAME		���[�U��
:: %3 REPO_NAME		���|�W�g����
@echo off
set DIR_AUTO=%~dp0
set DIR_PROJECT=%1
set USER_NAME=%2
set REPO_NAME=%3
:: for %%I in (.) do set REPO_NAME=%%~nI%%~xI

cd %DIR_AUTO%

:: TSV�t�@�C������AccessToken���擾����
set GITHUB_TOKEN=
set q="C:/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub/
set TSV_TOKEN="%DIR_DB%/AccessToken.tsv"

:ExsistTsv
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

cd %DIR_PROJECT%

:question
echo �ΏہF%USER_NAME%/%REPO_NAME%
SET /P ANSWER="���|�W�g�����폜���܂����H (Y/N)?"
if "%answer%"=="y" (
  call :yes
) else if "%answer%"=="Y" (
  call :yes
) else if "%answer%"=="n" (
  call :no
) else if "%answer%"=="N" (
  call :no
)else (
  call :question
)
exit

:yes
set CURL_PEM=C:\Program Files\Git\ssl\certs\cacert.pem
set HDR_AUTHOR="Authorization: token %GITHUB_TOKEN%"
curl --cacert "%CURL_PEM%" -X DELETE -H %HDR_AUTHOR% https://api.github.com/repos/%USER_NAME%/%REPO_NAME% | nkf -s
rmdir /S /Q "%DIR_PROJECT%/.git"
echo �폜���܂����B
pause
exit

:no
echo �폜�����I�����܂��B
pause
exit

:ErrorEnd
echo %1
pause
exit 1

pause
@echo on
