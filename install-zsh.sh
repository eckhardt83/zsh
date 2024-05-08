#!/bin/bash

# Funktion til at installere Zsh på Ubuntu
function install_zsh_ubuntu {
	echo "Installerer zsh..."
    sudo apt update
    sudo apt install -y zsh
}

# Funktion til at installere Zsh på Fedora
function install_zsh_fedora {
	echo "Installerer zsh..."
    sudo dnf install -y zsh
}

# Funktion til at installere Zsh på Arch Linux
function install_zsh_arch {
	echo "Installerer zsh..."
    sudo pacman -Sy --noconfirm zsh
}

# Funktion til at installere Zsh på NixOS
function install_zsh_nixos {
	echo "Installerer zsh..."
    sudo nix-env -iA nixos.zsh
}

# Funktion til at installere Zsh plugins
function install_zsh_plugins {
	echo "Installerer zsh-plugins..."
	./install-zsh-plugins.sh
}

# Funktion til at installere Zsh theme
function install_zsh_theme {
	echo "Installerer zsh-theme..."
	./install-zsh-theme.sh
}

# Funktion til at kopiere Zsh config Powerline10k config
function copy_zsh_config {
	echo "kopiere Zsh config & Powerline10k config..."
	cp ./zshrc ~/.zshrc
	cp ./.p10k.zsh ~/.p10k.zsh
}

# Funktion til at installere FiraCode Nerd Font
function install_firacode_nerd_font {
    # Opret en midlertidig mappe for fontene
    mkdir -p ~/.local/share/fonts

    # Download og installer FiraCode Nerd Font
    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    unzip -o ~/.local/share/fonts/FiraCode.zip -d ~/.local/share/fonts
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
        echo "Installerer Zsh på Ubuntu..."
        install_zsh_ubuntu
        ;;
    fedora)
        echo "Installerer Zsh på Fedora..."
        install_zsh_fedora
        ;;
    arch)
        echo "Installerer Zsh på Arch Linux..."
        install_zsh_arch
        ;;
    nixos)
        echo "Installerer Zsh på NixOS..."
        install_zsh_nixos
        ;;
    *)
        echo "Kan ikke genkende distributionen: $distro"
        exit 1
        ;;
esac

install_zsh_plugins
install_zsh_theme
copy_zsh_config

# Installer FiraCode Nerd Font på alle distributioner
echo "Installerer FiraCode Nerd Font..."
install_firacode_nerd_font

echo "Zsh er blevet installeret. Skift til Zsh med kommandoen: chsh -s \$(which zsh)"
sudo chsh -s \$(which zsh)