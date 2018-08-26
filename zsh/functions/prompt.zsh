autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '(%F{green}%b%c%u%F{grey})'
zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{red}!'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

### git: Show marker (T) if there are untracked files in repository
# Make sure you have added staged to your 'formats':  %c
function +vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | fgrep '??' &> /dev/null ; then
        # This will show the marker if there are any untracked files in repo.
        # If instead you want to show the marker only if there are untracked
        # files in $PWD, use:
        #[[ -n $(git ls-files --others --exclude-standard) ]] ; then
        hook_com[unstaged]+='%F{red}?%f'
    fi
}

precmd () {
  vcs_info
}

function cbenv {
  if [[ $(clearbit-env) == 'us-west-1.prod' ]]; then
      echo '%F{red}±%F{red}' && return
  fi
  if [[ $(clearbit-env) == 'us-west-1.staging-2' ]]; then
      echo '%F{yellow}±%F{yellow}' && return
  fi
  if [[ $(clearbit-env) == 'us-west-1.dev-2' ]]; then
    echo '%F{blue}±%F{blue}' && return
  fi
}

PROMPT='$(cbenv) %F{grey}%2~${vcs_info_msg_0_} %F{grey}$%F{grey} '
