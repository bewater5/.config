# ============================================
# 第三方工具配置加载器
# ============================================
# 
# 此文件负责加载 tools 目录下的所有工具配置
# 每个工具都有独立的配置文件，便于管理和维护

# 获取当前脚本所在目录
TOOLS_DIR="${0:A:h}/tools"

# 加载所有工具配置（如果存在）
[[ -f "$TOOLS_DIR/fzf.zsh" ]] && source "$TOOLS_DIR/fzf.zsh"
[[ -f "$TOOLS_DIR/nvm.zsh" ]] && source "$TOOLS_DIR/nvm.zsh"
[[ -f "$TOOLS_DIR/yazi.zsh" ]] && source "$TOOLS_DIR/yazi.zsh"
