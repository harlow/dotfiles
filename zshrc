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

# customized prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{red}!'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git

precmd () {
  if [ -d "$PWD/.git" ]; then
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
      zstyle ':vcs_info:*' formats '(%F{green}%b%c%u%F{white})'
    } else {
      zstyle ':vcs_info:*' formats '(%F{green}%b%c%u%F{red}?%F{white})'
    }
  fi
  vcs_info
}

PROMPT='%3~${vcs_info_msg_0_} %F{yellow}$%F{white} '

# load ctags user local
ctags=/usr/local/bin/ctags

# load up hub
eval "$(hub alias -s)"
