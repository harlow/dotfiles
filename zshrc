# add to path
export PATH="./bin:/usr/local/bin:$HOME/go/bin:$HOME/.bin:$PATH"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin
export PATH=$PATH:/usr/local/bin/mysql
export PATH=$PATH:/usr/local/opt/go/libexec/bin
# export PATH=$PATH:/Users/harlow/code/go/src/github.com/uber/go-torch/FlameGraph

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
# bindkey -v
# bindkey "^F" vi-cmd-mode

# use incremental search
# bindkey "^R" history-incremental-search-backward

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

eval $(docker-machine env default)

# PATH="/Users/harlow/perl5/bin${PATH:+:${PATH}}"; export PATH; */
# PERL5LIB="/Users/harlow/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB; */
# PERL_LOCAL_LIB_ROOT="/Users/harlow/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT; */
# PERL_MB_OPT="--install_base \"/Users/harlow/perl5\""; export PERL_MB_OPT; */
# PERL_MM_OPT="INSTALL_BASE=/Users/harlow/perl5"; export PERL_MM_OPT; */

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/harlow/Downloads/google-cloud-sdk/path.zsh.inc' ]; then source '/Users/harlow/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/harlow/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then source '/Users/harlow/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

USER_BASE_PATH=$(python -m site --user-base)
export PATH=$PATH:$USER_BASE_PATH/bin

