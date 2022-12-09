#!/usr/bin/env sh

# This script download, install and sync dotfiles from a git repository. This
# layout makes it compatible with Github Codespaces, where only the dotfiles are
# being copied.

set -e

# Config
BRANCH="main"
# URL=https://github.com/piranna/dotfiles
URL=git@github.com:piranna/dotfiles.git

# Constants
BLACKLIST="dotfiles.sh LICENSE README.md"
GIT_PULL="git pull origin $BRANCH --allow-unrelated-histories"


# Work on $HOME folder
cd $HOME

# Check if $HOME has already defined dotfiles, or could overwrite something
[ -d ".git"        ] && { >&2 echo "Already is a git project"      ; exit 1; }
[ -d ".gitignore"  ] && { >&2 echo "Already has a .gitignore file" ; exit 2; }
[ -d "dotfiles.sh" ] && { >&2 echo "Already has a dotfiles.sh file"; exit 3; }
[ -d "LICENSE"     ] && { >&2 echo "Already has a LICENSE file"    ; exit 4; }
[ -d "README.md"   ] && { >&2 echo "Already has a README.md file"  ; exit 5; }

# Create local repository
git init --initial-branch=$BRANCH
git remote add origin $URL

# Commit conflicting files
git add `$GIT_PULL 2>&1 | grep '^	'`
cat /etc/hostname | git commit -F -

# Merge the dotfiles repository
while ! $GIT_PULL --no-rebase
do
  echo "Fix the conflicts in another shell and press enter to continue..."
  read REPLY  # POSIX shell requires at least one argument, also if not used
done

# Update the dotfiles repository
git push origin $BRANCH

# Remove repo non-needed files
rm -f $BLACKLIST
git update-index --skip-worktree $BLACKLIST
git gc --aggressive --prune=now
