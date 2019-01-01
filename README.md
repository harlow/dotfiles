Install
-------

Clone dotfiles repository:

    $ git clone git@github.com:harlow/dotfiles.git
    $ cd dotfiles

Create symlinks for all dot files and scripts in bin. You can safely run this
file multiple times to update.

    $ ./install.sh

Install custom VIM plugins with Vundle:

    git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

Manage the list of vim plugins in `vimrc.bundles`.

    :BundleInstall

There is configuration for `zsh` so switch your shell from the default `bash`
to `zsh` on OS X.

    $ chsh -s /bin/zsh

Make sure `ctags` are set up correctly.

    $ brew install ctags
    $ alias ctags="`brew --prefix`/bin/ctags"
    $ ctags -R

Keyboard Modifiers
------------------

https://pqrs.org/osx/karabiner/index.html
https://pqrs.org/osx/karabiner/complex_modifications/#caps_lock
