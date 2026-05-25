# Final interactive shell UI plugins. Syntax highlighting should stay last.

_source_if_present() {
    [[ -f "$1" ]] && source "$1"
}

if command -v brew >/dev/null 2>&1; then
    _brew_prefix="$(brew --prefix 2>/dev/null)"
    if [[ -n "$_brew_prefix" ]]; then
        _source_if_present "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        _source_if_present "$_brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    fi
fi

_source_if_present "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
_source_if_present "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

unset _brew_prefix
unfunction _source_if_present
