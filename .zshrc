case "$OSTYPE" in
darwin*)
  export LANG=ja_JP.UTF-8
  
  export PATH=/opt/local/bin:/opt/local/sbin/:/usr/X11/bin:/usr/local/mysql/bin:/usr/local/bin/:$PATH
  export MANPATH=/opt/local/man:$MANPATH
  export MITSCHEME_LIBRARY_PATH=~/mit-scheme
  export SVN_EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
  export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
  export LSCOLORS=gxfxcxdxbxegedabagacad
  export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime
  # export TERM=xterm-256color
  export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Versions/1.6.0/Home
  export PATH=$JAVA_HOME/bin:$PATH
  export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"

  export SCREENDIR=/Users/taoyag/tmp/screen
  
  export PATH=$HOME/bin:$PATH
  
  # git
#  export PATH=/usr/local/git/bin:$PATH
#  export MANPATH=/usr/local/git/man:$MANPATH
  # jruby
  #export JRUBY=/usr/local/app/jruby/bin
  #export PATH=$PATH:$JRUBY
  # scala
  export PATH=$HOME/local/scala/bin:$PATH
  # maven2
  export M2_HOME=~/java/apache-maven-2.0.9
  export M2=$M2_HOME/bin
  export PATH=$M2:$PATH
  # oracle client
  export ORACLE_HOME=/Users/Shared/ohome
  export ORACLE_SID=XE
  export DYLD_LIBRARY_PATH=/usr/local/hyperestraier/lib:$ORACLE_HOME/lib:$DYLD_LIBRARY_PATH
  export PATH=$ORACLE_HOME/bin:$PATH
  export NLS_LANG=japanese_japan.UTF8
  export SQLPATH=$HOME/sql
  # rubygems
  #export RUBYLIB=/usr/local/app/ruby/lib:/usr/local/app/rubygems/lib
  #export GEM_HOME=/usr/local/app/ruby/lib/ruby/gems/1.8
  #export PATH=/usr/local/app/ruby/lib/ruby/gems/1.8/bin:$PATH
  #export RUBYLIB=/opt/local/lib
  #export GEM_HOME=/opt/local/lib/ruby/gems/1.8
  # Adobe Flex SDK
  export FLEX3_HOME=/usr/local/flex_sdk_3
  export FLEX3=$FLEX3_HOME/bin
  export PATH=$FLEX3:$PATH
  # Adobe Air SDK
  export AIR_HOME=/usr/local/air.5.2
  export AIR=$AIR_HOME/bin
  export PATH=$AIR:$PATH
  # scaladoc
  export SCALA_DOC_HOME=~/scala/InteractiveHelp/scala-2.7.5-apidocs-fixed/
  # stax
  export STAX_HOME=/usr/local/stax-sdk-0.3.6
  export PATH=$STAX_HOME:$PATH

  # play
  export PLAY_HOME=~/java/play-1.1
  export PATH=$PLAY_HOME:$PATH
  # cabal
  export PATH=$HOME/.cabal/bin:$PATH

  alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
#   alias screen="/usr/bin/screen"
  #alias screen="/usr/local/bin/screen"
  alias screen="/Users/taoyag/bin/screen"
  # alias less="/usr/share/vim/vim72/macros/less.sh"
  alias less="/Applications/MacVim.app/Contents/Resources/vim/runtime/macros/less.sh"
  alias scaladoc="scala -i ~/scala/InteractiveHelp/import.scala -cp ~/scala/InteractiveHelp/interactive-help-1.0.jar"
  alias ls='ls -vG'
  alias man='TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man'
  alias firefox='open -a Firefox'
  alias prev='open -a Preview'

  if [ ! -S $SSH_AUTH_SOCK ]; then
      eval `ssh-agent -a $SSH_AUTH_SOCK`
      echo $SSH_AGENT_PID > /tmp/ssh_agent_pid
      ssh-add
  else
      export SSH_AGENT_PID=`cat /tmp/ssh_agent_pid`
  fi
  ;;
linux*)
  export LANG=ja_JP.UTF-8
  export PATH=/usr/local/bin/:$PATH
  export SVN_EDITOR=vi
#  export JAVA_HOME=/usr/lib/jvm/java-6-sun
  export PATH=$HOME/bin:$PATH
  # vim
#  export PATH=/usr/local/vim/bin:$PATH
#  export VIMRUNTIME=/usr/local/vim/share/vim/vim72
  # maven2
#  export M2_HOME=/usr/local/apache-maven
#  export M2=$M2_HOME/bin
#  export PATH=$M2:$PATH
  # scala
#  export PATH=/usr/local/scala/bin:$PATH

  alias vi='vim'
  alias ls='ls -vG'
  ;;
esac

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
# tscreen
# if [ -x /usr/bin/tscreen -o ]; then
    # alias screen="$HOME/bin/screen.sh"
    # # alias screen="tscreen"
# fi

# fpath=(~/zsh-function $fpath)
# autoload -U ~/zsh-function/*(:t)

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
    PROMPT="[${USER}@${HOSTNAME}] %(!.#.$) "
    RPROMPT="[%~]"
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="[${USER}@${HOSTNAME}] %(!.#.$) "
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
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
 

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
# [ ${STY} ] || screen -rx || screen -D -RR

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
if [[ -f ~/.nvm/nvm.sh ]]; then
    source ~/.nvm/nvm.sh > /dev/null 2>&1
    if which nvm > /dev/null 2>&1 ; then
        _nodejs_use_version="v0.6.11"
        if nvm ls | grep "${_nodejs_use_version}" > /dev/null 2>&1 ; then
            nvm use "${_nodejs_use_version}" > /dev/null 2>&1
        fi
        unset _nodejs_use_version
    fi
fi

is_screen_running() {
    # tscreen also uses this varariable.
    [ ! -z "$WINDOW" ]
}
is_tmux_runnning() {
    [ ! -z "$TMUX" ]
}
is_screen_or_tmux_running() {
    is_screen_running || is_tmux_runnning
}
shell_has_started_interactively() {
    [ ! -z "$PS1" ]
}
resolve_alias() {
    cmd="$1"
    while \
        whence "$cmd" >/dev/null 2>/dev/null \
        && [ "$(whence "$cmd")" != "$cmd" ]
    do
        cmd=$(whence "$cmd")
    done
    echo "$cmd"
}


if ! is_screen_or_tmux_running && shell_has_started_interactively; then
    for cmd in tmux tscreen screen; do
        if whence $cmd >/dev/null 2>/dev/null; then
            $(resolve_alias "$cmd")
            break
        fi
    done
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
