# Optional shared tool integrations.

_source_if_present() {
    [[ -f "$1" ]] && source "$1"
}

if command -v brew >/dev/null 2>&1; then
    _brew_prefix="$(brew --prefix 2>/dev/null)"
    if [[ -n "$_brew_prefix" ]]; then
        _source_if_present "$_brew_prefix/opt/fzf/shell/completion.zsh"
        _source_if_present "$_brew_prefix/opt/fzf/shell/key-bindings.zsh"
    fi
fi

_source_if_present "/usr/share/fzf/shell/completion.zsh"
_source_if_present "/usr/share/fzf/shell/key-bindings.zsh"

if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

unset _brew_prefix
unfunction _source_if_present
