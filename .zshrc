case "$OSTYPE" in
darwin*)
  export LANG=ja_JP.UTF-8
  
  export TERM=xterm-256color
  export PATH=/usr/local/bin:/usr/X11/bin:/usr/local/mysql/bin:$PATH
  # export PATH=/usr/local/share/python:/usr/local/bin:/usr/X11/bin:/usr/local/mysql/bin:$PATH
  export SVN_EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
  export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
  export LSCOLORS=gxfxcxdxbxegedabagacad
  # export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime
  export VIMRUNTIME=
  export PATH=$JAVA_HOME/bin:$PATH
  export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
  
  # scala
  export PATH=$HOME/local/scala/bin:$PATH
  # maven2
  export M2_HOME=~/local/apache-maven-3.2.3
  export M2=$M2_HOME/bin
  export PATH=$M2:$PATH
  # oracle client
  export SQLPATH=$HOME/sql
  export ORACLE_HOME=~/bin/sqlplus/instantclient_12_1
  # export ORACLE_HOME=~/bin/sqlplus/instantclient_11_2
  export PATH=$ORACLE_HOME:$PATH
  export DYLD_LIBRARY_PATH=~/bin/sqlplus/instantclient_12_1
  # export DYLD_LIBRARY_PATH=~/bin/sqlplus/instantclient_11_2
  export NLS_LANG=japanese_japan.UTF8

  alias vi='env LANG=ja_JP.UTF-8 reattach-to-user-namespace /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias less="/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh"
  alias ls='ls -vG'
  # alias man='TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man'

  if [ ! -S $SSH_AUTH_SOCK ]; then
      eval `ssh-agent -a $SSH_AUTH_SOCK`
      echo $SSH_AGENT_PID > /tmp/ssh_agent_pid
      ssh-add
  elif [ -f /tmp/ssh_agent_pid ]; then
      export SSH_AGENT_PID=`cat /tmp/ssh_agent_pid`
  fi
  ;;
linux*)
  export LANG=ja_JP.UTF-8
  export PATH=/usr/local/bin/:$PATH
  export PATH=/usr/local/firefox/:$PATH
  export SVN_EDITOR=vi
  export PATH=$HOME/bin:$PATH

  alias vi='vim'
  ;;
esac

alias g='git'
export PATH=$HOME/bin:$HOME/local/bin:$HOME/.composer/vendor/bin:$PATH

autoload -U compinit
compinit

setopt auto_cd
setopt auto_pushd
setopt correct
setopt list_packed
setopt nolistbeep
setopt list_types
setopt auto_resume
setopt auto_menu
setopt magic_equal_subst
setopt numeric_glob_sort
setopt auto_param_keys
setopt auto_param_slash

setopt no_nomatch

zstyle ':completion:*:default' menu select=1
zstyle ':completion:*:default' list-colors ${(s.:.)LSCOLORS}

