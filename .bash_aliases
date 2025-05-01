# Alias Definitions

# ArchWiki Offline
command -v archwiki-offline &>/dev/null && {
	_temp_file="$(mktemp -q)"
	cat <<EOF >"$_temp_file"
#!/bin/bash
# Replace spaces with underscores
selected_topic=\$(echo "\$1" | sed 's/ /_/g')

# Open the HTML file using w3m for preview
w3m /usr/share/doc/arch-wiki/html/en/\$selected_topic.html
EOF
	chmod +x "$_temp_file"

	_cmd="xdg-open"
	command -v fzf &>/dev/null && _cmd="fzf"
	command -v w3m &>/dev/null && _cmd="fzf --preview=\"$_temp_file {}\""
	alias archwiki="archwiki-offline -m '$_cmd'"
}

# Dotfiles Configuration
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Mirrorlist Updates
alias ua-drop-caches='sudo paccache -rk3
yay -Sc --aur --noconfirm'
alias ua-update='export TMPFILE="$(mktemp)"
sudo true
rate-mirrors --save=$TMPFILE arch --max-delay=21600 &&
	sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup &&
	sudo mv $TMPFILE /etc/pacman.d/mirrorlist'
alias ua-update-all='export TMPFILE="$(mktemp)"
sudo true
rate-mirrors --save=$TMPFILE arch --max-delay=21600 &&
	sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup &&
	sudo mv $TMPFILE /etc/pacman.d/mirrorlist &&
	ua-drop-caches &&
	yay -Syyu'
# && yay -Syyu --noconfirm'

#######################################################
# MACHINE SPECIFIC ALIAS'S
#######################################################

# Alias's for SSH
# alias SERVERNAME='ssh YOURWEBSITE.com -l USERNAME -p PORTNUMBERHERE'

# Alias's to change the directory
alias web='cd /var/www/html'

# Alias's to mount ISO files
# mount -o loop /home/NAMEOFISO.iso /home/ISOMOUNTDIR/
# umount /home/NAMEOFISO.iso
# (Both commands done as root only.)

#######################################################
# GENERAL ALIAS'S
#######################################################
# To temporarily bypass an alias, we precede the command with a \
# EG: the ls command is aliased, but to use the normal ls command you would type \ls

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Edit this .bashrc file
alias ebrc='edit ~/.bashrc'

# Show help for this .bashrc file
alias hlp='less ~/.bashrc_help'

# alias to show the date
alias da='date "+%Y-%m-%d %A %T %Z"'

# Alias's to modified commands
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias mkdir='mkdir -p'
alias ps='ps auxf'
alias ping='ping -c 10'
alias less='less -R'
alias cls='clear'
alias apt-get='sudo apt-get'
alias multitail='multitail --no-repeat -c'
alias freshclam='sudo freshclam'

# vi
alias v='nvim'
alias svi='sudo vim'
alias vis='nvim "+set si"'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# cd into the old directory
alias bd='cd "$OLDPWD"'

# Remove a directory and all files
alias rmd='/bin/rm  --recursive --force --verbose '

# Alias's for multiple directory listing commands
# alias ls='ls -aFh --color=always' # add colors and file type extensions
alias ls='lsd --group-directories-first'
alias l='ls -lh'
alias la='ls -Alh | more'        # show hidden files
alias ll='ls -Fl'                # long listing format
alias lx='ls -lXBh'              # sort by extension
alias lk='ls -lSrh'              # sort by size
alias lc='ls -lcrh'              # sort by change time
alias lu='ls -lurh'              # sort by access time
alias lr='ls -lRh'               # recursive ls
alias lt='ls -ltrh'              # sort by date
alias lm='ls -alh | more'        # pipe through 'more'
alias lw='ls -xAh'               # wide listing format
alias labc='ls -lap'             #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'"  # directories only

# alias chmod commands
alias ax='chmod a+x'
alias ux='chmod u+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search command line history
alias h="history | grep "

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

# Search files in the current folder
alias f="find . | grep "

# Count all files (recursively) in the current folder
alias countfiles="for t in files links directories; do echo \`find . -type \${t:0:1} | wc -l\` \$t; done 2> /dev/null"

# To see if a command is aliased, a file, or a built-in command
alias checkcommand="type -t"

# Show open ports
alias openports='netstat -nape --inet'

# Alias's for safe and forced reboots
alias rebootsafe='sudo shutdown -r now'
alias rebootforce='sudo shutdown -r -n now'

# Alias's to show disk space and space used in a folder
alias diskspace="du -S | sort -n -r |more"
alias folders='du -h --max-depth=1'
alias folderssort='find . -maxdepth 1 -type d -print0 | xargs -0 du -sk | sort -rn'
alias tree='tree -CAhF --dirsfirst'
alias treed='tree -CAFd'
alias mountedinfo='df -hT'

# Alias's for archives
alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# SHA1
alias sha1='openssl sha1'

alias clickpaste='sleep 3; xdotool type "$(xclip -o -selection clipboard)"'

# Global Aliases
# alias -g L="| less"
# alias -g G="| grep"
# alias -g "0q"="2>&1 > /dev/null"
# alias -g "0e"="2>/dev/null"
alias L="| less"
alias G="| grep"
alias "0q"="2>&1 > /dev/null"
alias "0e"="2>/dev/null"

# User Aliases
alias count="find . -type f | wc -l"
alias cpv="rsync -ah --info=progress2"
alias df="duf"
alias du="gdu"
alias fdir="find . -type d name"
alias ffile="find . -type f name"
alias free="free -mt"
alias grep="grep --color=auto"
alias hgrep="history | grep"
alias less="less -R"
alias mnt="mount | grep -E ^/dev | column -t"
alias myip="curl ipinfo.io/ip"
alias psg="ps -aux | grep -v grep | grep -i -e VSZ -e"
alias tcn="mv --force -t ~/.local/share/Trash"
alias webify="mogrify\ -resize\ 1280\\\>\ \*.png"

# Git Aliases
alias gcl='git clone --depth 1'
alias gi='git init'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push origin master'

# KITTY - alias to be able to use kitty features when connecting to remote servers(e.g use tmux on remote server)
alias kssh="kitty +kitten ssh"
alias kshg="kitty +kitten hyperlinked_grep"

# Get the Error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Use Nano editor for important configuration files
# Know what you do in these files
alias npacman="sudo $EDITOR /etc/pacman.conf"
alias ngrub="sudo $EDITOR /etc/default/grub"
alias nconfgrub="sudo $EDITOR /boot/grub/grub.cfg"
alias nmkinitcpio="sudo $EDITOR /etc/mkinitcpio.conf"
alias nmirrorlist="sudo $EDITOR /etc/pacman.d/mirrorlist"
alias nsddm="sudo $EDITOR /etc/sddm.conf"
alias nfstab="sudo $EDITOR /etc/fstab"
alias nnsswitch="sudo $EDITOR /etc/nsswitch.conf"
alias nsamba="sudo $EDITOR /etc/samba/smb.conf"
alias ngnupgconf="sudo nano /etc/pacman.d/gnupg/gpg.conf"
alias nb="$EDITOR ~/.bashrc"
alias nz="$EDITOR ~/.zshrc"

# End Alias
