#!/bin/bash

# Funktion til at installere plugins
install_plugins() {
    install_theme
    # Tilføj her andre plugins, hvis nødvendigt
}

# Funktion til at installere et tema (f.eks. Powerlevel10k)
install_theme() {
    local theme_dir="${ZSH_CUSTOM:-~/.config/zsh}/theme"
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir/powerlevel10k"
    echo "Powerlevel10k theme er installeret."
}

# Kontroller om tema-mappen eksisterer
theme_dir="$HOME/.config/zsh/theme"
if [ -d "$theme_dir" ]; then
    echo "Plugin-mappen eksisterer."
    install_plugins
else
    echo "Opretter plugin-mappe..."
    mkdir -p "$theme_dir"
    echo "Plugin-mappen er oprettet."
    install_plugins
fi

echo "Plugins er installeret. Hav en god dag!"
