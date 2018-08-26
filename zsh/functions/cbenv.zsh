dev() {
  eval "$(cb env us-west-1.dev-2)" &&
    echo "CB_ENV=$(clearbit-env)" > ~/.cbenv
}

stag() {
  eval "$(cb env us-west-1.staging-2)" &&
    echo "CB_ENV=$(clearbit-env)" > ~/.cbenv
}

prod() {
  eval "$(cb env us-west-1.prod)" &&
    echo "CB_ENV=$(clearbit-env)" > ~/.cbenv
}

if [ -e "$HOME/.cbenv" ]; then
  source "$HOME/.cbenv"
fi

eval $(cb env $CB_ENV)
