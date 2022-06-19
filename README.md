# Configuration files for my arch linux rice
Powered by [GNU-stow](https://www.gnu.org/software/stow/manual/stow.html)

## Instalation
```sh
# Simulate first, to test what it will do
stow -nvt ~ */

# Then install
stow -vt ~ */
```
Update dotfiles

```sh
# Simulate first
stow --adopt -nvt ~ */

# Then update
stow --adopt -vt ~ */
```
## About .config .local
There are two folders where you can find configuration that will endup in `~/.config` and `~/.local`, these are

```sh
# My personal configurations, all of the folders excluding ./lukeconfig

# Forked configurations from other persons 
./lukeconfig
```

## ZSH Aliases
There are two places where to put aliases

```bash
#1. General purpose aliases
./zsh/.myaliasrc
#2 Local aliases to the machie
./.localalias
```
