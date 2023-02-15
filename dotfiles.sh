#!/usr/bin/env sh

# This script download, install and sync dotfiles from a git repository. This
# layout makes it compatible with Github Codespaces, where only the dotfiles are
# being copied.

set -e

# Config
${URL_PATH:?missing URL_PATH environment variable}  # exit if not defined

${BRANCH:="main"}
${GITHUB_DOMAIN:="github.com"}
${URL:=git@${GITHUB_DOMAIN}:${URL_PATH}.git}

# Constants
BLACKLIST="dotfiles.sh LICENSE README.md"
GIT_PULL="git pull origin $BRANCH --allow-unrelated-histories"


install()
{
  # Check if $HOME has already defined dotfiles, or could overwrite something
  [ -e ".git"        ] && { >&2 echo "Already is a git repository"   ; exit 3; }
  [ -e ".gitignore"  ] && { >&2 echo "Already has a .gitignore file" ; exit 4; }
  [ -e "dotfiles.sh" ] && { >&2 echo "Already has a dotfiles.sh file"; exit 5; }
  [ -e "LICENSE"     ] && { >&2 echo "Already has a LICENSE file"    ; exit 6; }
  [ -e "README.md"   ] && { >&2 echo "Already has a README.md file"  ; exit 7; }

  # Create local repository
  git init --initial-branch=$BRANCH
  git remote add origin $URL

  # Get conflicting files
  stderr=`$GIT_PULL 2>&1`
  files=`echo "$stderr" | grep '^	'`

  # TODO: diferenciate between errors and no conflicting files
  [ -z "$files" ] && { >&2 echo $stderr ; exit 8; }

  # Commit conflicting local files
  git add $files
  echo Initial commit: `cat /etc/hostname` | git commit -F -

  # Merge the dotfiles repository
  while ! $GIT_PULL --no-rebase
  do
    echo
    echo "Fix the conflicts in another shell and press enter to continue..."
    read REPLY  # POSIX shell requires at least one argument, also if not used
  done

  # Update the dotfiles repository
  git push origin $BRANCH

  remove_blacklisted
}

# Remove repo files not-needed in local
remove_blacklisted()
{
  rm -f $BLACKLIST
  git update-index --skip-worktree $BLACKLIST
  git gc --aggressive --prune=now
}


# Work on $HOME folder
cd $HOME

case $1 in
	""|install)
		install
    ;;

	remove_blacklisted)
		remove_blacklisted
		;;

	*)
		exit 64
		;;
esac
