#!/bin/bash

# Function to install FiraCode Nerd Font
function install_firacode_nerd_font {
    echo "Installing FiraCode Nerd Font..."
    mkdir -p "$HOME/.local/share/fonts"
    wget -P "$HOME/.local/share/fonts" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip &&
    unzip -o "$HOME/.local/share/fonts/FiraCode.zip" -d "$HOME/.local/share/fonts" &&
    fc-cache -f -v "$HOME/.local/share/fonts"
}

# Function to copy Zsh configuration files
function copy_zsh_config {
    echo "Copying Zsh configuration..."
    cp ./zshrc "$HOME/.zshrc"
    echo "Copying Powerlevel10k configuration..."
    cp ./p10k.zsh "$HOME/.p10k.zsh"
    cp ./zshalias "$HOME/.config/zsh/zshalias"
}

# Function to install Zsh theme (Powerlevel10k)
function install_zsh_theme {
    echo "Installing Zsh theme (Powerlevel10k)..."
    local theme_dir="$HOME/.config/zsh/theme"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir/powerlevel10k"
    echo "Powerlevel10k theme has been installed."
}

# Function to install Sublime Text 4
function install_sublime {
    if [ -x "$(command -v sublime_text)" ]; then
        echo "Sublime Text 4 is already installed."
        return 0
    fi

    case $PACKAGE_MANAGER in
        apt)
            echo "Detected Ubuntu or Debian-based system. Installing Sublime Text 4."
            wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
            sudo apt-get install -y apt-transport-https
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt-get update
            sudo apt-get install -y sublime-text
            ;;
        pacman)
            echo "Detected Arch Linux. Installing Sublime Text 4."
            sudo pacman -Syy
            sudo pacman -S --noconfirm sublime-text
            ;;
        dnf)
            echo "Detected Fedora. Installing Sublime Text 4."
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
            sudo dnf install -y sublime-text
            ;;
        *)
            echo "Unsupported package manager for Sublime Text 4 installation."
            return 1
            ;;
    esac

    echo "Sublime Text 4 has been successfully installed."
}

# Check which Linux distribution is running
if [ -f /etc/os-release ]; then
    . /etc/os-release
    LINUX_DISTRO=$ID
else
    LINUX_DISTRO="unknown"
fi

# Determine the package manager based on the Linux distribution
case $LINUX_DISTRO in
    ubuntu | linuxmint | debian | elementary | popos)
        PACKAGE_MANAGER="apt"
        ;;
    fedora | rhel | centos | rocky)
        PACKAGE_MANAGER="dnf"
        ;;
    arch | arcolinux | manjaro | endeavouros | archbang | artix)
        PACKAGE_MANAGER="pacman"
        ;;
    nixos)
        PACKAGE_MANAGER="nix-env -i"
        ;;
    *)
        echo "Unsupported Linux distribution: $LINUX_DISTRO"
        exit 1
        ;;
esac

# Ensure Git and Zsh are installed
if ! command -v git &> /dev/null; then
    echo "Git is required but not installed. Installing Git..."
    sudo $PACKAGE_MANAGER install git
fi

if ! command -v zsh &> /dev/null; then
    echo "Zsh is required but not installed. Installing Zsh..."
    sudo $PACKAGE_MANAGER install zsh
fi

# Prompt user to select plugins for installation
echo "Available plugins:"
echo "1. Autosuggestions"
echo "2. Alias Finder"
echo "3. Ansible"
echo "4. Sublime"
echo "5. Auto Notify"
echo "6. Bat"
echo "7. Colored Man Pages"
echo "8. Colorize Functions"
echo "9. Lazyload"
echo "10. Syntax Highlighting"
echo "11. Install all plugins"

read -p "Enter the numbers of the plugins you want to install (e.g., '1 3 10'): " PLUGIN_CHOICES

# Convert input string into an array of plugin numbers
IFS=' ' read -ra PLUGIN_ARRAY <<< "$PLUGIN_CHOICES"

# Load selected plugins based on user input
for plugin_num in "${PLUGIN_ARRAY[@]}"; do
    case $plugin_num in
        1) git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.config/zsh/plugins/zsh-autosuggestions" ;;
        2) git clone https://github.com/akash329d/zsh-alias-finder "$HOME/.config/zsh/plugins/zsh-alias-finder" ;;
        3) git clone https://github.com/sparsick/ansible-zsh "$HOME/.config/zsh/plugins/ansible" ;;
        4) git clone https://github.com/valentinocossar/sublime.git "$HOME/.config/zsh/plugins/sublime"; install_sublime ;;
        5) git clone https://github.com/MichaelAquilina/zsh-auto-notify.git "$HOME/.config/zsh/plugins/zsh-auto-notify" ;;
        6) git clone https://github.com/fdellwing/zsh-bat.git "$HOME/.config/zsh/plugins/zsh-bat" ;;
        7) git clone https://github.com/ael-code/zsh-colored-man-pages.git "$HOME/.config/zsh/plugins/zsh-colored-man-pages" ;;
        8) git clone https://github.com/Freed-Wu/zsh-colorize-functions.git "$HOME/.config/zsh/plugins/zsh-colorize-functions"; install_sublime ;;
        9) git clone https://github.com/qoomon/zsh-lazyload.git "$HOME/.config/zsh/plugins/zsh-lazyload" ;;
        10) git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.config/zsh/plugins/zsh-syntax-highlighting" ;;
        11)
            for plugin in autosuggestions alias-finder ansible sublime auto-notify bat colored-man-pages colorize-functions lazyload syntax-highlighting; do
                git clone "https://github.com/zsh-users/zsh-${plugin}.git" "$HOME/.config/zsh/plugins/zsh-${plugin}"
            done
            install_sublime ;;
        *)
            echo "Invalid plugin number: $plugin_num"
            ;;
    esac
done

# Install Zsh theme and configuration files
install_zsh_theme
copy_zsh_config

# Install FiraCode Nerd Font
install_firacode_nerd_font

# Set Zsh as default shell
chsh -s "$(which zsh)" "$USER"

echo "Plugins and configurations have been installed successfully."
