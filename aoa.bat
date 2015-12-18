
cp -force -r build/. tmp/

git checkout gh-pages

cp -force -r tmp/* ./

rm -r -force tmp/

git pull

git add .

git commit -m "gh-pages"

git push -u origin gh-pages

git checkout master

git push -u origin master






