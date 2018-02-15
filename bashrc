# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Time of execution
function start_timer {
	timer=${timer:-$SECONDS}

}
function stop_timer {
	elapsed=$(($SECONDS - $timer))
	if [ "$elapsed" -ge 10 ]; then
		tmp="$DYEL[Time: ${elapsed}s]$RST"
		echo $tmp	
	fi
	unset timer
}
trap 'start_timer' DEBUG
if [ "$PROMPT_COMMAND" == "" ]; then
 	PROMPT_COMMAND="stop_timer"
else
	PROMPT_COMMAND="$PROMPT_COMMAND; stop_timer"
fi


DBLK=$(tput setaf 0)
DRED=$(tput setaf 1)
DGRE=$(tput setaf 2)
DYEL=$(tput setaf 3)
DBLU=$(tput setaf 4)
DPUR=$(tput setaf 5)
DCYA=$(tput setaf 6)
DWHI=$(tput setaf 7)
LBLK=$(tput setaf 8)
LRED=$(tput setaf 9)
LGRE=$(tput setaf 10)
LYEL=$(tput setaf 11)
LBLU=$(tput setaf 12)
LPUR=$(tput setaf 13)
LCYA=$(tput setaf 14)
LWHI=$(tput setaf 15)
GREY=$(tput setaf 248)
RST=$(tput sgr0)

color_prompt=yes
if [ "$color_prompt" = yes ]; then
	PS1='\[$DYEL\]\t \[$GREY\][\[$LGRE\]\u\[$GREY\]@\[$DRED\]\h \[$LBLU\]\W\[$GREY\]]\$ \[$RST\]'
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color|*-256color) color_prompt=yes;;
#esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

#if [ -n "$force_color_prompt" ]; then
#    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
#	# We have color support; assume it's compliant with Ecma-48
#	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
#	# a case would tend to support setf rather than setaf.)
#	color_prompt=yes
#    else
#	color_prompt=
#    fi
#fi

#if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


export PATH="$HOME/apps/bin:/usr/local/cuda-8.0/bin:$PATH"
#export PATH="$HOME/apps/bin:/usr/local/cuda-8.0/bin:$HOME/apps/src/anaconda3/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-8.0/lib64:$LD_LIBRARY_PATH"
export RANGER_LOAD_DEFAULT_RC=FALSE
export TERM=xterm-256color

# TODO move this to bash_aliases
alias vrc='vim ~/.vimrc'
alias brc='vim ~/.bashrc'
alias vxd='vim ~/.Xdefaults'
alias rrc='vim ~/.config/ranger/rc.conf'

# added by Anaconda3 installer
#export PATH="/home/berenguer/apps/src/anaconda3/bin:$PATH"
