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

function deisenv {
  if [[ $(clearbit-env) == 'production' ]]; then
      echo '%F{red}[prod]%F{red}' && return
  fi
  if [[ $(clearbit-env) == 'staging' ]]; then
      echo '%F{yellow}[stag]%F{yellow}' && return
  fi
  echo '%F{blue}[dev]%F{blue}'
}

PROMPT='$(deisenv) %F{grey}%2~${vcs_info_msg_0_} %F{grey}$%F{grey} '
