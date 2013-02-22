autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{red}!'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '(%F{green}%b%c%u%F{white})'

precmd () {
  vcs_info
}

PROMPT='%3~${vcs_info_msg_0_} %F{yellow}$%F{white} '