# ============================================
# nvm (Node Version Manager) 配置
# ============================================

export NVM_DIR="$HOME/.nvm"

# nvm.sh 体积较大，延迟到第一次使用 Node.js 工具时再加载。
typeset -g _NVM_LAZY_LOADED=0

_nvm_load() {
  (( _NVM_LAZY_LOADED )) && return 0

  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    print -u2 "nvm: $NVM_DIR/nvm.sh not found"
    return 127
  fi

  # 先移除占位函数，让 nvm.sh 可以定义真正的 nvm，
  # 其余命令则在 nvm 把默认 Node 加入 PATH 后直接执行。
  unfunction nvm node npm npx corepack claude codex qrcode-terminal 2>/dev/null
  \. "$NVM_DIR/nvm.sh" || return
  [[ -s "$NVM_DIR/bash_completion" ]] && \. "$NVM_DIR/bash_completion"

  typeset -g _NVM_LAZY_LOADED=1
}

nvm()             { _nvm_load || return; nvm "$@"; }
node()            { _nvm_load || return; command node "$@"; }
npm()             { _nvm_load || return; command npm "$@"; }
npx()             { _nvm_load || return; command npx "$@"; }
corepack()        { _nvm_load || return; command corepack "$@"; }
claude()          { _nvm_load || return; command claude "$@"; }
codex()           { _nvm_load || return; command codex "$@"; }
qrcode-terminal() { _nvm_load || return; command qrcode-terminal "$@"; }
