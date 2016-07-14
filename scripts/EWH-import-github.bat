@echo off

set "REPO=%1"
set "BUILD_DIR=build"

git clone %REPO% .
rem only ignore if BUILD_DIR not exists in .gitignore 
FOR /F "delims=" %%a in (.gitignore) DO (
	IF "%%a" == "%BUILD_DIR%/" (
		GOTO SKIP_APPEND_GITIGNORE
	)
)

rem TODO only add if build dir not exists
echo %BUILD_DIR%/>>.gitignore

:SKIP_APPEND_GITIGNORE
rem test commit for write permission
git add .
git commit -m "add build dir to .gitignore"
git push --set-upstream origin master

rem detect build folder and branch gh-pages exists
IF NOT EXIST "%BUILD_DIR%\" (
	echo "build folder not exists"
	rem create build dir
	mkdir %BUILD_DIR%
)

cd %BUILD_DIR%

rem try checkout gh-pages remote branch
git clone -b gh-pages %REPO% .

rem this will fail if above command work
git clone %REPO% .
		
git branch -d master
git pull origin gh-pages
git push --set-upstream origin gh-pages

rem push changes to remote
git add .
git commit -m "init"
git push

rem delete all folder not .git in working dir
for /D %%F in (*) do (
   if NOT %%F == ".git" rd %%F /Q /S
)
rem delete all file in working dir
for %%F in (*) do (
   del %%F /Q /S
)

:EOF