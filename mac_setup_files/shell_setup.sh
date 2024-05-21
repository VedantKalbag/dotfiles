#/bin/bash

defaults write NSGlobalDomain KeyRepeat -int 0
defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.dock springboard-page-duration -float .2
defaults write com.apple.dock springboard-show-duration -float .1
defaults write com.apple.dock springboard-hide-duration -float .1
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock launchanim -bool false
defaults write -g QLPanelAnimationDuration -float 0.01
killall Dock
defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# Install Homebrew and apps
brew install rectangle alt-tab hiddenbar stats itsycal keepingyouawake keka visual-studio-code wget ffmpeg 
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
