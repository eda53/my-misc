# my-misc
misc

git clone https://github.com/eda53/my-misc  
ln -sf my-misc/Linux bin  
ln -sf my-misc/Linux/.astylerc .  
ln -sf my-misc/Linux/.bash_aliases .  


git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

~/.tmux.conf
# list of plugins
set -g @plugin 'tmux-plugins/tpm'
#set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
 
# Other examples:
# set -g @plugin 'github_username/plugin_name'
# set -g @plugin 'git@github.com/user/plugin'
# set -g @plugin 'git@bitbucket.com/user/plugin'
 
# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run -b '~/.tmux/plugins/tpm/tpm'

tmux source ~/.tmux.conf


    Add new plugin to ~/.tmux.conf with set -g @plugin '...'
    Press prefix + I (capital i, as in Install) to fetch the plugin.

From: https://arcolinux.com/everything-you-need-to-know-about-tmux-plugins-manager/
