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

  if [ "$file_count" -lt 10 ]; then
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
    find $1 -type f | wc -l
}

gpu-kill() {
    pids=$(nvidia-smi --query-compute-apps=pid --format=csv,noheader,nounits)
    if [[ -z "$pids" ]]; then
        echo "No GPU processes found."
        return 0
    fi
    echo "Killing GPU processes: $pids"
    echo "$pids" | xargs -I {} sudo kill -9 {}
    echo "All GPU compute processes have been terminated."
}

git-multi() {
    local cmd=${1:-"pull --all"} # Default command is `git pull --all` if none is given
    find . -maxdepth 1 -type d | while read repo; do
        if [ -d "$repo/.git" ]; then
            echo "✅ Found Git repo: $repo"
        else
            continue
        fi
        (
            cd "$repo" || exit
            # Track all remote branches
            git branch -r | grep -v '\->' | while read remote; do 
                local_branch="${remote#origin/}"
                if ! git show-ref --verify --quiet "refs/heads/$local_branch"; then
                    echo "🌿 Tracking remote branch: $local_branch"
                    git branch --track "$local_branch" "$remote" 2>/dev/null
                fi
            done
            # Fetch and run the command
            echo "🚀 Running 'git fetch --all'"
            git fetch --all --prune
            echo "🔄 Running 'git $cmd'"
            git $cmd
        ) &
    done
    wait
}

traverse() {
  local dir="$1"
  local prefix="${2:-}"
  local is_root="${3:-1}"

  # Print root directory name
  if [ "$is_root" -eq 1 ]; then
    echo "$(basename "$PWD")"
  fi

  local entries=()
  local count=0
  while IFS= read -r entry; do
    entries+=("$entry")
    ((count++))
    ((count >= 6)) && break  # fetch at most 6 to check for overflow
  done < <(ls -1A "$dir" 2>/dev/null | sort)

  local total=${#entries[@]}
  local show_ellipsis=0
  (( total == 6 )) && show_ellipsis=1
  (( show_ellipsis )) && unset 'entries[5]'  # keep only first 5

  for i in "${!entries[@]}"; do
    local name="${entries[i]}"
    local path="$dir/$name"
    local is_last=$(( i == ${#entries[@]} - 1 && show_ellipsis == 0 ))
    local connector=$([[ "$is_last" -eq 1 ]] && echo "└── " || echo "├── ")
    echo "${prefix}${connector}${name}"
    if [ -d "$path" ]; then
      local new_prefix="$prefix"
      new_prefix+=$([[ "$is_last" -eq 1 ]] && echo "    " || echo "│   ")
      traverse "$path" "$new_prefix" 0
    fi
  done

  # Show ellipsis if we had to truncate
  if (( show_ellipsis )); then
    echo "${prefix}└── ..."
  fi
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
