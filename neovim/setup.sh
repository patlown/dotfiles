#! /usr/bin/env sh

. scripts/functions.sh

info "stowing Neovim"
stow --ignore='setup.sh' -t $HOME neovim/

success "Finished setting up Neovim."
