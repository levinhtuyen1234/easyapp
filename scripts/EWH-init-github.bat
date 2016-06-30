@echo off
rem ------------------------------------------------
rem | SCRIPT CHỈ HOẠT ĐỘNG KHI REPO LÀ 1 REPO RỖNG |
rem ------------------------------------------------

set "REPO=%1"
set "BUILD_DIR=build"

call :GETTEMPNAME

git init
git remote add origin %REPO%

echo ---add build dir vo .gitignore file
echo %BUILD_DIR%/>>.gitignore
echo ---commit and push to master
git add .
git commit -m "init"
git push --set-upstream origin master

echo ---create build dir
mkdir %BUILD_DIR%
echo ---clone repo to build dir
cd %BUILD_DIR%
git clone %REPO% .

echo ---create and switch to gh-pages branch
git checkout -b gh-pages

echo ---remove .gitignore rac' tu` master
rem del /Q .gitignore
rem delete all folder not .git in working dir
for /D %%F in (*) do (
   if NOT %%F == ".git" rd %%F /Q /S
)
rem delete all file in working dir
for %%F in (*) do (
   del %%F /Q /S
)

echo ---set gh-pages as default remote branch cua repo trong folder build
git push --set-upstream origin gh-pages

echo ---delete master branch in build folder
git branch -d master

echo ---push changes to remote
git add .
git commit -m "init"
git push

echo ---back to site repo dir
cd ..
echo ---install all deps
npm install


goto :EOF

:GETTEMPNAME
set TMPFOLDER=%TMP%\EWH-%RANDOM%
if exist "%TMPFOLDER%" GOTO :GETTEMPNAME 

:EOF