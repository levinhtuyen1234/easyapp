@echo off

set "PATH=%PATH%;%~dp0..\tools\7z\"
rem set working directory to project dir
pushd %~dp0..
call electron-packager . EasyWebBuilder --platform=win32 --arch=x64 --ignore=ewh-win32-x64 --ignore=dist --ignore=tools --ignore=data --ignore=.idea --ignore=sites --ignore=scripts --asar=true --overwrite
popd
echo compressing
pushd %~dp0..\ewh-win32-x64
7za a -scsUTF-8 %~dp0..\dist\ewh.zip * %~dp0..\tools %~dp0..\scripts
popd

rem clean up
rd %~dp0..\ewh-win32-x64 /Q /S 

pause