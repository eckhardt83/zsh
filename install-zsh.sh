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
    sudo ./install-zsh-plugins.sh
}

# Funktion til at installere Zsh-theme
function install_zsh_theme {
    echo "Installerer Zsh-theme..."
    sudo ./install-zsh-theme.sh
}

# Funktion til at kopiere Zsh konfiguration og Powerline10k konfiguration
function copy_zsh_config {
    echo "Kopierer Zsh konfiguration..."
    cp ./zshrc ~/.zshrc
    #cp ./p10k.zsh ~/.p10k.zsh
}

# Funktion til at installere FiraCode Nerd Font
function install_firacode_nerd_font {
    echo "Installerer FiraCode Nerd Font..."
    # Opret en midlertidig mappe for fontene
    mkdir -p ~/.local/share/fonts

    # Download og installer FiraCode Nerd Font
    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip &&
    unzip -o ~/.local/share/fonts/FiraCode.zip -d ~/.local/share/fonts &&
    fc-cache -f -v ~/.local/share/fonts
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
mv ./p10k.zsh ~/.p10k.zsh

# Installer FiraCode Nerd Font på alle distributioner
install_firacode_nerd_font

# Skift standard shell til Zsh
echo "Skifter standard shell til Zsh..."
chsh -s $(which zsh) $USER

echo "Færdig!"
