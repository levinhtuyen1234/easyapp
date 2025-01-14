@echo off

set datetime=%date% %time%

cd build
git checkout gh-pages
git branch --set-upstream-to=origin/gh-pages
git pull origin gh-pages -s recursive -X ours
git add .
git commit -m "%datetime%"
git push origin HEAD:gh-pages
