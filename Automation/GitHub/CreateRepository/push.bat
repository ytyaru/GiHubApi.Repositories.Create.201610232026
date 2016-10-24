:: -----------------------------------------------------------------------------
:: ローカルリポジトリとリモートリポジトリを新規作成して初commit→pushする
:: -----------------------------------------------------------------------------
:: 事前準備
:: * GitHubアカウントを作成してAccessTokenを作成する
::     * scopeに`repo`を付与する（作成と再設定をするに必要）
::     * scopeに`delete_repo`を付与する（削除をするに必要）
:: * [SSH公開鍵を作成してGitHubに設定する](http://ytyaru.hatenablog.com/entry/2016/06/17/082230)
:: 
:: 引数一覧
:: %1 DIR_PROJECT	作業ディレクトリ
:: %2 USER_NAME		ユーザ名
:: %3 REPO_NAME		リポジトリ名
:: %4 REPO_DESC		リポジトリ説明
:: %5 REPO_HOME		リポジトリHomepage
@echo off
set DIR_AUTO=%~dp0
set DIR_PROJECT=%1
set USER_NAME=%2
set REPO_NAME=%3
set REPO_DESC=%4
set REPO_HOME=%5

set GITHUB_TOKEN=
set USER_MAIL=
set SSH_HOST=github.com.%USER_NAME%

cd %DIR_AUTO%

:: TSVファイルからAccessTokenを取得する
set q="C:/root/tool/System/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub
set TSV_TOKEN="%DIR_DB%/meta_AccessToken.tsv"
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

:: TSVファイルからメールアドレスを取得する
set TSV_ACCOUNT="%DIR_DB%/meta_Accounts.tsv"
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select MailAddress from %TSV_ACCOUNT% where Username == '%USER_NAME%'"`) DO set USER_MAIL=%%i

cd %DIR_PROJECT%

:: ローカルリポジトリに.gitディレクトリ一式を作成（リビジョン管理の開始）
if not exist "./.git/" git init

:: アカウント切替
git config --local user.name "%USER_NAME%"
git config --local user.email "%USER_MAIL%"

: CheckStatus
echo リポジトリ：%USER_NAME%/%REPO_NAME%
echo 説明　　　：%REPO_DESC%
echo Homepage  ：%REPO_HOME%
echo ----------pushファイル一式----------
git add -n .
SET /P ANSWER="対象ファイルは上記でよいですか？ (Y/N)"
if "%answer%"=="y" (
	call :GotoContinue
) else if "%answer%"=="Y" (
	call :GotoContinue
) else if "%answer%"=="n" (
	call :GotoEnd
) else if "%answer%"=="N" (
	call :GotoEnd
)else (
	call :CheckStatus
)
exit

:GotoContinue

:: リモートリポジトリを生成する
call %DIR_AUTO%/meta_GiHubApi.Repository.Create.bat %USER_NAME% %GITHUB_TOKEN% %REPO_NAME% %REPO_DESC% %REPO_HOME%
@echo off

:: ローカルリポジトリにソースコードをステージングしコミットする
git add .
git commit -m "initial commit"

:: .git/configの設定追記コマンド。1回だけ実行すればいい。
:: 「fatal: remote origin already exists.」というエラーが表示されたらコメントアウトする。
git remote add origin git@%SSH_HOST%:%USER_NAME%/%REPO_NAME%.git

:: ローカルリポジトリからリモートリポジトリへ修正を反映させる
git push origin master

echo git リポジトリの作成が完了しました。
pause
exit

:GotoEnd
echo git initのみで終了します。
pause
exit

pause
@echo on
