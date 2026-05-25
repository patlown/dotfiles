# Shared interactive zsh entrypoint.

[[ -o interactive ]] || return 0

_zsh_source() {
    [[ -f "$1" ]] && source "$1"
}

_zsh_config_dir="${${(%):-%N}:A:h}"

_zsh_source "$_zsh_config_dir/00-env.zsh"
_zsh_source "$_zsh_config_dir/10-path.zsh"
_zsh_source "$_zsh_config_dir/20-history.zsh"
_zsh_source "$_zsh_config_dir/30-completion.zsh"
_zsh_source "$_zsh_config_dir/40-tools.zsh"
_zsh_source "$_zsh_config_dir/50-aliases.zsh"
_zsh_source "$_zsh_config_dir/60-functions.zsh"
_zsh_source "$_zsh_config_dir/65-network-functions.zsh"
_zsh_source "$_zsh_config_dir/80-prompt.zsh"
_zsh_source "$_zsh_config_dir/90-local.zsh"
_zsh_source "$_zsh_config_dir/99-interactive.zsh"

unset _zsh_config_dir
unfunction _zsh_source
