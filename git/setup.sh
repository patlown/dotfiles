#! /usr/bin/env sh

. scripts/functions.sh

info "Configuring git..."

stow --t $HOME --ignore='setup.sh' git

git config --global core.excludesfile $HOME/.gitignore_global

success "Finished configuring git."
