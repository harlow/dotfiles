Install
-------

Clone dotfiles repository:

    $ git clone git@github.com:harlow/dotfiles.git
    $ cd dotfiles

Create symlinks for all config files and scripts in bin. You can safely run this
file multiple times to update.

    $ ./install/symlinks.sh

Clone all of the VIM repos for Pathogen:

For additional vim plugins add to the array in `install/bundles.sh` file.

    $ mkdir vim/bundle
    $ ./install/bundles.sh

There is configuration for `zsh` so switch your shell from the default `bash`
to `zsh` on OS X.

    $ chsh -s /bin/zsh

Make sure `ctags` are set up correctly.

    $ brew install ctags
    $ alias ctags="`brew --prefix`/bin/ctags"
    $ ctags -R

Usage
-------

#### Run Command

Run RSpec Tests and other commands from MacVim

```ruby
<leader> l          # runs current test under the cursor
<leader> r          # runs last test
<leader> t          # runs all tests in current file
<leader> rl         # refreshes open tab in google chrome
```
