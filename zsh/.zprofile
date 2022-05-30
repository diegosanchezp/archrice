export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.poetry/bin:$PATH"
export SUDO_EDITOR=nvim
export EDITOR=nvim
export OPENER=xdg-open
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
