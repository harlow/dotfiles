# add to path
export PATH="./bin:/usr/local/bin:$HOME/code/go/bin:$HOME/.bin:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH=$PATH:/Users/harlow/Downloads/go_appengine/
export GOPATH="$HOME/code/go"
export GOBIN="$GOPATH/bin"

# don't cache the bin files
set +h

# load custom env vars
source "$HOME/.env.local"

# load function files
for file in ~/.zsh/functions/*; do
  source $file
done

# aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# set bell to silent
set bell-style visible

# load completion and func paths
fpath=(~/.zsh/completion $fpath)
autoload -U compinit

# use vim as an editor
export EDITOR=vim
export BUNDLER_EDITOR=subl

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode

# use incremental search
bindkey "^R" history-incremental-search-backward

# ignore duplicate history entries
setopt histignoredups

# keep more history
export HISTSIZE=200
export SAVEHIST=200
export HISTFILE=~/.history

# load ctags user local
ctags=/usr/local/bin/ctags

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
