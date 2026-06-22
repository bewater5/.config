# ============================================
# 别名配置
# ============================================

# Git 工具
alias lg=lazygit

# fzf
alias f=fzf

# 编辑器
alias vi=nvim

# QRCode 生成
alias qr='qrcode-terminal'

# 在 kitty 里(非 tmux/其它终端)用 kitten ssh,自动把 terminfo 拷到远端,
# tmux 里 TERM 已是 tmux-256color,无需处理;且 kitten ssh 不适合穿过多路复用器。
if [[ "$TERM" == "xterm-kitty" ]] && command -v kitten >/dev/null 2>&1; then
  alias ssh='kitten ssh'
fi
