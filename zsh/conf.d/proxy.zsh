# ============================================
# 代理配置
# ============================================

proxyon() {
  export http_proxy="http://127.0.0.1:7890"
  export https_proxy="http://127.0.0.1:7890"
  export all_proxy="socks5://127.0.0.1:7890"

  export PROXY_ON=1
}

proxyoff() {
  unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
  unset PROXY_ON
}

pt() {
  if [[ -n "$PROXY_ON" ]]; then
    proxyoff
  else
    proxyon
  fi
}
