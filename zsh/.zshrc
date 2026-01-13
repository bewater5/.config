# ============================================
# Zsh 配置入口文件
# ============================================
# 
# 这是主配置文件，负责加载所有模块化配置
# 具体配置请查看 ~/.config/zsh/conf.d/ 目录
#

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# 配置文件目录
ZSHCONFIG="${ZDOTDIR:-$HOME}/.config/zsh"

source "$ZSHCONFIG/conf.d/env.zsh"
source "$ZSHCONFIG/conf.d/oh-my-zsh.zsh"
source "$ZSHCONFIG/conf.d/tools.zsh"
source "$ZSHCONFIG/conf.d/aliases.zsh"
source "$ZSHCONFIG/conf.d/functions.zsh"
source "$ZSHCONFIG/conf.d/proxy.zsh"
source "$ZSHCONFIG/conf.d/widgets.zsh"

# Powerlevel10k 配置
[[ ! -f "$ZSHCONFIG/conf.d/p10k.zsh" ]] || source "$ZSHCONFIG/conf.d/p10k.zsh"

# Local 配置
[[ ! -f "$ZSHCONFIG/local.zsh" ]] || source "$ZSHCONFIG/local.zsh"
