#!/bin/bash

# Install XCode CLI Tools if not installed
if ! xcode-select -p &>/dev/null; then
    xcode-select --install
    echo "Xcode CLI tools installed"
else
    echo "Xcode CLI tools already installed"
fi

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

# System preferences tweaks
defaults write NSGlobalDomain KeyRepeat -int 0
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.dock springboard-page-duration -float .2
defaults write com.apple.dock springboard-show-duration -float .1
defaults write com.apple.dock springboard-hide-duration -float .1
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
defaults write com.apple.dock launchanim -bool false
defaults write -g QLPanelAnimationDuration -float 0.01
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
killall Dock

defaults write com.apple.finder DisableAllAnimations -bool true
killall Finder

# Install Homebrew packages
brew install git zsh rectangle-pro raycast alt-tab hiddenbar stats itsycal keepingyouawake keka visual-studio-code wget ffmpeg git-credential-manager obsidian iterm2 font-jetbrains-mono bpytop 
chsh -s $(which zsh) $USER

# # Install Miniconda if not installed
# if [ ! -d "$HOME/miniconda3" ]; then
#     mkdir -p ~/miniconda3
#     curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
#     bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
#     rm -rf ~/miniconda3/miniconda.sh
#     ~/miniconda3/bin/conda init zsh
#     echo "Miniconda installed"
# else
#     echo "Miniconda already installed"
# fi

# Install oh-my-zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone "https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv.git" ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autoswitch_virtualenv
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
    echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting autoswitch_virtualenv)' >> ~/.zshrc
else
    echo "oh-my-zsh already installed"
fi

# Set iTerm2 as default terminal
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
osascript -e 'tell application "Terminal" to quit'
open -a iTerm
sleep 2
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.unix-executable;LSHandlerRoleAll=com.googlecode.iterm2;}'
defaults write com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers -array-add '{LSHandlerContentType=public.data;LSHandlerRoleAll=com.googlecode.iterm2;}'

# Configure apps to start at login
for app in "Rectangle Pro" "AltTab" "HiddenBar" "Stats" "Itsycal" "KeepingYouAwake" "Raycast"; do
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/$app.app\", hidden:false}"
done

# Launch background utility apps
for app in "Rectangle Pro" "Alt-Tab" "HiddenBar" "Stats" "Itsycal" "KeepingYouAwake" "RayCast"; do
    open -a "$app"
done
exec zsh
