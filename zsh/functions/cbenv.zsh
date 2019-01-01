dev() {
  eval "$(cb env us-west-1.dev-2)" &&
    eval "export CB_ENV=us-west-1.dev-2" &&
    echo "CB_ENV=us-west-1.dev-2" > ~/.cbenv
}

stag() {
  eval "$(cb env us-west-1.staging-2)" &&
    eval "export CB_ENV=us-west-1.staging-2" &&
    echo "CB_ENV=us-west-1.staging-2" > ~/.cbenv
}

prod() {
  eval "$(cb env us-west-1.prod)" &&
    eval "export CB_ENV=us-west-1.prod" &&
    echo "CB_ENV=us-west-1.prod" > ~/.cbenv
}

if [ -e "$HOME/.cbenv" ]; then
  source "$HOME/.cbenv"
fi

eval $(cb env $CB_ENV)
