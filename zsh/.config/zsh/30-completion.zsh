# Completion setup.

autoload -Uz compinit

_zsh_cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
if mkdir -p "$_zsh_cache_dir" 2>/dev/null; then
    compinit -d "$_zsh_cache_dir/zcompdump-$ZSH_VERSION"
else
    compinit
fi
unset _zsh_cache_dir

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
