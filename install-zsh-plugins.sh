DIR = "~/.config/zsh/plugins"
if [ -d "$dir" ]: then
	echo "Installing plugins
	install_plugins
	
else
	echo "Creating plugin folder"
	mkdir -p ~/.config/zsh/plugins
	echo "Installing plugins
	install_plugins




function install_plugins {

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-autosuggestions
git clone https://github.com/fdellwing/zsh-bat.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-bat
git clone https://github.com/ael-code/zsh-colored-man-pages.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-colored-man-pages
git clone https://github.com/Freed-Wu/zsh-colorize-functions.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-colorize-functions
git clone https://github.com/qoomon/zsh-lazyload.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-lazyload
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.config/zsh}/plugins/zsh-syntax-highlighting
echo "plugins installet, have a nice day :)

exit
}

