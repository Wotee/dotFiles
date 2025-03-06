# Add .NET Core SDK tools
export PATH="$PATH:/home/wote/.dotnet/tools"

# Enable zoxide
eval "$(zoxide init bash)"

# Enable git autocomplete
if [ -f ~/.git-completion.bash ]; then
   source ~/.git-completion.bash
fi

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

## Tmux
alias tmux="TERM=screen-256color-bce tmux"

# Catpuccin to ls and similar
# export LS_COLORS="$(vivid generate catppuccin-mocha)"

# Editor info for tmuxinator
export EDITOR='nvim'

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export DISABLE_AUTO_TITLE=true
alias mux=tmuxinator

export PATH="$PATH:/opt/nvim/"

# fnm
FNM_PATH="/home/wote/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

if [ -d "$HOME/.dotnet/tools" ]; then
  export PATH="$HOME/.dotnet/tools:$PATH"
fi

export PATH="$PATH:/usr/local/bin"
alias podman='podman-remote-static-linux_amd64'

# Enable oh my posh
eval "$(~/.local/bin/oh-my-posh init bash --config ~/wotpuccin.omp.json)"
