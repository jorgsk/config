# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Can I read my phone?
export ANDROID_HOME="/home/jorgsk/code/android-sdk-linux/"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Use vim as default editor for programs that use &EDITOR
export EDITOR=vim
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# Use bash-completion, if available
if [ -f ~/.bash_completion ]; then
  . ~/.bash_completion
fi

# make bash autocomplete with up arrow 
bind '"\e[A":history-search-backward' 
bind '"\e[B":history-search-forward'
# make tab cycle through commands instead of listing 
bind '"\t":menu-complete'
# Don't calls ls and mutt and other stuff in the history
#export HISTIGNORE="&:ls:ls *:mutt:[bf]g:exit" 
export HISTCONTROL=ignoreboth

# Reducing the prompt
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}

IWHITE='\[\e[0;97m\]'		# White
IGREEN='\[\e[0;92m\]'       # Green

#export PS1="[@\h \w]$IGREEN\$(parse_git_branch) $IWHITE\$ "
export PS1="[@\h \w]$IGREEN\$(__git_ps1 ' (%s)') $IWHITE\$ "
#export PS1="\h \w $ "

# A path for the libSMBL library for other programs to use
export LD_LIBRARY_PATH=/usr/local/lib

export CFLAGS=-I/usr/local/include
export LDLAGS=-L/usr/local/lib

# Add the current directory path!
PATH=$PATH:.
PATH=$PATH:
export PATH
export PATH="/home/jorgen/.local/bin/:$PATH"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# Make paper A4
export LC_PAPER="en_GB.UTF-8"

export PYTHONDOCS="/usr/share/doc/python-apt/html/"

# append shell history instead of replacing
shopt -s histappend
PROMT_COMMAND='history -a'

#increase the size of bash history
export HISTSIZE=10000
export HISTFILESIZE=10000

# get git autocomplete
#source ~/.git-completion.bash

# set mupdf to autocomplete to .pdf fileops (for latex)
complete plusdirs -f -X '!*.pdf' mupdf

export PYTHONPATH="/home/jorgen/local_projects/myproj:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/pyplume3d:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/pyfates:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/era-core-calculator/corecalculator:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/source/vim-ipython-cell:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/pythontools:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/memw/tools/fates_ensemble_statistics:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/sintefpy:$PYTHONPATH"
export PYTHONPATH="/home/jorgen/work/stash/era-acute-input-regridding:$PYTHONPATH"

export PYTHONPATH="/home/jorgen/source/fastapitesting/:$PYTHONPATH"

# get ipdb with breakpoint()
export PYTHONBREAKPOINT=ipdb.set_trace

# Also add pythontools so I can easily run them from wherever
export PATH="/home/jorgen/work/stash/pythontools:$PATH"

export TERM="xterm-256color"

# Hoping for nice colors
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# added by Miniconda3 installer
# export PATH="/home/jorgen/miniconda3/bin:$PATH"  # commented out by conda initialize

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jorgen/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jorgen/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/jorgen/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/jorgen/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

eval "$(jump shell)"

# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1
    else
        "$@" 8>&1 9>&2 1>&9 2>&1
    fi
}

_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  __python_argcomplete_run "$1") )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _python_argcomplete pytest
