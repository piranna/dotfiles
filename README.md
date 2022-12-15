# Dotfiles

Install and keep updated `$HOME` dotfiles on multiple machines

This repo host a copy of my personal `$HOME` dotfiles, and also inclues a POSIX
shell script to easily install and keep them updated on multiple machines. It also follows a files scheme that's compatible with
[Github Codespaces](https://docs.github.com/en/codespaces/customizing-your-codespace/personalizing-github-codespaces-for-your-account#dotfiles).

**Warning**: be sure you don't have any secret or credential stored in your
config files, **NEVER** add them to files uploaded to a git repository,
specially if it will be a public one.

## How to use

1. Fork this repo
2. Update `URL` variable [dotfiles.sh](./dotfiles.sh) file to point to the
   forked repository. Also update any of the other constants or config variables
   if needed.
3. Install `git` command on the target machine (AKA your own laptop)
4. Ensure target machine has been correctly config to access to the forked
   repository, for example by copying to the `$HOME` folder a valid
   `.git-credentials` file if accesing with HTTP, or a `.ssh` folder with a
   properly configured SSH public/private key pair if accessing with SSH.
5. Execute the script:

   ```sh
   curl https://raw.github.com/piranna/dotfiles/blob/main/dotfiles.sh | sh
   ```

6. Fix any git conflict that's shown on the command line output on another
   terminal until there's no more conflict errors.

## How it works

1. Get into user `$HOME` directory and checks that's not already a git
   repository from a previous install, both from us or any other similar
   dotfiles tool.
2. Init a git repository in the `$HOME` directory itself, and config the remote
   one.
3. Get local files that has conflicts with the ones on remote repository, and
   commit them.
4. Get all files from remote repository and ask user to fix any git conflict
   until there's none of them.
5. Upload merged configs to remote repository to keep them sync'ed.
6. Remove repo files unneeded in local (readme, license, and install script)
   and clean local repository.
