#!/usr/bin/env bash
# ============================================
# zsh 配置一键安装脚本
# ============================================
# 新设备上：先把本仓库 clone 到 ~/.config，再运行本脚本
#   git clone <your-repo> ~/.config && ~/.config/zsh/install.sh
#
# 可重复运行（幂等）：已安装的部分会自动跳过
# 以 macOS + Homebrew 为主，Homebrew 在 Linux 上同样可用
# 单个工具装失败只告警、不中断，最后会汇总
# ============================================

set -o pipefail

# 脚本所在目录（= 仓库里的 zsh 目录），用绝对路径，避免依赖当前工作目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OH_MY_ZSH_PATH="$HOME/.oh-my-zsh"
OH_MY_TMUX_PATH="$HOME/.config/oh-my-tmux"
ZSH_CUSTOM_PATH="${ZSH_CUSTOM:-$OH_MY_ZSH_PATH/custom}"
NVM_VERSION="v0.40.1"   # 需要时可升级到更新的 tag

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m  %s\n' "$*"; }
ok()   { printf '\033[1;32m[ok]\033[0m %s\n' "$*"; }

OS="$(uname -s)"

# .zshrc 里把配置目录写死成 ~/.config/zsh，仓库不在这里就会找不到模块
if [[ "$SCRIPT_DIR" != "$HOME/.config/zsh" ]]; then
  warn "This setup expects the repo at ~/.config/zsh (.zshrc hardcodes that path); found it at $SCRIPT_DIR"
  warn "Move the repo under ~/.config and re-run, otherwise conf.d/* won't be sourced at startup"
fi

# --- 0. Ubuntu/Debian 系统级依赖 ----------------------------------------
# Oh My Tmux 的系统剪贴板集成需要 xclip（Wayland 使用 wl-clipboard）。
ensure_apt_dependencies() {
  [[ "$OS" == "Linux" ]] || return 0
  command -v apt-get >/dev/null 2>&1 || return 0

  local packages=(
    ca-certificates
    curl
    git
    tmux
    unzip
    wl-clipboard
    xclip
    zsh
  )
  local missing=()
  local pkg

  for pkg in "${packages[@]}"; do
    if ! dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "ok installed"; then
      missing+=("$pkg")
    fi
  done

  if (( ${#missing[@]} == 0 )); then
    ok "Ubuntu/Debian system dependencies already installed"
    return 0
  fi

  info "Installing Ubuntu/Debian system dependencies: ${missing[*]}"
  sudo apt-get update \
    && sudo apt-get install -y "${missing[@]}" \
    || warn "APT dependency installation failed; install manually: ${missing[*]}"
}

ensure_apt_dependencies

# --- 1. Homebrew ----------------------------------------------------------
ensure_brew() {
  if command -v brew >/dev/null 2>&1; then return 0; fi
  if [[ "$OS" == "Darwin" ]]; then
    info "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || return 1
    # 把 brew 加入当前进程 PATH（Apple Silicon / Intel 路径不同）
    if   [[ -x /opt/homebrew/bin/brew ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew   ]]; then eval "$(/usr/local/bin/brew shellenv)"; fi
    command -v brew >/dev/null 2>&1
  else
    warn "Homebrew not found and not macOS. Install these via your system package manager:"
    warn "  zsh git fzf neovim lazygit fd yazi"
    return 1
  fi
}

brew_install() {
  local pkg="$1"
  if brew list "$pkg" >/dev/null 2>&1; then ok "$pkg already installed"; return; fi
  info "Installing $pkg ..."
  brew install "$pkg" || warn "$pkg install failed, skipping"
}

# --- 2. CLI 工具（配置里实际用到的）-------------------------------------
#   zsh      默认 shell        fzf      Ctrl+R / Ctrl+T / f 别名
#   neovim   EDITOR、vi 别名   lazygit  lg 别名
#   fd       functions/widgets yazi     y 函数、文件管理
if ensure_brew; then
  for pkg in zsh git fzf neovim lazygit fd yazi; do
    brew_install "$pkg"
  done
fi

# --- 3. nvm（装到 ~/.nvm，对应 tools/nvm.zsh）---------------------------
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  ok "nvm already installed"
else
  info "Installing nvm ($NVM_VERSION) ..."
  curl -fsSL "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash \
    || warn "nvm install failed, skipping"
fi

# --- 4. oh-my-zsh + 插件 + 主题 -----------------------------------------
if [[ -d "$OH_MY_ZSH_PATH" ]]; then
  ok "oh-my-zsh already present"
else
  info "Cloning oh-my-zsh ..."
  git clone https://github.com/ohmyzsh/ohmyzsh.git "$OH_MY_ZSH_PATH" || warn "oh-my-zsh clone failed"
fi

clone_if_absent() { # $1=目标目录  $2=仓库地址
  if [[ -d "$1" ]]; then ok "$(basename "$1") already present"; return; fi
  info "Cloning $(basename "$1") ..."
  git clone --depth=1 "$2" "$1" || warn "$(basename "$1") clone failed"
}

clone_if_absent "$ZSH_CUSTOM_PATH/plugins/zsh-autosuggestions"     "https://github.com/zsh-users/zsh-autosuggestions"
clone_if_absent "$ZSH_CUSTOM_PATH/plugins/zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
clone_if_absent "$ZSH_CUSTOM_PATH/themes/powerlevel10k"           "https://gitee.com/romkatv/powerlevel10k.git"

# --- 5. Oh My Tmux（tmux/tmux.conf 的软链目标）--------------------------
clone_if_absent "$OH_MY_TMUX_PATH" "https://github.com/gpakosz/.tmux.git"

# --- 6. 让 ~/.zshrc 指向本仓库入口（软链，改仓库即生效）-----------------
if [[ -e "$HOME/.zshrc" && ! -L "$HOME/.zshrc" ]]; then
  info "Backing up existing ~/.zshrc -> ~/.zshrc.orig"
  cp "$HOME/.zshrc" "$HOME/.zshrc.orig"
fi
ln -sf "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
ok "linked ~/.zshrc -> $SCRIPT_DIR/.zshrc"
# p10k 配置在 conf.d/p10k.zsh，由 .zshrc 直接 source，无需另外拷贝

# --- 7. 可选：qrcode-terminal（qr 别名用），需要 node -------------------
if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  \. "$HOME/.nvm/nvm.sh"
  if ! command -v node >/dev/null 2>&1; then
    info "Installing Node LTS via nvm ..."
    nvm install --lts || warn "node install failed, skipping qrcode-terminal"
  fi
  if command -v npm >/dev/null 2>&1 && ! command -v qrcode-terminal >/dev/null 2>&1; then
    info "Installing qrcode-terminal (for the 'qr' alias) ..."
    npm install -g qrcode-terminal || warn "qrcode-terminal install failed"
  fi
fi

# --- 8. 把默认 shell 切到 zsh -------------------------------------------
TARGET_ZSH="$(command -v zsh || true)"
if [[ -n "$TARGET_ZSH" && "${SHELL:-}" != "$TARGET_ZSH" ]]; then
  if ! grep -qxF "$TARGET_ZSH" /etc/shells 2>/dev/null; then
    info "Adding $TARGET_ZSH to /etc/shells (needs sudo)"
    echo "$TARGET_ZSH" | sudo tee -a /etc/shells >/dev/null || warn "failed to write /etc/shells"
  fi
  info "Changing default shell to zsh ..."
  chsh -s "$TARGET_ZSH" || warn "chsh failed; run manually later: chsh -s $TARGET_ZSH"
fi

echo
ok "Done! Open a new terminal or run 'exec zsh' to apply."
