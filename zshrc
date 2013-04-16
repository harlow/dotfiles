# new path
export PATH="/Users/harlow/.bin:/usr/local/sbin:/usr/local/bin:$PATH"

# load config files
for file in ~/.zsh/config/**/*.zsh; do
  source $file
done

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

# load ctags user local
ctags=/usr/local/bin/ctags

# load up hub
eval "$(hub alias -s)"

# load rvenv
eval "$(rbenv init -)"

# kafka
export KAFKA_HOME=/usr/local/kafka_install/kafka
export KAFKA=$KAFKA_HOME/bindkey
export KAFKA_CONFIG=$KAFKA_HOME/config
