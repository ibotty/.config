rg() {
    if [ -t 1 ]; then
        command rg -p "$@" | less -RFX
    else
        command rg "$@"
    fi
}

export RIPGREP_CONFIG_PATH="$HOME/.config/rg.conf"
