@echo off

set datetime=%date% %time%

git branch --set-upstream-to=origin/master
rem pull update from remote, use remote changes if conflict happen
git pull -X ours
rem add all files
git add .
rem commit
git commit -m "%datetime%"
rem push local commit to remote force use mine
git push -f origin master
