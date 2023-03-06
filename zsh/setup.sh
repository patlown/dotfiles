#! /usr/bin/env sh

. scripts/functions.sh

info "Setting up zshell..."

info "stowing zshrc"
stow --ignore='setup.sh' -t $HOME zsh/

info "sourcing zshrc"
source zsh/.zshrc

success "Successfully set up zshell."
