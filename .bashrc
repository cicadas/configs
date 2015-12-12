# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

if [ -f ~/.hadoop_bashrc ]; then
	. ~/.hadoop_bashrc
fi

# User specific aliases and functions
# Check for an interactive session
[ -z "$PS1" ] && return


# Welcome message
#echo -ne "Good Morning,OESPIRIT!. It's "; date '+%A, %B %-d %Y'
#uptime
#echo -e "And now your moment of Zen:"; fortune

#source $HOME/.shells/functions
#source $HOME/.shells/exports
#source $HOME/.shells/alias
#uncomment the following line to get a beatiful bash prompt tyle
#. $HOME/.bashrc_style
export txtblk='\[\e[0;30m\]' # Black - Regular
export txtred='\[\e[0;31m\]' # Red
export txtgrn='\[\e[0;32m\]' # Green
export txtylw='\[\e[0;33m\]' # Yellow
export txtblu='\[\e[0;34m\]' # Blue
export txtpur='\[\e[0;35m\]' # Purple
export txtcyn='\[\e[0;36m\]' # Cyan
export txtwht='\[\e[0;37m\]' # White
export bldblk='\[\e[1;30m\]' # Black - Bold
export bldred='\[\e[1;31m\]' # Red
export bldgrn='\[\e[1;32m\]' # Green
export bldylw='\[\e[1;33m\]' # Yellow
export bldblu='\[\e[1;34m\]' # Blue
export bldpur='\[\e[1;35m\]' # Purple
export bldcyn='\[\e[1;36m\]' # Cyan
export bldwht='\[\e[1;37m\]' # White
export unkblk='\[\e[4;30m\]' # Black - Underline
export undred='\[\e[4;31m\]' # Red
export undgrn='\[\e[4;32m\]' # Green
export undylw='\[\e[4;33m\]' # Yellow
export undblu='\[\e[4;34m\]' # Blue
export undpur='\[\e[4;35m\]' # PurplJe
export undcyn='\[\e[4;36m\]' # Cyan
export undwht='\[\e[4;37m\]' # White
export bakblk='\[\e[40m\]'   # Black - Background
export bakred='\[\e[41m\]'   # Red
export badgrn='\[\e[42m\]'   # Green
export bakylw='\[\e[43m\]'   # Yellow
export bakblu='\[\e[44m\]'   # Blue
export bakpur='\[\e[45m\]'   # Purple
export bakcyn='\[\e[46m\]'   # Cyan
export bakwht='\[\e[47m\]'   # White
export txtrst='\[\e[0m\]'    # Text Reset

#colorize console prompt
#export PS1="$cyan\u@\h $green\W $red->$white"
export PS1="$txtgrn\u$txtcyn@$txtgrn\h $txtred\W$txtred )>$txtwht "
export PS1="\`if [ \$? = 0 ]; then echo \[\e[33m\]^_^\[\e[0m\]; else echo \[\e[31m\]O_O\[\e[0m\]; fi\` $txtgrn\u$txtcyn@$txtgrn\h $txtpur\t $txtred( \w$txtred )\n=>$txtwht "
export TITLEBAR='hello'

#chang PATH
#export PATH=~/bin/:$PATH:/home/lee/bin/ns-2.34/bin
export PATH=~/bin/:$PATH
#export LD_LIBRARY_PATH=/home/lee/bin/ns-2.34/otcl-1.13:/home/lee/bin/ns-2.34/lib
#export TCL_LIBRARY=/home/lee/bin/ns-2.34/tcl8.4.18/library
#homePath=~/bin
#if [[ $PATH != *$homePath* ]]; then
#    export PATH=$homePath:$PATH
#fi

#close pc beep
#setterm -blength 0

#clorize the output of ls
#eval `dircolors -b`

#enable shellcompletion
if [ -f /etc/bash_completion ]; then
	    . /etc/bash_completion
fi
#sudo complete
complete -cf sudo

#esay file encompression
extract () {
   if [ -f $1 ] ; then
       case $1 in
           *.tar.bz2)   tar xvjf $1    ;;
           *.tar.gz)    tar xvzf $1    ;;
           *.bz2)       bunzip2 $1     ;;
           *.rar)       unrar e $1     ;;
           *.gz)        gunzip $1      ;;
           *.tar)       tar xvf $1     ;;
           *.tbz2)      tar xvjf $1    ;;
           *.tgz)       tar xvzf $1    ;;
           *.zip)       unzip $1       ;;
           *.Z)         uncompress $1  ;;
           *.7z)        7z x $1        ;;
           *)           echo "don't know how to extract '$1'..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
 }

#xlock the screen
alias xlock='xlock -mode rain'
#aleas wine='env LANG=zh_CN.UTF-8 wine'
alias download='aria2c -c '
#alias gcc='gcc -std=c99'
alias CN='luit -encoding'
alias rm='rm -i'
alias vi='vim'
alias ll='lls'
#ramEator Alias Error
alias ramEator='ps aux | awk '\''{print $2, $4, $11}'\'' | sort -k2r | head -n 20'
alias go_virtual='ssh -p 3022 chong@127.0.0.1'

declare -x LANG="en_US.UTF-8"
declare -x LC_CTYPE="en_US.UTF-8"

if [ -f ~/.localVariables ]; then
    . ~/.localVariables
fi

alias distribute="awk -F\$'\t' '{sum[\$1]+=1;}END{for(k in sum) print k\"\t\"sum[k]}'"
alias add="awk '{sum+=\$1}END{print sum}'"
alias hls='hadoop fs -ls'
alias hcat='hadoop fs -cat'
alias hcfl='hadoop fs -copyFromLocal'
alias hctl='hadoop fs -copyToLocal'
alias hdu='hadoop fs -du -s -h'
alias hmv='hadoop fs -mv'
alias hrm='hadoop fs -rm'
alias hrmr='hadoop fs -rm -r -skipTrash'

