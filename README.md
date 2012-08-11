Install
-------

Clone dotfiles repository:

    $ git clone git@github.com:harlow/dotfiles.git
    $ cd dotfiles
    $ ./install.sh

This will create symlinks for all config files in your home directory. You can
safely run this file multiple times to update.

Clone all of the VIM repos for Pathogen:

For additional vim plugins add to the array in `install_bundles.sh` file.

    $ mkdir vim/bundle
    $ ./install_bundles.sh

There is configuration for `zsh` so switch your shell from the default `bash` 
to `zsh` on OS X:

    $ chsh -s /bin/zsh
