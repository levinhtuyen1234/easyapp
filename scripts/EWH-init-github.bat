@echo off
rem ------------------------------------------------
rem | SCRIPT CHỈ HOẠT ĐỘNG KHI REPO LÀ 1 REPO RỖNG |
rem ------------------------------------------------

set "REPO=%1"
set "BUILD_DIR=build"

git init
git remote add origin %REPO%

rem only ignore if BUILD_DIR not exists in .gitignore 
FOR /F "delims=" %%a in (.gitignore) DO (
	IF "%%a" == "%BUILD_DIR%/" ( GOTO SKIP_APPEND_BUILD_DIR )
)
rem TODO only add if build dir not exists
echo %BUILD_DIR%/>>.gitignore
:SKIP_APPEND_BUILD_DIR


FOR /F "delims=" %%a in (.gitignore) DO (
	IF "%%a" == "node_modules/" ( GOTO SKIP_APPEND_NODE_MODULES )
)
echo node_modules/>>.gitignore
:SKIP_APPEND_NODE_MODULES


rem commit and push to master
git add .
git commit -m "init"
git push --set-upstream origin master

rem create build dir
mkdir %BUILD_DIR%

rem clone repo to build dir
cd %BUILD_DIR%

rem echo delete all folder not .git in working dir
for /D %%F in (*) do (
   rd %%F /Q /S
)
rem echo delete all file in working dir
for %%F in (*) do (
   del %%F /Q /S
)

git clone %REPO% .

rem create and switch to gh-pages branch
git checkout -B gh-pages

rem echo delete all folder not .git in working dir
for /D %%F in (*) do (
   if NOT %%F == ".git" rd %%F /Q /S
)
rem echo delete all file in working dir
for %%F in (*) do (
   del %%F /Q /S
)

rem set gh-pages as default remote branch cua repo trong folder build
git push --set-upstream origin gh-pages

rem delete master branch in build folder
git branch -d master

rem push changes to remote
git add .
git commit -m "init"
git push

