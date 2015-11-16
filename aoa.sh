#!/bin/sh


# bundle exec middleman build --clean

# git add .


# cd build

# cp -f -r . ../

# git push 


cp -f -r build/. tmp/

git checkout gh-pages

cp -f -r tmp/. ./

rm -rf tmp/

git add .

git commit -m "gh-pages"

git push

git checkout master

git push






