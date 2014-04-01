# the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# load up hub
if which hub > /dev/null; then eval "$(hub alias -s)"; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
