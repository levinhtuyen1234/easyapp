@echo off

set datetime=%date% %time%

git branch --set-upstream-to=origin/master
rem pull update from remote, use ours changes if conflict happen
git pull -s recursive -X theirs
rem add all files
git add .
rem commit
git commit -m "%datetime%"
rem push local commit to remote force use mine
git push -f origin master
