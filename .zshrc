# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"

# Set theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting you-should-use)

# Source Oh My Zsh if installed
if [ -d "$ZSH" ]; then
  source $ZSH/oh-my-zsh.sh
fi

# Ensure Powerlevel10k is installed before sourcing
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

# Load Powerlevel10k config if present
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# Ensure plugins exist before enabling them
for plugin in "${plugins[@]}"; do
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
    echo "Warning: Plugin '$plugin' not found. Skipping..."
  fi
done

# Aliases
alias gl="git log --oneline"
alias ga="git add"
alias gaa="git add --all"
alias gd="git diff"
alias path="echo $PATH"
alias cl="clear"
alias gpu="watch nvidia-smi"
alias top="python3 -m bpytop"
alias gcloud="$HOME/google-cloud-sdk/bin/gcloud"
alias gsutil="$HOME/google-cloud-sdk/bin/gsutil"
alias untar="tar -xvf"
alias .="ls"

# Auto `ls` after `cd`
chpwd() {
  local file_count
  file_count=$(ls -A | wc -l)  # Count all files and directories (including hidden ones)

  if [ "$file_count" -lt 100 ]; then
    ls -A  # Show all files, including hidden ones
  else
    echo "[INFO] Directory contains $file_count items. Not listing to avoid clutter."
  fi
}

fetch-all-branches(){
    for d in */ ; do
        cd "$d"
        git branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
        git fetch --all
        git pull --all
        cd ..
    done
}

function count(){
    ls -l $1 | egrep -c '^-'
}

# Conda Initialization (Portable)
if [ -d "$HOME/miniconda3" ]; then
  __conda_setup="$('$HOME/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
    eval "$__conda_setup"
  else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="$HOME/miniconda3/bin:$PATH"
    fi
  fi
  unset __conda_setup
fi

# Google Cloud SDK Initialization (Portable)
if [ -d "$HOME/google-cloud-sdk" ]; then
  [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
  [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

clear
