# dotfiles

Personal macOS development setup.

This repo is designed to be adopted gradually on Macs that may already have apps, configs, and work-specific setup. Shared config lives here. Private machine/work config lives outside the repo.

## Quick Start On Another Mac

Use this on an already configured MacBook:

```sh
xcode-select --install
git clone https://github.com/patlown/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`./install.sh` defaults to **adopt mode**. It installs baseline Homebrew tools/apps, stows shared dotfiles, and skips heavy or privileged setup like Xcode, macOS defaults, and agent installers.

For a fresh personal Mac where it is okay to apply everything:

```sh
cd ~/.dotfiles
./install.sh full
```

## Existing Machine Rules

Do not reset the machine. Adopt the shared pieces and keep local differences.

The installer backs up conflicting real files into:

```sh
~/.dotfiles.backup
```

Shared files are linked with Stow. Machine-specific files should not be committed.

## Local And Work Overrides

Put private aliases, internal paths, work hostnames, and machine-specific shell setup here:

```sh
mkdir -p ~/.config/dev
$EDITOR ~/.config/dev/local.zsh
```

`~/.zshrc.local` is also sourced as a compatibility escape hatch.

Shared zsh loads local overrides near the end, after shared aliases/functions and before final zsh UI plugins.

## Manual / Privileged Apps

Some apps use package installers, system extensions, or admin prompts. Install them from a real terminal when needed:

```sh
brew install --cask karabiner-elements
brew install --cask logi-options+
```

After installing:

- Karabiner/Kanata: approve system extension, Input Monitoring, and Accessibility prompts.
- Logi Options+: approve prompted permissions and reboot if requested.

Kanata notes live in [docs/kanata-macos.md](docs/kanata-macos.md).

## What This Owns

### Shell

- Layered zsh config under `~/.config/zsh`
- Starship prompt, optional with fallback
- fzf integration
- zsh autosuggestions and syntax highlighting
- small shared aliases/functions

### CLI Tools

| Tool | Purpose |
|------|---------|
| `rg` | fast search |
| `fd` | fast find |
| `eza` | `ls` replacement |
| `bat` | `cat` with syntax highlighting |
| `delta` | git diffs |
| `mise` | Python/Node/Java runtime management |
| `uv` | Python project tooling |
| `pnpm` | TypeScript package management |
| `kanata` | keyboard remapping |

### Mac Apps

- Ghostty
- Zed
- Raycast
- Rectangle
- Jump Desktop Connect
- Karabiner Elements, manual install when needed
- Logi Options+, manual install when needed

## Stow Packages

The installer stows:

```sh
zsh git nvim ghostty starship kanata
```

To restow manually:

```sh
cd ~/.dotfiles
stow -R zsh git nvim ghostty starship kanata
```

## Structure

```text
~/.dotfiles/
├── install.sh
├── homebrew/Brewfile
├── docs/
├── macos/defaults.sh
├── zsh/
├── git/
├── nvim/
├── ghostty/
├── starship/
└── kanata/
```

See [docs/operating-model.md](docs/operating-model.md) for the setup principles.

## After Setup

Open a new Ghostty tab or run:

```sh
source ~/.zshrc
```

Then check:

```sh
mise doctor
uv --version
pnpm --version
kanata --check --cfg ~/.config/kanata/kanata.kbd
```

After the manual/privileged apps are installed, this should pass:

```sh
brew bundle check --file ~/.dotfiles/homebrew/Brewfile
```