case ${UID} in
0)
    PROMPT="%(!.#.$) "
    # PROMPT="[${USER}@${HOSTNAME}] %(!.#.$) "
    RPROMPT="[%~]"
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%(!.#.$) "
    # PROMPT="[${USER}@${HOSTNAME}] %(!.#.$) "
    RPROMPT="[%~]"
    PROMPT2="%{[31m%}%_%%%{[m%} "
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
esac 

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt share_history

bindkey -e
 
# historical backward/forward search with linehead string binded to ^P/^N
#
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end
 
# cdr
autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi
# autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
# add-zsh-hook chpwd chpwd_recent_dirs
# zstyle ':chpwd:*' recent-dirs-max 5000
# zstyle ':chpwd:*' recent-dirs-default yes
# zstyle ':completion:*' recent-dirs-insert both

# git
autoload -U colors; colors
function rprompt-git-current-branch {
    local name st color
    name=`git branch 2> /dev/null | grep '^\*' | cut -b 3-`
    if [[ -z $name ]]; then
        return
    fi

    st=`git status`
    if [[ -n `echo "$st" | grep "^nothing to"` ]];  then
        color=${fg[green]}
    elif [[ -n `echo "$st" | grep "^nothing added"` ]];  then
        color=${fg[yellow]}
    elif [[ -n `echo "$st" | grep "^# Untracked"` ]];  then
        color=${fg_bold[red]}
    else
        color=${fg[red]}
    fi
    echo "%{$color%}$name%{$reset_color%} "
}
setopt prompt_subst
RPROMPT='[`rprompt-git-current-branch`%~]'

preexec () {
  [ ${STY} ] && echo -ne "\ek${1%% *}\e\\"
}

# mvn completion
function listMavenCompletions {
    reply=(cli:execute cli:execute-phase archetype:generate compile clean install test test-compile deploy package cobertura:cobertura jetty:run -Dmaven.test.skip=true -DarchetypeCatalog=http://tapestry.formos.com/maven-snapshot-repository -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`);
}
compctl -K listMavenCompletions mvn

# rvm
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi

# command "mvi"
function mvi() {
  if [ $# != 0 ]; then
    mvim --remote-tab-silent $@ 2> /dev/null
  else
    srvs=`mvim --serverlist 2> /dev/null`
    if [ "$srvs" != "" ]; then
      mvim --remote-send ":tabnew<CR>"
    else
      mvim
    fi
  fi
}

# nvm (for node.js)
# if [[ -f ~/.nvm/nvm.sh ]]; then
    # source ~/.nvm/nvm.sh > /dev/null 2>&1
    # if which nvm > /dev/null 2>&1 ; then
        # _nodejs_use_version="v0.6.11"
        # if nvm ls | grep "${_nodejs_use_version}" > /dev/null 2>&1 ; then
            # nvm use "${_nodejs_use_version}" > /dev/null 2>&1
        # fi
        # unset _nodejs_use_version
    # fi
# fi

# source $(brew --prefix nvm)/nvm.sh

# autojump
if [ -e $HOME/local/etc/profile.d/autojump.zsh ]; then
    source $HOME/local/etc/profile.d/autojump.zsh
fi
fpath=($fpath $HOME/local/functions(N))

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# unset LD_LIBRARY_PATH
# unset DYLD_LIBRARY_PATH

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
operafunction print_known_hosts() {
    if [ -f $HOME/.ssh/known_hosts ]; then
        cat $HOME/.ssh/known_hosts | tr ',' ' ' | cut -d' ' -f1
    fi
}
_cache_hosts=($( print_known_hosts ))

# peco settings
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

function peco-cdr() {
    local selected_dir=$(cdr -l | awk '{print $2}' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr
bindkey '^xr' peco-cdr

function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
    if is_screen_or_tmux_running; then
        ! is_exists 'tmux' && return 1

        if is_tmux_runnning; then
            echo "${fg_bold[red]} _____ __  __ _   ___  __ ${reset_color}"
            echo "${fg_bold[red]}|_   _|  \/  | | | \ \/ / ${reset_color}"
            echo "${fg_bold[red]}  | | | |\/| | | | |\  /  ${reset_color}"
            echo "${fg_bold[red]}  | | | |  | | |_| |/  \  ${reset_color}"
            echo "${fg_bold[red]}  |_| |_|  |_|\___//_/\_\ ${reset_color}"
        elif is_screen_running; then
            echo "This is on screen."
        fi
    else
        if shell_has_started_interactively && ! is_ssh_running; then
            if ! is_exists 'tmux'; then
                echo 'Error: tmux command not found' 2>&1
                return 1
            fi

            if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
                # detached session exists
                tmux list-sessions
                echo -n "Tmux: attach? (y/N/num) "
                read
                if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
                    tmux attach-session
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
                    tmux attach -t "$REPLY"
                    if [ $? -eq 0 ]; then
                        echo "$(tmux -V) attached session"
                        return 0
                    fi
                fi
            fi

            # if is_osx && is_exists 'reattach-to-user-namespace'; then
                # # on OS X force tmux's default command
                # # to spawn a shell in the user's namespace
                # tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
                # tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
            # else
                # tmux new-session && echo "tmux created new session"
            # fi
            tmux new-session && echo "tmux created new session"
        fi
    fi
}
# tmux_automatically_attach_session

function tm()
{
    if [ -n "${1}" ]; then
        tmux attach-session -t ${1} || tmux new-session -s ${1}
    else
        tmux attach-session || tmux new-session
    fi
}

# source dnvm.sh
HOMEBREW_CASK_OPTS="--appdir=/Applications"

# export PATH=/usr/local/opt/openssl/bin:$PATH
# export LD_LIBRARY_PATH=/usr/local/opt/openssl/lib:$LD_LIBRARY_PATH
# export CPATH=/usr/local/opt/openssl/include:$LD_LIBRARY_PATH

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/Users/taoyag/.gvm/bin/gvm-init.sh" ]] && source "/Users/taoyag/.gvm/bin/gvm-init.sh"
export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
export PGDATA=/usr/local/var/postgres
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

export PATH=/Applications/XAMPP/bin:$HOME/.nodebrew/current/bin:$PATH
# if [ -d $HOME/.anyenv ] ; then
    # export PATH="$HOME/.anyenv/bin:$PATH"
    # eval "$(anyenv init -)"
   # # tmuxÂÐ±þ
    # for D in `\ls $HOME/.anyenv/envs`
    # do
        # export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    # done
# fi
export PGDATA=/usr/local/var/postgres

export PATH=/Applications/XAMPP/bin:$PATH

export PATH=$PATH:$HOME/local/flutter/bin

[ -f $HOME/.zshrc_local ] && . $HOME/.zshrc_local

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
