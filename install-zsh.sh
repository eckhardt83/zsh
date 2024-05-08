#!/bin/bash

# Funktion til at installere Zsh på Ubuntu
install_zsh_ubuntu() {
    sudo apt update
    sudo apt install -y zsh
}

# Funktion til at installere Zsh på Fedora
install_zsh_fedora() {
    sudo dnf install -y zsh
}

# Funktion til at installere Zsh på Arch Linux
install_zsh_arch() {
    sudo pacman -Sy --noconfirm zsh
}

# Funktion til at installere Zsh på NixOS
install_zsh_nixos() {
    sudo nix-env -iA nixos.zsh
}

# Funktion til at installere Zsh plugins
install_zsh_plugins() {
	./install-zsh-plugins.sh
}

# Funktion til at installere Zsh theme
install_zsh_theme() {
	./install-zsh-theme.sh
}

# Funktion til at kopiere Zsh config Powerline10k config
copy_zsh_config() {
	cp ./zshrc ~/.zshrc
	cp ./.p10k.zsh ~/
}

# Funktion til at installere FiraCode Nerd Font
install_firacode_nerd_font() {
    # Opret en midlertidig mappe for fontene
    mkdir -p ~/.local/share/fonts

    # Download og installer FiraCode Nerd Font
    wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
    unzip -o ~/.local/share/fonts/FiraCode.zip -d ~/.local/share/fonts
    fc-cache -f -v ~/.local/share/fonts
}


# Identificer hvilken Linux-distribution der kører
if [ -x "$(command -v lsb_release)" ]; then
    distro=$(lsb_release -si)
else
    echo "lsb_release ikke tilgængelig. Kan ikke identificere distribution."
    exit 1
fi

# Installer Zsh baseret på distributionen
case $distro in
    Ubuntu)
        echo "Installerer Zsh på Ubuntu..."
        install_zsh_ubuntu
        ;;
    Fedora)
        echo "Installerer Zsh på Fedora..."
        install_zsh_fedora
        ;;
    Arch)
        echo "Installerer Zsh på Arch Linux..."
        install_zsh_arch
        ;;
    NixOS)
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
