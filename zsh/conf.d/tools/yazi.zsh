y() {
  local tmp
  tmp="$(mktemp -t yazi-cwd.XXXXXX)"

  yazi --cwd-file="$tmp"

  if [[ -f "$tmp" ]]; then
    local cwd
    cwd="$(<"$tmp")"
    rm -f "$tmp"

    if [[ -d "$cwd" ]]; then
      cd "$cwd"
    fi
  fi
}

