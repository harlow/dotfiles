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
