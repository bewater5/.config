# ============================================
# fzf 模糊查找器配置
# ============================================

# 加载 fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# fzf 主题和选项配置
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border
  --prompt='❯ '
  --pointer='➤'
  --marker='✔'
  --color=bg:-1,hl:#357bf0,fg+:#ffffff,hl+:#357bf0,prompt:#357bf0,spinner:#357bf0,pointer:#357bf0
"

