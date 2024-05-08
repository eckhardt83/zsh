#!/bin/bash

# Funktion til at installere Zsh på Ubuntu
function install_zsh_ubuntu {
    echo "Installerer Zsh på Ubuntu..."
    sudo apt update && sudo apt install -y zsh
}

# Funktion til at installere Zsh på Fedora
function install_zsh_fedora {
    echo "Installerer Zsh på Fedora..."
    sudo dnf install -y zsh
}

# Funktion til at installere Zsh på Arch Linux
function install_zsh_arch {
    echo "Installerer Zsh på Arch Linux..."
    sudo pacman -Sy --noconfirm zsh
}

# Funktion til at installere Zsh på NixOS
function install_zsh_nixos {
    echo "Installerer Zsh på NixOS..."
    sudo nix-env -iA nixos.zsh
}

# Funktion til at installere Zsh-plugins
function install_zsh_plugins {
    echo "Installerer Zsh-plugins..."
    function install_plugins {
        git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.config/zsh/plugins/zsh-autosuggestions"
        git clone https://github.com/fdellwing/zsh-bat.git "$HOME/.config/zsh/plugins/zsh-bat"
        git clone https://github.com/ael-code/zsh-colored-man-pages.git "$HOME/.config/zsh/plugins/zsh-colored-man-pages"
        git clone https://github.com/Freed-Wu/zsh-colorize-functions.git "$HOME/.config/zsh/plugins/zsh-colorize-functions"
        git clone https://github.com/qoomon/zsh-lazyload.git "$HOME/.config/zsh/plugins/zsh-lazyload"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/plugins/zsh-syntax-highlighting"
        echo "Plugins er installeret, have a nice day :)"
    }
 
    DIR="$HOME/.config/zsh/plugins"

    # Kontroller om plugin-mappen allerede findes
    if [ -d "$DIR" ]; then
        echo "Plugin-mappen eksisterer allerede. Installerer plugins..."
        install_plugins
    else
        echo "Opretter plugin-mappe..."
        mkdir -p "$HOME/.config/zsh/{plugins,theme}"
        echo "Installerer plugins..."
        install_plugins
    fi
}

# Funktion til at installere Zsh-theme
function install_zsh_theme {
    echo "Installerer Zsh-theme..."
    local theme_dir="$HOME/.config/zsh/theme"
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir/powerlevel10k"
    echo "Powerlevel10k theme er installeret."
}

# Funktion til at kopiere Zsh konfiguration og Powerline10k konfiguration
function copy_zsh_config {
    echo "Kopierer Zsh konfiguration..."
    cp ./zshrc "$HOME/.zshrc"
    echo "Kopierer Powerlevel10k konfiguration..."
    cp ./p10k.zsh "$HOME/.p10k.zsh"
    cp ./zshalias "$HOME/.config/zsh/zshalias"
}

# Funktion til at installere FiraCode Nerd Font
function install_firacode_nerd_font {
    echo "Installerer FiraCode Nerd Font..."
    # Opret en midlertidig mappe for fontene
    mkdir -p "$HOME/.local/share/fonts"

    # Download og installer FiraCode Nerd Font
    wget -P "$HOME/.local/share/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip &&
    unzip -o "$HOME/.local/share/fonts/FiraCode.zip" -d "$HOME/.local/share/fonts" &&
    fc-cache -f -v "$HOME/.local/share/fonts"
}

# Identificer hvilken Linux-distribution der kører ved at læse /etc/os-release
if [ -r /etc/os-release ]; then
    . /etc/os-release
    if [ -n "$ID" ]; then
        distro="$ID"
    else
        echo "Kan ikke identificere distributionen fra /etc/os-release."
        exit 1
    fi
else
    echo "/etc/os-release ikke tilgængelig. Kan ikke identificere distribution."
    exit 1
fi

# Installer Zsh og FiraCode Nerd Font baseret på distributionen
case $distro in
    ubuntu)
        install_zsh_ubuntu
        ;;
    fedora)
        install_zsh_fedora
        ;;
    arch)
        install_zsh_arch
        ;;
    nixos)
        install_zsh_nixos
        ;;
    *)
        echo "Kan ikke genkende distributionen: $distro"
        exit 1
        ;;
esac

# Installer Zsh-plugins, tema og kopier konfigurationer
install_zsh_plugins
install_zsh_theme
copy_zsh_config

# Installer FiraCode Nerd Font på alle distributioner
install_firacode_nerd_font

# Skift standard shell til Zsh
echo "Skifter standard shell til Zsh..."
chsh -s "$(which zsh)" "$USER"

echo "Færdig!"
