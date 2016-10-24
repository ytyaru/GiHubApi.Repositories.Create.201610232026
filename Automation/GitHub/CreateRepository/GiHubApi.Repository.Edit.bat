:: 既存リモートリポジトリの説明やHomepageURLを変更する
:: 
:: 引数一覧
:: %1 DIR_PROJECT	作業ディレクトリ
:: %1 USER_NAME		ユーザ名
:: %3 REPO_NAME		リポジトリ名
:: %4 REPO_DESC		リポジトリ説明文
:: %5 REPO_HOME		リポジトリHomepage
:: 
:: 出力ファイル一覧
:: GitHub.%USER_NAME%.%REPO_NAME%.json	GitHubAPIの応答
set DIR_AUTO=%~dp0
set DIR_PROJECT=%1
set USER_NAME=%2
set REPO_NAME=%3
set REPO_DESC=%4
set REPO_HOME=%5

cd %DIR_AUTO%

:: TSVファイルからAccessTokenを取得する
set GITHUB_TOKEN=
set q="C:/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub/
set TSV_TOKEN="%DIR_DB%/AccessToken.tsv"
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

cd %DIR_PROJECT%

:question
echo 対象：%USER_NAME%/%REPO_NAME%
echo 説明：%REPO_DESC%
echo URL ：%REPO_HOME%
SET /P ANSWER="上記の通り、リポジトリの説明とURLを再設定します。よろしいですか？(Y/N)"
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
set HDR_TIMEZONE="Time-Zone: Asia/Tokyo"
set HDR_AUTHOR="Authorization: token %GITHUB_TOKEN%"
set HDR_CONTENT_TYPE="Content-Type: application/json; charset=utf-8"
set RESPONSE="GitHub.%USER_NAME%.%REPO_NAME%.json"
set CURL_PEM="C:\Program Files\Git\ssl\certs\cacert.pem"

:: POSTするパラメータをUTF-8にするために外部ファイル化する
set POST_PARAM={"name":"%REPO_NAME%","description":"%REPO_DESC%","homepage":"%REPO_HOME%"}
set POST_PARAM_CP932=post.cp932.json
set POST_PARAM_UTF8=post.utf8.json
if exist %POST_PARAM_CP932% del %POST_PARAM_CP932%
if exist %POST_PARAM_UTF8% del %POST_PARAM_UTF8%
echo %POST_PARAM% > %POST_PARAM_CP932%
nkf -w --overwrite %POST_PARAM_CP932%
ren %POST_PARAM_CP932% %POST_PARAM_UTF8%

curl --cacert %CURL_PEM% -o %RESPONSE% -H %HDR_CONTENT_TYPE% -H %HDR_TIMEZONE% -H %HDR_AUTHOR% -X PATCH https://api.github.com/repos/%USER_NAME%/%REPO_NAME% --data-binary @%POST_PARAM_UTF8%

sleep 5
del %POST_PARAM_UTF8%
echo 再設定しました。
pause
exit

:no
echo 再設定せず終了します。
pause
exit
