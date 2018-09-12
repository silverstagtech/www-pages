#!/bin/bash
CNAME=www.silverstagtech.com

echo "Deleting old publication"
rm -rf public

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Starting Publish process"
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public \
&& echo $CNAME >> ./CNAME \
&& git add --all \
&& git commit -m "Publishing to gh-pages (publish.sh) $(date)"

if [[ $? ]]; then
    echo "Publishing to Github"
    git push
else
    echo "Something went wrong! Stopping."
fi
