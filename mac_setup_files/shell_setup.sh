#/bin/bash

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Sets the key repeat rate to maximum speed (0 = fastest)
defaults write NSGlobalDomain KeyRepeat -int 0

# Sets how long before a held key starts repeating (10 = 150ms, faster than default 15 = 225ms)
defaults write -g InitialKeyRepeat -int 10

# Sets the key repeat interval (1 = 15ms, faster than default 2 = 30ms)
defaults write -g KeyRepeat -int 1

# Makes window resizing nearly instant by setting animation time to 0.001 seconds
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Speeds up Mission Control page switching animation to 0.2 seconds
defaults write com.apple.dock springboard-page-duration -float .2

# Sets Mission Control show animation to 0.1 seconds
defaults write com.apple.dock springboard-show-duration -float .1

# Sets Mission Control hide animation to 0.1 seconds
defaults write com.apple.dock springboard-hide-duration -float .1

# Removes the delay before the Dock shows when auto-hide is enabled
defaults write com.apple.dock autohide-delay -float 0

# Makes the Dock show/hide animation instant
defaults write com.apple.dock autohide-time-modifier -int 0

# Disables the animation when launching applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Speeds up Quick Look window animations to 0.01 seconds
defaults write -g QLPanelAnimationDuration -float 0.01

# Enables right-click on trackpad
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Restarts the Dock to apply changes
killall Dock

# Disables all animations in Finder
defaults write com.apple.finder DisableAllAnimations -bool true

# Restarts Finder to apply changes
killall Finder

# Install Homebrew and apps
brew install git rectangle-pro raycast alt-tab hiddenbar stats itsycal keepingyouawake keka visual-studio-code wget ffmpeg git-credential-manager obsidian iterm2  
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono
brew install zsh

# Install Miniconda
mkdir -p ~/miniconda3
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install XCode CLI Tools
xcode-select --install 2>&1 | grep "xcode-select" > /dev/null || echo "Xcode CLI tools installed"
