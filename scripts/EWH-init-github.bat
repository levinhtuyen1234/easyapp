@echo off
rem ------------------------------------------------
rem | SCRIPT CHỈ HOẠT ĐỘNG KHI REPO LÀ 1 REPO RỖNG |
rem ------------------------------------------------

set "REPO=%1"
set "BUILD_DIR=build"

call :GETTEMPNAME

git init
git remote add origin %REPO%

rem add build dir vo .gitignore file
echo %BUILD_DIR%/>>.gitignore
rem commit and push to master
git add .
git commit -m "init"
git push --set-upstream origin master

rem create build dir
mkdir %BUILD_DIR%
rem clone repo to build dir
cd %BUILD_DIR%
git clone %REPO% .

rem create and switch to gh-pages branch
git checkout -b gh-pages

rem delete all folder not .git in working dir
for /D %%F in (*) do (
   if NOT %%F == ".git" rd %%F /Q /S
)
rem delete all file in working dir
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

rem back to site repo dir
cd ..
rem install all deps
npm install


goto :EOF

:GETTEMPNAME
set TMPFOLDER=%TMP%\EWH-%RANDOM%
if exist "%TMPFOLDER%" GOTO :GETTEMPNAME 

:EOF