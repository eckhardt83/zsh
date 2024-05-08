#!/bin/bash

# Funktion til at installere plugins
function install_plugins {
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-autosuggestions
    git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-bat
    git clone https://github.com/ael-code/zsh-colored-man-pages.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-colored-man-pages
    git clone https://github.com/Freed-Wu/zsh-colorize-functions.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-colorize-functions
    git clone https://github.com/qoomon/zsh-lazyload.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-lazyload
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-syntax-highlighting
    echo "Plugins er installeret, have a nice day :)"
}

# Angiv stien til plugin-mappen
DIR=~/.config/zsh/plugins

# Kontroller om plugin-mappen allerede findes
if [ -d "$DIR" ]; then
    echo "Plugin-mappen eksisterer allerede. Installerer plugins..."
    install_plugins
else
    echo "Opretter plugin-mappen..."
    mkdir -p ~/.config/zsh/plugins
    echo "Installerer plugins..."
    install_plugins
fi

# Afslut scriptet
exit 0
