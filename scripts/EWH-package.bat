@echo off

set "PATH=%PATH%;%~dp0..\tools\7z\"
set "APP_NAME=EasyWebBuilder"
set "PLATFORM=win32"
set "ARCH=x64"

set "BUILD_FOLDER_NAME=%APP_NAME%-%PLATFORM%-%ARCH%"
rem set working directory to project dir
pushd %~dp0..
call electron-packager . %APP_NAME% --platform=%PLATFORM% --arch=%ARCH% --ignore=%BUILD_FOLDER_NAME% --ignore=dist --ignore=tools --ignore=data --ignore=.idea --ignore=sites --ignore=scripts --asar=true --overwrite
popd
echo compressing
pushd %~dp0..\%BUILD_FOLDER_NAME%
7za a -scsUTF-8 %~dp0..\dist\%APP_NAME%.zip * %~dp0..\tools %~dp0..\scripts
popd

rem clean up
rd %~dp0..\%BUILD_FOLDER_NAME% /Q /S 

pause