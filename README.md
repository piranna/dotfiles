# Dotfiles

Install and keep updated `$HOME` dotfiles on multiple machines

This repo host a copy of my personal `$HOME` dotfiles, and also inclues a POSIX
shell script to easily install and keep them updated on multiple machines. It
also follows a files scheme that's compatible with
[Github Codespaces](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles).

**Warning**: be sure you don't have any secret or credential stored in your
config files, **NEVER** add them to files uploaded to a git repository,
specially if it will be a public one.

## How to install

1. Fork this repo
2. Install `git` command on the target machine (AKA your own laptop)
3. Ensure target machine has been correctly config to access to the forked
   repository, for example by copying to the `$HOME` folder a valid
   `.git-credentials` file if accesing with HTTP, or a `.ssh` folder with a
   properly configured SSH public/private key pair if accessing with SSH.
4. Execute the script:

   ```sh
   URL_PATH=piranna/dotfiles

   URL_PATH=$URL_PATH \
     curl https://raw.github.com/${URL_PATH}/blob/main/dotfiles.sh \
     | URL=<your-dotfiles-git-repo-url> sh
   ```

5. Fix any git conflict that's shown on the command line output on another
   terminal until there's no more conflict errors.
6. Optionally, commit and push any other change you want to keep in your forked
   repository.

## How to update

Being powered by `git`, you can make use of all usual git workflows:

- If config files in remote repository has been updated, just do `git pull` and
  fix conflicts.
- If local config files have changed, just add and push them as usual.
- If you want to add a new config file, do it with `git add` giving explicitly
  the file path to override the included global `.gitignore` file.

## How it works

1. Get into user `$HOME` directory and checks that there's not already a git
   repository from a previous install, both from us or any other similar
   dotfiles tool.
2. Init a git repository in the `$HOME` directory itself, and config the remote
   one.
3. Get local files that has conflicts with the ones on remote repository, and
   commit them, to keep track of their original content.
4. Get all files from remote repository and ask user to fix any git conflict
   until there's none of them.
5. Upload merged configs to remote repository to keep them sync'ed.
6. Remove repo files unneeded in local (readme, license, and install script)
   and clean local repository.
