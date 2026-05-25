#!/bin/zsh
# ============================================================================
#                           DOTFILES INSTALLER
# ============================================================================

set -e

INSTALL_MODE="${1:-adopt}"

# Add Homebrew to PATH if it exists (so we can detect it)
if [[ -f "/opt/homebrew/bin/brew" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Colors
CYAN='\033[38;5;51m'
BLUE='\033[38;5;39m'
PURPLE='\033[38;5;129m'
MAGENTA='\033[38;5;201m'
PINK='\033[38;5;213m'
ORANGE='\033[38;5;208m'
GREEN='\033[38;5;82m'
RED='\033[38;5;196m'
YELLOW='\033[38;5;226m'
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'

# ----------------------------------------------------------------------------
# ASCII Art Banner
# ----------------------------------------------------------------------------
print_banner() {
    echo ""
    echo -e "${CYAN}       ██╗██╗   ██╗██╗ ██████╗██╗███╗   ██╗ ██████╗${RESET}"
    echo -e "${BLUE}       ██║██║   ██║██║██╔════╝██║████╗  ██║██╔════╝${RESET}"
    echo -e "${PURPLE}       ██║██║   ██║██║██║     ██║██╔██╗ ██║██║  ███╗${RESET}"
    echo -e "${MAGENTA}  ██   ██║██║   ██║██║██║     ██║██║╚██╗██║██║   ██║${RESET}"
    echo -e "${PINK}  ╚█████╔╝╚██████╔╝██║╚██████╗██║██║ ╚████║╚██████╔╝${RESET}"
    echo -e "${ORANGE}   ╚════╝  ╚═════╝ ╚═╝ ╚═════╝╚═╝╚═╝  ╚═══╝ ╚═════╝${RESET}"
    echo ""
    echo -e "${DIM}              🍊 patrick's mac setup 🍊${RESET}"
    echo ""
}

# ----------------------------------------------------------------------------
# Helpers
# ----------------------------------------------------------------------------
print_section() {
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════${RESET}"
    echo -e "${BOLD}  $1${RESET}"
    echo -e "${CYAN}══════════════════════════════════════════════════════${RESET}"
    echo ""
}

print_success() {
    echo -e "${GREEN}[✓]${RESET} $1"
}

print_error() {
    echo -e "${RED}[✗]${RESET} $1"
}

print_info() {
    echo -e "${BLUE}[i]${RESET} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${RESET} $1"
}

# Run a command with spinner animation
run_with_spinner() {
    local label="$1"
    shift
    local cmd="$@"
    local logfile="/tmp/dotfiles-install-$$.log"

    # Run command in background, capture output to log
    eval "$cmd" > "$logfile" 2>&1 &
    local pid=$!

    # Show spinner while running
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while kill -0 $pid 2>/dev/null; do
        printf "\r ${CYAN}[${spinstr:0:1}]${RESET} %s" "$label"
        spinstr=${spinstr:1}${spinstr:0:1}
        sleep 0.1
    done

    # Check exit status
    wait $pid
    local exit_code=$?

    # Clear line and show result
    printf "\r\033[K"
    if [[ $exit_code -eq 0 ]]; then
        print_success "$label"
        rm -f "$logfile"
    else
        print_error "$label"
        echo -e "${DIM}$(cat "$logfile")${RESET}"
        rm -f "$logfile"
        return 1
    fi
}

# ----------------------------------------------------------------------------
# Checks
# ----------------------------------------------------------------------------
check_xcode() {
    if xcode-select -p &> /dev/null; then
        print_success "Xcode Command Line Tools"
        return 0
    else
        return 1
    fi
}

check_homebrew() {
    if command -v brew &> /dev/null; then
        print_success "Homebrew"
        return 0
    else
        return 1
    fi
}

# ----------------------------------------------------------------------------
# Installers
# ----------------------------------------------------------------------------
install_xcode() {
    # Trigger the install dialog
    xcode-select --install 2>/dev/null || true

    # Wait for installation to complete
    print_info "Waiting for Xcode Command Line Tools installation..."
    until xcode-select -p &>/dev/null; do
        sleep 5
    done
    print_success "Xcode Command Line Tools installed"
}

install_homebrew() {
    # Download and run Homebrew installer (NONINTERACTIVE skips prompts)
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew-install.sh
    run_with_spinner "Installing Homebrew" "NONINTERACTIVE=1 /bin/bash /tmp/brew-install.sh"
    rm -f /tmp/brew-install.sh

    # Add Homebrew to PATH for this session (Apple Silicon)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
    fi
}

install_packages() {
    # Brew formulae (same as Brewfile)
    local brews=(
        mas stow git starship zsh-autosuggestions zsh-syntax-highlighting
        ripgrep fd fzf eza bat delta neovim mise uv pnpm kanata
    )

    # Brew casks that install cleanly without privileged package installers.
    local casks=("ghostty@tip" "zed" "raycast" "rectangle" "jump-desktop-connect")

    # Install formulae
    for pkg in "${brews[@]}"; do
        if brew list "$pkg" &>/dev/null; then
            print_success "$pkg (already installed)"
        else
            run_with_spinner "Installing $pkg" "brew install $pkg"
        fi
    done

    # Install casks
    for cask in "${casks[@]}"; do
        if brew list --cask "$cask" &>/dev/null 2>&1; then
            print_success "$cask (already installed)"
        else
            run_with_spinner "Installing $cask" "brew install --cask $cask"
        fi
    done
}

print_manual_steps() {
    print_section "MANUAL / PRIVILEGED APPS"
    print_info "Install these from a real terminal when needed:"
    echo "  brew install --cask karabiner-elements"
    echo "  brew install --cask logi-options+"
    echo ""
    print_info "Both may require an administrator password and macOS Privacy & Security approval."
}

# ----------------------------------------------------------------------------
# Stow dotfiles
# ----------------------------------------------------------------------------

# Check if a symlink already points to the right place
is_correctly_linked() {
    local target="$1"
    local dotfiles_dir="$HOME/.dotfiles"

    if [[ -L "$target" ]]; then
        local link_target=$(readlink "$target")
        # Check if it points into our dotfiles
        if [[ "$link_target" == *".dotfiles"* ]]; then
            return 0
        fi
    fi
    return 1
}

# Backup a file/directory if it exists and isn't already a symlink to our dotfiles
backup_if_exists() {
    local target="$1"
    local backup_dir="$HOME/.dotfiles.backup"

    # Already correctly linked - nothing to do
    if is_correctly_linked "$target"; then
        return 1  # Signal that no backup was needed
    fi

    if [[ -e "$target" ]] && [[ ! -L "$target" ]]; then
        # It's a real file/directory, not a symlink - back it up
        mkdir -p "$backup_dir"
        local backup_name="$(basename "$target").$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup_dir/$backup_name"
        print_warning "Backed up existing $target → $backup_dir/$backup_name"
        return 0
    elif [[ -L "$target" ]]; then
        # It's a symlink pointing somewhere else - remove it
        rm "$target"
        return 0
    fi
    return 0
}

stow_dotfiles() {
    local dotfiles_dir="$HOME/.dotfiles"
    local packages=(zsh git nvim ghostty starship kanata)
    local any_changed=false

    # Primary file for each package (to check if already stowed)
    declare -A package_primary
    package_primary[zsh]=".zshrc"
    package_primary[git]=".gitconfig"
    package_primary[nvim]=".config/nvim"
    package_primary[ghostty]=".config/ghostty"
    package_primary[starship]=".config/starship.toml"
    package_primary[kanata]=".config/kanata"

    # All files for each package (for backup purposes)
    declare -A package_files
    package_files[zsh]=".zshrc .config/zsh"
    package_files[git]=".gitconfig .gitignore_global"
    package_files[nvim]=".config/nvim"
    package_files[ghostty]=".config/ghostty"
    package_files[starship]=".config/starship.toml"
    package_files[kanata]=".config/kanata"

    cd "$dotfiles_dir"

    for package in "${packages[@]}"; do
        if [[ -d "$package" ]]; then
            local primary="$HOME/${package_primary[$package]}"

            # Check if already correctly stowed
            if is_correctly_linked "$primary"; then
                print_success "$package (already linked)"
                continue
            fi

            # Backup any existing files that would conflict
            for file in ${package_files[$package]}; do
                backup_if_exists "$HOME/$file"
            done

            # Stow with --restow for idempotency
            if stow -R "$package" 2>&1; then
                print_success "$package"
                any_changed=true
            else
                print_error "$package - run 'stow -v $package' in $HOME/.dotfiles for details"
            fi
        fi
    done

    cd - > /dev/null
}


# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
main() {
    print_banner

    if [[ "$INSTALL_MODE" != "adopt" && "$INSTALL_MODE" != "full" ]]; then
        print_error "Unknown mode: $INSTALL_MODE"
        echo "Usage: ./install.sh [adopt|full]"
        return 1
    fi

    # Prerequisites
    print_section "INSTALLING PREREQUISITES"

    if ! check_xcode; then
        install_xcode
        check_xcode
    fi

    if ! check_homebrew; then
        install_homebrew
        check_homebrew
    fi

    # Packages
    print_section "INSTALLING PACKAGES"
    install_packages

    if [[ "$INSTALL_MODE" == "full" ]]; then
        # Xcode (full app for iOS development)
        print_section "INSTALLING XCODE"
        if [[ -d "/Applications/Xcode.app" ]]; then
            print_success "Xcode (already installed)"
        else
            run_with_spinner "Installing Xcode (this takes a while)" "mas install 497799835"
            # Accept license and install additional components
            run_with_spinner "Accepting Xcode license" "sudo xcodebuild -license accept"
        fi
    else
        print_section "SKIPPING FULL-BOOTSTRAP STEPS"
        print_info "adopt mode skips Xcode and other heavy/privileged setup."
        print_info "Run './install.sh full' on a fresh personal Mac when you want everything."
    fi

    # Stow
    print_section "LINKING DOTFILES"
    stow_dotfiles

    if [[ "$INSTALL_MODE" == "full" ]]; then
        # macOS defaults
        print_section "CONFIGURING MACOS"
        if [[ -f "$HOME/.dotfiles/macos/defaults.sh" ]]; then
            run_with_spinner "Applying macOS defaults" "zsh $HOME/.dotfiles/macos/defaults.sh"
        fi
    else
        print_info "Skipping macOS defaults in adopt mode."
    fi

    if [[ "$INSTALL_MODE" == "full" ]]; then
        # Claude Code
        print_section "INSTALLING CLAUDE CODE"
        if command -v claude &> /dev/null; then
            print_success "Claude Code (already installed)"
        else
            run_with_spinner "Installing Claude Code" "curl -fsSL https://claude.ai/install.sh | bash"
        fi

        # Codex
        print_section "INSTALLING CODEX"
        if brew list --cask codex &>/dev/null 2>&1; then
            print_success "Codex (already installed)"
        else
            run_with_spinner "Installing Codex" "brew install --cask codex"
        fi
    else
        print_info "Skipping agent CLI installers in adopt mode."
    fi

    print_manual_steps

    # Done!
    print_section "DONE!"
    echo -e "  ${GREEN}Your dotfiles have been installed!${RESET}"
    echo ""
    echo -e "  Restart your terminal or run: ${CYAN}source ~/.zshrc${RESET}"
    echo ""
}

main "$@"
