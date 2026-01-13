# ============================================
# widget 配置
# ============================================

# ============================================
# fzf 路径插入 widget
# ============================================

# 在当前命令行光标位置插入 fzf 搜索到的路径
fzf_path_insert() {
  # 用 fzf 搜索目录或文件
  local selected
  
  # 定义忽略列表
  local ignore_dirs=(
    "node_modules"
    ".git"
    ".next"
    ".nuxt"
    "dist"
    "build"
    "target"
    "vendor"
    ".venv"
    "venv"
    "__pycache__"
    ".cache"
    ".DS_Store"
    "coverage"
    ".idea"
    ".vscode"
    "tmp"
    "temp"
  )
  
  # 构建 find 的排除参数
  local find_args=()
  for dir in "${ignore_dirs[@]}"; do
    find_args+=(-name "$dir" -prune -o)
  done
  
  # 搜索目录和文件，排除忽略列表中的目录
  selected=$(find . "${find_args[@]}" \( -type d -o -type f \) -print 2>/dev/null | fzf -i)
  
  # 如果选择了结果
  if [[ -n "$selected" ]]; then
    # 拼接到当前命令行光标位置
    LBUFFER+="$selected"
  fi
  # 刷新命令行提示
  zle reset-prompt
}

# 注册 widget
zle -N fzf_path_insert

# 绑定快捷键，比如 Ctrl+T
bindkey '^T' fzf_path_insert


# ============================================
# 在 nvim 中编辑命令行
# ============================================

# 加载 edit-command-line 模块
autoload -U edit-command-line

# 创建自定义 widget 使用 nvim 编辑
edit-command-line-nvim() {
  # 临时设置 EDITOR 为 nvim（如果还没设置）
  local old_editor="$EDITOR"
  export EDITOR='nvim'
  
  # 调用内置的 edit-command-line
  zle edit-command-line
  
  # 恢复原来的 EDITOR（如果有的话）
  if [[ -n "$old_editor" ]]; then
    export EDITOR="$old_editor"
  fi
}

# 注册 widget
zle -N edit-command-line
zle -N edit-command-line-nvim

# 绑定快捷键 Ctrl+X Ctrl+E（经典组合）
bindkey '^X^E' edit-command-line-nvim

# ============================================
# 快速启动 yazi 文件管理器
# ============================================

# 调用已有的 y() 函数启动 yazi
yazi_widget() {
  yazi
  zle reset-prompt
}

# 注册 widget
zle -N yazi_widget

# 绑定快捷键 Ctrl+Y
bindkey '^Y' yazi_widget

