case "$OSTYPE" in
darwin*)
  export LANG=ja_JP.UTF-8
  
  export PATH=/usr/local/bin:/opt/local/bin:/opt/local/sbin/:/usr/X11/bin:$PATH
  #export PATH=/usr/local/hyperestraier/bin:/opt/local/bin:/opt/local/sbin/:/usr/X11/bin:/usr/local/mysql/bin:/usr/local/bin/:$PATH
  export MANPATH=/opt/local/man:$MANPATH
  export MITSCHEME_LIBRARY_PATH=~/mit-scheme
  export SVN_EDITOR=vi
  export LSCOLORS=gxfxcxdxbxegedabagacad
  export VIMRUNTIME=/Applications/MacVim.app/Contents/Resources/vim/runtime
  export TERM=xterm-256color
  export JAVA_HOME=/Library/Java/Home
  export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
  export SCREENDIR=/Users/taoyag/tmp/screen
  
  export PATH=$HOME/bin:$PATH
  
  # git
#  export PATH=/usr/local/git/bin:$PATH
#  export MANPATH=/usr/local/git/man:$MANPATH
  # jruby
  export JRUBY=/usr/local/jruby-1.1.6/bin
  export PATH=$PATH:$JRUBY
  # maven2
  export M2_HOME=~/java/apache-maven-2.0.9
  export M2=$M2_HOME/bin
  export PATH=$M2:$PATH
  # oracle client
  export ORACLE_HOME=/Users/Shared/ohome
  export DYLD_LIBRARY_PATH=/usr/local/hyperestraier/lib:$ORACLE_HOME/lib:$DYLD_LIBRARY_PATH
  export PATH=$ORACLE_HOME/bin:$PATH
  export NLS_LANG=japanese_japan.UTF8
  # rubygems
  export RUBYLIB=/usr/local/app/ruby/lib:/usr/local/app/rubygems/lib
  export GEM_HOME=/usr/local/app/ruby/lib/ruby/gems/1.8
  #export RUBYLIB=/opt/local/lib
  #export GEM_HOME=/opt/local/lib/ruby/gems/1.8
  # Adobe Flex SDK
  export FLEX3_HOME=/usr/local/flex_sdk_3.4
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

  alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
  alias screen="/usr/local/bin/screen"
  alias less="/usr/share/vim/vim72/macros/less.sh"
  alias scaladoc="scala -i ~/scala/InteractiveHelp/import.scala -cp ~/scala/InteractiveHelp/interactive-help-1.0.jar"
  alias ls='ls -vG'
  alias man='TERMINFO=~/.terminfo/ LESS=C TERM=mostlike PAGER=less man'
  alias firefox='open -a Firefox'
  alias prev='open -a Preview'
  ;;
linux*)
  export LANG=ja_JP.UTF-8
  export PATH=/usr/local/bin/:$PATH
  export SVN_EDITOR=vi
  export JAVA_HOME=/usr/lib/jvm/java-6-sun
  export PATH=$HOME/bin:$PATH
  # vim
  export PATH=/usr/local/vim/bin:$PATH
  export VIMRUNTIME=/usr/local/vim/share/vim/vim72
  # maven2
  export M2_HOME=/usr/local/apache-maven
  export M2=$M2_HOME/bin
  export PATH=$M2:$PATH
  # scala
  export PATH=/usr/local/scala/bin:$PATH

  alias vi='vim'
  alias ls='ls -vG'
  ;;
esac

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
[ ${STY} ] || screen -rx || screen -D -RR

# mvn completion
function listMavenCompletions {
    reply=(cli:execute cli:execute-phase archetype:generate compile clean install test test-compile deploy package cobertura:cobertura jetty:run -Dmaven.test.skip=true -DarchetypeCatalog=http://tapestry.formos.com/maven-snapshot-repository -Dtest= `if [ -d ./src ] ; then find ./src -type f | grep -v svn | sed 's?.*/\([^/]*\)\..*?-Dtest=\1?' ; fi`);
}
compctl -K listMavenCompletions mvn
