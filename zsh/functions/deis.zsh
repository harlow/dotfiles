# Deis env
dev() {
  eval "$(clearbit-env dev)" &&
    echo "DEIS_ENV=$(clearbit-env)" > ~/.deisenv
}

stag() {
  eval "$(clearbit-env staging)" &&
    echo "DEIS_ENV=$(clearbit-env)" > ~/.deisenv
}

prod() {
  eval "$(clearbit-env production)" &&
    echo "DEIS_ENV=$(clearbit-env)" > ~/.deisenv
}

if [ -e "$HOME/.deisenv" ]; then
  source "$HOME/.deisenv"
fi

eval $(clearbit-env $DEIS_ENV)
