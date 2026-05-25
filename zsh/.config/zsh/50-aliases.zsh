# Shared aliases. Keep this list small and portable.

if command -v eza >/dev/null 2>&1; then
    alias ls="eza"
    alias ll="eza -l --git"
    alias la="eza -la --git"
    alias lt="eza --tree --level=2"
    alias lta="eza --tree --level=2 -a"
else
    alias ll="ls -l"
    alias la="ls -la"
fi

if command -v bat >/dev/null 2>&1; then
    alias cat="bat --paging=never"
    alias catp="bat"
fi

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias glog="git log --oneline --graph --decorate -10"

alias v="nvim"
alias vim="nvim"

alias reload="source ~/.zshrc"
alias path='echo $PATH | tr ":" "\n"'
alias ports="lsof -i -P -n | grep LISTEN"

alias brewup="brew update && brew upgrade && brew cleanup"
alias dot="cd ~/.dotfiles"
