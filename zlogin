# the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# initialize rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# patch in gh
eval "$(gh alias -s)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
