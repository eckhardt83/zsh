#!/bin/bash

function install_firacode_nerd_font {
    echo "Installing FiraCode Nerd Font..."
    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"
    wget -P "$font_dir" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip &&
    unzip -o "$font_dir/FiraCode.zip" -d "$font_dir" &&
    fc-cache -f -v "$font_dir"
}

function copy_zsh_config {
    echo "Copying Zsh configuration..."
    cp ./zshrc "$HOME/.zshrc"
    cp ./p10k.zsh "$HOME/.p10k.zsh"
    cp ./zshalias "$HOME/.config/zsh/zshalias"
}

function install_zsh_theme {
    echo "Installing Zsh theme..."
    local theme_dir="$HOME/.config/zsh/theme"
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$theme_dir/powerlevel10k"
    echo "Powerlevel10k theme installed."
}

function install_plugin_dependencies {
    local plugin_name="$1"
    case $plugin_name in
        ansible)
            if ! command -v ansible &> /dev/null; then
                read -p "Ansible is required by ansible plugin. Do you want to install it? (y/n): " INSTALL_ANSIBLE
                if [ "$INSTALL_ANSIBLE" = "y" ]; then
                    sudo $PACKAGE_MANAGER install ansible
                fi
            fi
            ;;
        subl)
            if ! command -v sublime_text &> /dev/null; then
                install_sublime
            fi
            ;;
        bat)
            if ! command -v bat &> /dev/null; then
                read -p "The 'bat' package is required by zsh-bat plugin. Do you want to install it? (y/n): " INSTALL_BAT
                if [ "$INSTALL_BAT" = "y" ]; then
                    sudo $PACKAGE_MANAGER install bat
                fi
            fi
            ;;
        notify-send)
            if ! command -v notify-send &> /dev/null; then
                read -p "The 'notify-send' command is required by zsh-auto-notify plugin. Do you want to install it? (y/n): " INSTALL_NOTIFY_SEND
                if [ "$INSTALL_NOTIFY_SEND" = "y" ]; then
                    sudo $PACKAGE_MANAGER install libnotify-bin
                fi
            fi
            ;;
        *)
            echo "No additional dependencies for plugin: $plugin_name"
            ;;
    esac
}

# Function to install Sublime Text 4 based on the Linux distribution
function install_sublime {
    if [ -x "$(command -v sublime_text)" ]; then
        echo "Sublime Text 4 is already installed."
        return 0
    fi

    if [ -x "$(command -v apt)" ]; then
        echo "Detected Ubuntu or Debian-based system. Installing Sublime Text 4."
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
        sudo apt-get install -y apt-transport-https
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        sudo apt-get update
        sudo apt-get install -y sublime-text

    elif [ -x "$(command -v pacman)" ]; then
        echo "Detected Arch Linux. Installing Sublime Text 4."
        sudo pacman -Syy
        sudo pacman -S --noconfirm sublime-text

    elif [ -x "$(command -v dnf)" ]; then
        echo "Detected Fedora. Installing Sublime Text 4."
        sudo dnf install -y dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo
        sudo dnf install -y sublime-text

    else
        echo "Unsupported distribution. Cannot install Sublime Text 4."
        return 1
    fi

    echo "Sublime Text 4 has been successfully installed."
}

# Check which Linux distribution is running
if [ -f /etc/os-release ]; then
    . /etc/os-release
    LINUX_DISTRO=$ID
else
    LINUX_DISTRO="unknown"
fi

# Determine package manager based on Linux distribution
case $LINUX_DISTRO in
    ubuntu | linuxmint | debian | elementary | popos)
        PLUGIN_DIR=~/.config/zsh/plugins
        PACKAGE_MANAGER="apt"
        ;;
    fedora | rhel | centos | rocky)
        PLUGIN_DIR=~/.config/zsh/plugins
        PACKAGE_MANAGER="dnf"
        ;;
    arch | arcolinux | manjaro | endeavouros | archbang | artix)
        PLUGIN_DIR=~/.config/zsh/plugins
        PACKAGE_MANAGER="pacman"
        ;;
    nixos)
        PLUGIN_DIR=~/.config/zsh/plugins
        PACKAGE_MANAGER="nix-env -i"
        ;;
    *)
        echo "Unsupported Linux distribution: $LINUX_DISTRO"
        exit 1
        ;;
esac

# Ensure Git is installed (required for fetching plugin sources)
if ! command -v git &> /dev/null; then
    echo "Git is required but not installed. Installing Git..."
    sudo $PACKAGE_MANAGER install git
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
echo "11. All Plugins"

read -p "Enter the numbers of the plugins you want to install (e.g., '1 3 10' or '11' for all): " PLUGIN_CHOICES

# Convert input string into an array of plugin numbers
IFS=' ' read -ra PLUGIN_ARRAY <<< "$PLUGIN_CHOICES"

# Check if user selected all plugins
if [[ " ${PLUGIN_ARRAY[@]} " =~ " 11 " ]]; then
    PLUGIN_ARRAY=(1 2 3 4 5 6 7 8 9 10)
fi

# Load selected plugins based on user input
for plugin_num in "${PLUGIN_ARRAY[@]}"; do
    case $plugin_num in
        1) source $PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh ;;
        2) source $PLUGIN_DIR/zsh-alias-finder/zsh-alias-finder.plugin.zsh ;;
        3) source $PLUGIN_DIR/ansible/ansible.plugin.zsh ;;
        4) source $PLUGIN_DIR/sublime/sublime.plugin.zsh ;;
        5) source $PLUGIN_DIR/zsh-auto-notify/auto-notify.plugin.zsh ;;
        6) source $PLUGIN_DIR/zsh-bat/zsh-bat.plugin.zsh ;;
        7) source $PLUGIN_DIR/zsh-colored-man-pages/colored-man-pages.plugin.zsh ;;
        8) source $PLUGIN_DIR/zsh-colorize-functions/zsh-colorize-functions.plugin.zsh ;;
        9) source $PLUGIN_DIR/zsh-lazyload/zsh-lazyload.zsh ;;
        10) source $PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ;;
        *)
            echo "Invalid plugin number: $plugin_num"
            ;;
    esac

    # Install any additional dependencies required by the plugin
    install_plugin_dependencies "$plugin_num"
done

# Install Zsh theme, copy config files, and set default shell to Zsh
install_zsh_theme
copy_zsh_config
sed -i 's/\r$//' "$HOME/.zshrc"
sed -i 's/\r$//' "$HOME/.p10k.zsh"
sed -i 's/\r$//' "$HOME/.config/zsh/zshalias"
install_firacode_nerd_font
chsh -s "$(command -v zsh)" "$USER"

echo "Setup complete."
