@echo off

set datetime=%date% %time%

git pull
git add .
git commit -m "%datetime%"
git push origin master
