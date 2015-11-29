
cp -f -r build/. tmp/

git checkout gh-pages

git pull

cp -f -r tmp/. ./

rm -rf tmp/


git add .

git commit -m "gh-pages"

git push -u origin gh-pages

git checkout master

git push -u origin master






