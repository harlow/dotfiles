Install
-------

Clone repository:

    $ git clone git@github.com:harlow/dotfiles.git
    $ cd dotfiles
    $ ./install.sh

This will create symlinks for all config files in your home directory. You can
safely run this file multiple times to update.

There is configuration for `zsh` so switch your shell from the default `bash` to `zsh` on OS X:

    $ chsh -s /bin/zsh
    
Now clone all of the repos for VIM Pathogen

    $ mkdir vim/bundle
    $ ./vim/update_bundles