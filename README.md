Install
-------

Clone dotfiles repository:

    $ git clone git@github.com:harlow/dotfiles.git
    $ cd dotfiles
    $ ./install/symlinks.sh

This will create symlinks for all config files in your home directory. You can
safely run this file multiple times to update.

Clone all of the VIM repos for Pathogen:

For additional vim plugins add to the array in `install_bundles.sh` file.

    $ mkdir vim/bundle
    $ ./install/bundles.sh

There is configuration for `zsh` so switch your shell from the default `bash` 
to `zsh` on OS X:

    $ chsh -s /bin/zsh

Make sure `ctags` are set up correctly

    $ brew install ctags
    $ alias ctags="`brew --prefix`/bin/ctags"
    $ ctags -R

Usage
-------

#### Run Command

Run RSpec Tests and other commands from MacVim

```ruby
# runs current test under the cursor
<leader> l

# runs last test
<leader> r

# runs all tests in current file
<leader> t

# refreshes open tab in google chrome
<leader> rl
```