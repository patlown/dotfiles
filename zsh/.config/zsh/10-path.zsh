# PATH setup with OS/package-manager detection.

typeset -U path PATH

_path_prepend() {
    [[ -d "$1" ]] && path=("$1" $path)
}

if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

_path_prepend "$HOME/.local/bin"

unset -f _path_prepend
