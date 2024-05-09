# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd beep notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/eckhardt/.zshrc'



autoload -Uz compinit
compinit
# End of lines added by compinstall



if [ -f ~/.config/zsh/zshalias ]; then
    source ~/.config/zsh/zshalias
else
    print "404: ~/.config/zsh/zshalias not found."
fi


if [[ -f /etc/DIR_COLORS ]] ; then
  eval $(dircolors -b /etc/DIR_COLORS)
fi

### Plugins ######
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-alias-finder/zsh-alias-finder.plugin.zsh
source ~/.config/zsh/plugins/ansible/ansible.plugin.zsh
source ~/.config/zsh/plugins/sublime/sublime.plugin.zsh
source ~/.config/zsh/plugins/zsh-auto-notify/auto-notify.plugin.zsh
source ~/.config/zsh/plugins/zsh-bat/zsh-bat.plugin.zsh
source ~/.config/zsh/plugins/zsh-colored-man-pages/colored-man-pages.plugin.zsh
source ~/.config/zsh/plugins/zsh-colorize-functions/zsh-colorize-functions.plugin.zsh
source ~/.config/zsh/plugins/zsh-lazyload/zsh-lazyload.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

 
####### Theme
source ~/.config/zsh/theme/powerlevel10k/powerlevel10k.zsh-theme


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
