@echo off

set datetime=%date% %time%

git branch --set-upstream-to=origin/master
git pull
git add .
git commit -m "%datetime%"
git push origin master
