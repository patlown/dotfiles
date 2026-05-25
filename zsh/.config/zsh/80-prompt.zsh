# Prompt setup. Starship is preferred but optional.

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
else
    PROMPT='%F{cyan}%~%f %# '
fi
