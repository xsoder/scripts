export PYTHONPATH="/home/compsciwins/.local/share/pipx/venvs/manim/lib/python3.13/site-packages:$PYTHONPATH"
eval "$(starship init zsh)"
alias v='nvim'
alias vim='nvim'
bindkey -v

# Alias to filter directories using fzf and open them in a new tmux session
# Alias to search all directories but ignore git directories and open them in nvim
# Alias to search all directories from home but ignore git directories and open them in nvim
alias ff='~/scripts/fzf.sh'
alias gf='~/scripts/fzf_from.sh'
alias gg='~/scripts/git.sh'
alias build='./scripts/build.sh'
alias run='./scripts/run.sh'
alias dev='cd ~/DEV'


# Alias to run the tmux session creation script
alias f='~/scripts/tmux.sh'
alias tt='~/scripts/tmux_sessionizer.sh'
alias cpp='~/scripts/cpp.sh'
alias g='cd $(git ls-tree --name-only HEAD | fzf)'
alias youtube-dl='python3 /usr/local/bin/youtube-dl'
alias cc='gcc'
# Automatically rename tmux window based on the current directory
tmux_rename_window() {
  if [ -n "$TMUX" ]; then
    # Rename the tmux window to the current directory name
    tmux rename-window "$(basename "$PWD")"
  fi
}

# Call the function after each directory change
autoload -Uz add-zsh-hook
add-zsh-hook chpwd tmux_rename_window
export TERM=xterm-256color
if [ -n "$TMUX" ]; then
    alias neofetch='neofetch --no-background'
fi
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

neofetch

export PATH="$HOME/.local/bin:$PATH"
