autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '(%F{green}%b%c%u%F{grey})'
zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{red}!'

precmd () {
  vcs_info
}

__convox_switch() { [ -e ~/.convox/rack ] && convox switch || echo unknown; }

PROMPT='%F{grey}%3~${vcs_info_msg_0_} [$(__convox_switch)] %F{grey}$%F{grey} '
