export PATH=~/.npm-global/bin:$PATH
export PATH="$HOME/.poetry/bin:$PATH"
export SUDO_EDITOR=nvim
export EDITOR=nvim
export OPENER=xdg-open
# change later to /opt/nvm
export NVM_DIR="/home/diego/.nvm"
export UID=$(id -u)
export GID=$(id -g)

[ -f "$HOME/.local_zprofile" ] && source "$HOME/.local_zprofile"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
