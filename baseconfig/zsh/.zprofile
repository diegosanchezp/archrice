# Append "$1" to $PATH when not already in.
# This function was copied from /etc/profile
append_path () {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
            PATH="${PATH:+$PATH:}$1"
    esac
}

append_path ~/.npm-global/bin
append_path "$HOME/.poetry/bin"
append_path "$HOME/.local/bin"

# Force PATH to be environment
export PATH

export SUDO_EDITOR=nvim
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export PAGER='nvim -R -c "set ft=help"'
export OPENER=xdg-open
# change later to /opt/nvm
export NVM_DIR="/home/diego/.nvm"
export UID=$(id -u)
export GID=$(id -g)

[ -f "$HOME/.local_zprofile" ] && source "$HOME/.local_zprofile"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
