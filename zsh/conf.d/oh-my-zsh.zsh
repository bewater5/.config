# ============================================
# Oh-My-Zsh 配置
# ============================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  z
  extract
  sudo
  history
  zsh-syntax-highlighting
  zsh-autosuggestions
  fzf
)

source $ZSH/oh-my-zsh.sh

