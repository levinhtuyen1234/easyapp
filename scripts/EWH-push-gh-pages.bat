@echo off

set datetime=%date% %time%

cd build
git checkout gh-pages
git add .
git commit -m "%datetime%"
git push origin gh-pages
