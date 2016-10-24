:: リポジトリ削除
:: 
:: 引数一覧
:: %1 DIR_PROJECT	プロジェクトディレクトリパス
:: %2 USER_NAME		ユーザ名
:: %3 REPO_NAME		リポジトリ名
@echo off
set DIR_AUTO=%~dp0
set DIR_PROJECT=%1
set USER_NAME=%2
set REPO_NAME=%3
:: for %%I in (.) do set REPO_NAME=%%~nI%%~xI

cd %DIR_AUTO%

:: TSVファイルからAccessTokenを取得する
set GITHUB_TOKEN=
set q="C:/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub/
set TSV_TOKEN="%DIR_DB%/AccessToken.tsv"

:ExsistTsv
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

cd %DIR_PROJECT%

:question
echo 対象：%USER_NAME%/%REPO_NAME%
SET /P ANSWER="リポジトリを削除しますか？ (Y/N)?"
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
echo 削除しました。
pause
exit

:no
echo 削除せず終了します。
pause
exit

:ErrorEnd
echo %1
pause
exit 1

pause
@echo on
