# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="refined"

plugins=( 
    git
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
)


source $ZSH/oh-my-zsh.sh

# Check archlinux plugin commands here
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/archlinux


# Display Pokemon-colorscripts
# Project page: https://gitlab.com/phoneybadger/pokemon-colorscripts#on-other-distros-and-macos
pokemon-colorscripts -r


### From this line is for pywal-colors
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
# Not supported in the "fish" shell.
#(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
#cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
#source ~/.cache/wal/colors-tty.sh

# BAT THEME
export BAT_THEME=Coldark-Dark

# My alias

alias ls='exa'
alias ll='ls -la'
alias c='clear'
alias f='fuck'
alias s='source ~/.zshrc'
alias n='sudo nano ~/.zshrc'
alias nf='neofetch'
alias cd='z'
alias g='g++ -std=c++17 -O2 -Wall -Wno-unused-variable'
alias open='thunar . & disown'
# alias dime='discord --enable-wayland-ime'
# alias oime='obsidian --enable-wayland-ime'
alias ci='zi'
alias show='hyprctl clients'
alias connect='nmcli connection up'
alias disconnect='nmcli connection down'
alias to='. ranger'
alias lock='swaylock -C ~/.config/swaylock_config'

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)
eval "$(zoxide init zsh)"
eval $(thefuck --alias)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$HOME/.cargo/bin:$PATH"
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/shiro/.lmstudio/bin"
# End of LM Studio CLI section

