# Operating Model

The shell is the shared contract. macOS owns the GUI workflow. Linux hosts are treated as shell-first development environments.

## Layers

Base config should work anywhere zsh and standard Unix tools are available. It owns shell behavior, prompt setup, git defaults, editor environment, and small portable aliases/functions.

macOS config owns GUI applications, Homebrew packages, Ghostty, Zed, Raycast, Rectangle, and system defaults.

Linux config should stay shell-only unless a machine proves otherwise. Remote access and session durability are handled there, not by pretending Linux and macOS have the same desktop model.

Local/private config is sourced last and is not committed. Use it for work aliases, private hostnames, credentials-adjacent settings, internal tools, and machine-specific paths.

## Defaults

Ghostty is the terminal on macOS. Zed is the primary GUI editor. Neovim remains the terminal editor and remote fallback.

Starship is preferred but optional. If it is missing, zsh falls back to a simple prompt.

Runtime versions should be managed with mise when practical. New Python work should prefer uv. New TypeScript work should prefer pnpm while respecting existing repo lockfiles.

Raycast is the macOS command surface. Rectangle handles simple manual window placement. The shell remains the cross-machine source of truth.

Remote shell transport should prioritize terminal fidelity. SSH is the baseline; reconnecting transports should be tested on the actual work network before becoming defaults.

## Rules

Prefer native package managers for baseline tools: Homebrew on macOS, system packages on Linux.

Keep shared aliases small. Put work-specific aliases in `~/.config/dev/local.zsh`.

Source local/private config after shared aliases and functions, before final zsh UI plugins.

Do not publish work-specific hostnames, usernames, internal URLs, API keys, or private agent configuration.
