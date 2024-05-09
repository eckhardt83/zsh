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

# Ensure Git is installed
if ! command -v git &> /dev/null; then
    echo "Git is required but not installed. Installing Git..."
    sudo $PACKAGE_MANAGER install git
fi

# Clone necessary plugins from GitHub
mkdir -p "$HOME/.config/zsh/plugins"
cd "$HOME/.config/zsh/plugins" || exit

git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/fdellwing/zsh-bat.git
git clone https://github.com/ael-code/zsh-colored-man-pages.git
git clone https://github.com/Freed-Wu/zsh-colorize-functions.git
git clone https://github.com/qoomon/zsh-lazyload.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/MenkeTechnologies/zsh-expand.git
git clone https://github.com/akash329d/zsh-alias-finder
git clone https://github.com/sparsick/ansible-zsh
git clone https://github.com/valentinocossar/sublime.git
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git

echo "Plugins are installed successfully."

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
echo "11. Install All"

read -p "Enter the numbers of the plugins you want to install (e.g., '1 3 10' or '11' for all): " PLUGIN_CHOICES

# Convert input string into an array of plugin numbers
IFS=' ' read -ra PLUGIN_ARRAY <<< "$PLUGIN_CHOICES"

# If "11" (Install All) is selected, set PLUGIN_ARRAY to all available plugin numbers
if [[ " ${PLUGIN_ARRAY[@]} " =~ " 11 " ]]; then
    PLUGIN_ARRAY=(1 2 3 4 5 6 7 8 9 10)
fi

# Load selected plugins based on user input
for plugin_num in "${PLUGIN_ARRAY[@]}"; do
    case $plugin_num in
        1) install_plugin_dependencies autosuggestions ;;
        2) install_plugin_dependencies alias-finder ;;
        3) install_plugin_dependencies ansible ;;
        4) install_plugin_dependencies subl ;;
        5) install_plugin_dependencies auto-notify ;;
        6) install_plugin_dependencies bat ;;
        7) install_plugin_dependencies colored-man-pages ;;
        8) install_plugin_dependencies colorize-functions ;;
        9) install_plugin_dependencies lazyload ;;
        10) install_plugin_dependencies syntax-highlighting ;;
        *)
            echo "Invalid plugin number: $plugin_num"
            ;;
    esac
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
