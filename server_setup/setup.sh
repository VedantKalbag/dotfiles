#!/bin/bash
set -e  # Exit on any error

# Install required packages if not installed
echo "Installing git and zsh..."
if ! command -v git &>/dev/null; then
    sudo apt-get install git -y
else
    echo "Git is already installed."
fi

if ! command -v zsh &>/dev/null; then
    sudo apt-get install zsh -y
else
    echo "Zsh is already installed."
fi

# Install Oh My Zsh if not installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Set ZSH_CUSTOM if not set
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# Install Oh My Zsh plugins and themes
echo "Installing Oh My Zsh plugins and themes..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM}/themes/powerlevel10k || echo "Powerlevel10k already installed."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions || echo "zsh-autosuggestions already installed."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting || echo "zsh-syntax-highlighting already installed."
git clone https://github.com/rutchkiwi/copyzshell.git ${ZSH_CUSTOM}/plugins/copyzshell || echo "copyzshell already installed."

echo "Plugins and themes setup complete."

# Change default shell to zsh
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Setting Zsh as default shell..."
    chsh -s "$(command -v zsh)"
fi

# Install Miniconda if not already installed

MINICONDA_PATH="$HOME/miniconda3"
if [ ! -d "$MINICONDA_PATH" ]; then
  echo "Installing Miniconda..."
  mkdir -p "$MINICONDA_PATH"
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O "$MINICONDA_PATH/miniconda.sh"
  bash "$MINICONDA_PATH/miniconda.sh" -b -u -p "$MINICONDA_PATH"
  rm -rf "$MINICONDA_PATH/miniconda.sh"
  # Initialize Miniconda for all supported shells
  echo "Initializing Miniconda for all available shells..."
  for shell in bash zsh fish tcsh xonsh; do
    if command -v "$shell" &>/dev/null; then
      "$MINICONDA_PATH/bin/conda" init "$shell"
    fi
  done
else
  echo "Miniconda is already installed."
fi

# Ensure Powerlevel10k theme and plugins are configured in .zshrc
echo "Configuring .zshrc..."

# Set Powerlevel10k theme
if ! grep -q 'ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc; then
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi

# Set plugins (avoid duplication)
PLUGINS_LINE='plugins=(git zsh-autosuggestions zsh-syntax-highlighting copyzshell)'
if ! grep -q '^plugins=(' ~/.zshrc; then
    echo "$PLUGINS_LINE" >> ~/.zshrc
else
    sed -i "s/^plugins=(.*)/$PLUGINS_LINE/" ~/.zshrc
fi

# Apply changes
exec zsh