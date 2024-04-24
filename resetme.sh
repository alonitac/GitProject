#!/bin/bash

repo=$1
link=$2

# GitProject=$1
# https://github.com/CodesParadox/GitProject.git=$2


git remote add $repo $link 2>/dev/null || true
# Fetch all branches from the remote repo without adding a prefix
git fetch $repo '+refs/heads/:refs/remotes/$repo/'

# List all remote branches from the remote repo
remote_branches=$(git branch -r | grep "$repo/" | sed "s|$repo/||")

# Iterate through each remote branch, create a local branch, fetch, merge, reset, and push
for branch in $remote_branches; do
    # Create a local branch tracking the remote branch & Extracting the branch name after the /
    local_branch="${branch#*/}"
    git checkout -b "$local_branch" "$repo/$local_branch"
    # Fetch the latest changes from the remote repo
    git fetch "$repo" "$local_branch"
    # Merge the local branch into your current branch
    git merge "$local_branch"
    # Reset to the state of the remote branch
    git reset --hard "$repo/$local_branch"
    # Push the changes to my origin fork
    git push --set-upstream origin "$local_branch"
done

git remote remove $repo