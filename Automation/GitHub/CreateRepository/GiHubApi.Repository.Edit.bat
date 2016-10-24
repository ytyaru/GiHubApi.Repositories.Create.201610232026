:: ���������[�g���|�W�g���̐�����HomepageURL��ύX����
:: 
:: �����ꗗ
:: %1 DIR_PROJECT	��ƃf�B���N�g��
:: %1 USER_NAME		���[�U��
:: %3 REPO_NAME		���|�W�g����
:: %4 REPO_DESC		���|�W�g��������
:: %5 REPO_HOME		���|�W�g��Homepage
:: 
:: �o�̓t�@�C���ꗗ
:: GitHub.%USER_NAME%.%REPO_NAME%.json	GitHubAPI�̉���
set DIR_AUTO=%~dp0
set DIR_PROJECT=%1
set USER_NAME=%2
set REPO_NAME=%3
set REPO_DESC=%4
set REPO_HOME=%5

cd %DIR_AUTO%

:: TSV�t�@�C������AccessToken���擾����
set GITHUB_TOKEN=
set q="C:/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub/
set TSV_TOKEN="%DIR_DB%/AccessToken.tsv"
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

cd %DIR_PROJECT%

:question
echo �ΏہF%USER_NAME%/%REPO_NAME%
echo �����F%REPO_DESC%
echo URL �F%REPO_HOME%
SET /P ANSWER="��L�̒ʂ�A���|�W�g���̐�����URL���Đݒ肵�܂��B��낵���ł����H(Y/N)"
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

:: POST����p�����[�^��UTF-8�ɂ��邽�߂ɊO���t�@�C��������
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
echo �Đݒ肵�܂����B
pause
exit

:no
echo �Đݒ肹���I�����܂��B
pause
exit
