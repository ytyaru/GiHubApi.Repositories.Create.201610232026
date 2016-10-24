:: GitHubのリモートリポジトリを新規作成する
:: 
:: 引数一覧
:: %1 GITHUB_USER	ユーザ名
:: %2 GITHUB_TOKEN	AccessToken(scopeに`repo`があること)
:: %3 REPO_NAME		リポジトリ名
:: %4 REPO_DESC		リポジトリ説明文
:: %5 REPO_HOME		リポジトリHomepage
:: 
:: 出力ファイル一覧
:: GitHub.%GITHUB_USER%.%REPO_NAME%.json	GitHubAPIの応答
set GITHUB_USER=%1
set GITHUB_TOKEN=%2
set REPO_NAME=%3
set REPO_DESC=%4
set REPO_HOME=%5

set HDR_TIMEZONE="Time-Zone: Asia/Tokyo"
set HDR_AUTHOR="Authorization: token %GITHUB_TOKEN%"
set RESPONSE="GitHub.%GITHUB_USER%.%REPO_NAME%.json"
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

@echo on
call curl --cacert %CURL_PEM% -o %RESPONSE% -H %HDR_TIMEZONE% -H %HDR_AUTHOR% -H "Content-Type: application/json; charset=utf-8" -X POST https://api.github.com/user/repos --data-binary @%POST_PARAM_UTF8%
@echo off

sleep 5
del %POST_PARAM_UTF8%
