:: -----------------------------------------------------------------------------
:: ���[�J�����|�W�g���ƃ����[�g���|�W�g����V�K�쐬���ď�commit��push����
:: -----------------------------------------------------------------------------
:: ���O����
:: * GitHub�A�J�E���g���쐬����AccessToken���쐬����
::     * scope��`repo`��t�^����i�쐬�ƍĐݒ������ɕK�v�j
::     * scope��`delete_repo`��t�^����i�폜������ɕK�v�j
:: * [SSH���J�����쐬����GitHub�ɐݒ肷��](http://ytyaru.hatenablog.com/entry/2016/06/17/082230)
:: 
:: �����ꗗ
:: %1 DIR_PROJECT	��ƃf�B���N�g��
:: %2 USER_NAME		���[�U��
:: %3 REPO_NAME		���|�W�g����
:: %4 REPO_DESC		���|�W�g������
:: %5 REPO_HOME		���|�W�g��Homepage
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

:: TSV�t�@�C������AccessToken���擾����
set q="C:/root/tool/System/q-1.5.0/bin/q.bat"
set DIR_DB=../../../Account/GitHub
set TSV_TOKEN="%DIR_DB%/meta_AccessToken.tsv"
set TokenDescription=RepositoryControl
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select Token from %TSV_TOKEN% where User == '%USER_NAME%' and Description == '%TokenDescription%'"`) DO set GITHUB_TOKEN=%%i

:: TSV�t�@�C�����烁�[���A�h���X���擾����
set TSV_ACCOUNT="%DIR_DB%/meta_Accounts.tsv"
FOR /F "usebackq" %%i in (`call %q% -H -t -e UTF-8 -E SJIS "select MailAddress from %TSV_ACCOUNT% where Username == '%USER_NAME%'"`) DO set USER_MAIL=%%i

cd %DIR_PROJECT%

:: ���[�J�����|�W�g����.git�f�B���N�g���ꎮ���쐬�i���r�W�����Ǘ��̊J�n�j
if not exist "./.git/" git init

:: �A�J�E���g�ؑ�
git config --local user.name "%USER_NAME%"
git config --local user.email "%USER_MAIL%"

: CheckStatus
echo ���|�W�g���F%USER_NAME%/%REPO_NAME%
echo �����@�@�@�F%REPO_DESC%
echo Homepage  �F%REPO_HOME%
echo ----------push�t�@�C���ꎮ----------
git add -n .
SET /P ANSWER="�Ώۃt�@�C���͏�L�ł悢�ł����H (Y/N)"
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

:: �����[�g���|�W�g���𐶐�����
call %DIR_AUTO%/meta_GiHubApi.Repository.Create.bat %USER_NAME% %GITHUB_TOKEN% %REPO_NAME% %REPO_DESC% %REPO_HOME%
@echo off

:: ���[�J�����|�W�g���Ƀ\�[�X�R�[�h���X�e�[�W���O���R�~�b�g����
git add .
git commit -m "initial commit"

:: .git/config�̐ݒ�ǋL�R�}���h�B1�񂾂����s����΂����B
:: �ufatal: remote origin already exists.�v�Ƃ����G���[���\�����ꂽ��R�����g�A�E�g����B
git remote add origin git@%SSH_HOST%:%USER_NAME%/%REPO_NAME%.git

:: ���[�J�����|�W�g�����烊���[�g���|�W�g���֏C���𔽉f������
git push origin master

echo git ���|�W�g���̍쐬���������܂����B
pause
exit

:GotoEnd
echo git init�݂̂ŏI�����܂��B
pause
exit

pause
@echo on
