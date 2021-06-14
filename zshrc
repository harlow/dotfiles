# init rbenv
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

PATH=./bin:$PATH
PATH=~/.bin:$PATH
PATH=~/go/bin:$PATH
PATH=~$HOME/.cargo/bin:$PATH

# don't cache the bin files
set +h
setopt prompt_subst

# use vim as an editor
export EDITOR=vim
export BUNDLER_EDITOR=code

# load custom env vars
source "$HOME/.env.local"

# aliases
if [ -e "$HOME/.aliases" ]; then
  source "$HOME/.aliases"
fi

# branch name
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# function precmd() {
#    current_git_branch=`git rev-parse --abbrev-ref HEAD`
#}

PS1='%F{green}%2~%F{yellow}$(parse_git_branch) %F{grey}$%F{grey} '

# kubes env helpers
switch_env() {
  eval "$(cb env "$1")" && echo $1 > ~/.clearbit-env
}

dev()  { switch_env 'us-west-1.dev-2'     && echo "Switched to development"; }
stag() { switch_env 'us-west-1.staging-2' && echo "Switched to staging"; }
prod() { switch_env 'us-west-1.prod'      && echo "Swiched to production";}

alias robo="robo --config ~/code/clearbit/robofiles/robo.yml"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
