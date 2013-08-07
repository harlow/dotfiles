# add to path
export PATH="$HOME/code/go/bin:$HOME/.bin:/usr/local/sbin:/usr/local/bin:$PATH"
export GOPATH="$HOME/code/go"

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
compinit

# automatically enter directories without cd
setopt auto_cd

# use vim as an editor
export EDITOR=vim

# vi mode
bindkey -v
bindkey "^F" vi-cmd-mode

# use incremental search
bindkey "^R" history-incremental-search-backward

# ignore duplicate history entries
setopt histignoredups

# keep more history
export HISTSIZE=200

# look for ey config in project dirs
export EYRC=./.eyrc

# load ctags user local
ctags=/usr/local/bin/ctags
