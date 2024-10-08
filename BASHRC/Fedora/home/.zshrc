#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# Ultramarine ZSH config
# initialize starship
eval "$(starship init zsh)"

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Ctrl + Arrow keybindings
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Ctrl + Backspace/Delete Kebindings
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word

# ALt + Backspace/Delete Keybinds
bindkey "^[[3~" delete-char
bindkey -M emacs '^[[3;3~' kill-word

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY

[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

# reporting tools - install when not installed
#neofetch

fortune

###  Enable if GNome is your DE ###
# Check whether if the windowing system is Xorg or Wayland windowing system and set environment variables accordingly
# Tolga Erok

if [[ ${XDG_SESSION_TYPE} == "wayland" ]]; then
    export MOZ_ENABLE_WAYLAND=1
    export OBS_USE_EGL=1
    echo "Running on Wayland: Enabled Wayland-specific settings."
    echo "" && sleep 1

elif [[ ${XDG_SESSION_TYPE} == "x11" ]]; then
    export MOZ_ENABLE_WAYLAND=0
    export OBS_USE_EGL=0
    echo "Running on Xorg: Disabled Wayland-specific settings."
    echo "" && sleep 1
else
    echo "Unknown windowing system: ${XDG_SESSION_TYPE}. No changes made."
    echo "" && sleep 1
fi

echo "" && fortune | lolcat && echo ""
