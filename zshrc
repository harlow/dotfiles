# new path
export PATH="./bin:/usr/local/bin:$PATH"

# Add RVM to PATH for scripting
PATH=$PATH:$HOME/.rvm/bin

if [[ -s /Users/harlow/.rvm/scripts/rvm ]] ; then
  source /Users/harlow/.rvm/scripts/rvm ;
fi

# aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# load completion and func paths
fpath=(~/.zsh/completion $fpath)

# set bell to silent
set bell-style visible

# completion
autoload -U compinit
compinit

# automatically enter directories without cd
setopt auto_cd

# use vim as an editor
export EDITOR=mvim

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

# load customized prompt
setopt promptsubst
autoload -U promptinit
promptinit
prompt hrw

# load ctags user local
ctags=/usr/local/bin/ctags

# matches case insensitive for lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# load up hub
eval "$(hub alias -s)"
