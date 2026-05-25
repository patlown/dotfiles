#!/bin/zsh
# ============================================================================
#                          macOS DEFAULTS
#              Sensible settings for power users
# ============================================================================

# Close any open System Preferences panes
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true

echo "Applying macOS defaults..."

# ============================================================================
# Keyboard
# ============================================================================

defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ============================================================================
# Sound
# ============================================================================

defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# ============================================================================
# Trackpad / Mouse
# ============================================================================

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write -g com.apple.trackpad.scaling -float 2.0

# ============================================================================
# Finder
# ============================================================================

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# ============================================================================
# Dock
# ============================================================================

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mineffect -string "scale"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool true

# ============================================================================
# Screenshots
# ============================================================================

mkdir -p ~/Screenshots
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ============================================================================
# Safari (may fail before first launch)
# ============================================================================

defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true 2>/dev/null || true
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true 2>/dev/null || true

# ============================================================================
# TextEdit
# ============================================================================

defaults write com.apple.TextEdit RichText -int 0

# ============================================================================
# Activity Monitor
# ============================================================================

defaults write com.apple.ActivityMonitor ShowCategory -int 0

# ============================================================================
# Restart affected apps
# ============================================================================

killall Dock &>/dev/null || true
killall Finder &>/dev/null || true

echo "Done! Some changes may require a logout/restart."
