# add to path
export PATH="$HOME/code/go/bin:$HOME/code/go/go_appengine:$HOME/.bin:/usr/local/sbin:/usr/local/bin:$PATH"
export GOPATH="$HOME/code/go"
export DOCKER_HOST="tcp://$(boot2docker ip 2>/dev/null):2376"
export DOCKER_TLS_VERIFY=1
export DOCKER_CERT_PATH=/Users/harlow/.boot2docker/certs/boot2docker-vm
export GOBIN="$GOPATH/bin"
export PYTHONPATH="/usr/local/lib/python2.7/site-packages"
export JAVA_HOME=$(/usr/libexec/java_home)

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
compinit

# automatically enter directories without cd
setopt auto_cd

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
