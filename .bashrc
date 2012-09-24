source /etc/bashrc
export PS1='\[\033[40;32;3m\]\u@\h \[\033[40;34;3m\]\w\[\033[40;34;1m\] \$\[\e[0m\] '

#Bash Completion
#if [ -f /etc/bash_completion ]; then
#        . /etc/bash_completion
#fi

#Some important alias
alias ll='ls -lsh --color=auto'
alias vi='vim'
alias grep='grep --color=auto'

#Show date and time on my bash history
export HISTTIMEFORMAT="%d/%m/%Y %T "

alias eject='sudo eject'
alias halt='sudo halt'

#alias torrent="btlaunchmanycurses.py --minport 2000 --maxport 2005 /dados/torrents/arquivos.torrent/"

#export LANG="pt_BR.UTF-8"
shopt -s histappend

alias god='sudo su - '

export EDITOR="vim"
alias vmore="vim -u ~/.vimrc.more -"

alias ncmpc="ncmpc -c -h 192.168.0.109"
alias seelog="screen -c .screenrc_log"
alias emerge="sudo yum install -y "
alias eix="sudo yum search search"
alias update="sudo && sudo apt-get upgrade -y"
alias b="sudo make install"
alias mutt='TERM=gnome-256color /home/otubo/develop/mutt-1.5.21/mutt -F /home/otubo/.muttrc_otubo'


#this should be the last thing at .bashrc
#. /etc/profile.d/bash_completion.sh

#export DISPLAY=:0.0

# Instalacao das Funcoes ZZ (www.funcoeszz.net)
export ZZOFF=""  # desligue funcoes indesejadas
export ZZPATH="/usr/bin/funcoeszz"  # script
source "$ZZPATH"
