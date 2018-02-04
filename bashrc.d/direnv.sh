if hash direnv 1&> /dev/null; then
    eval "$(direnv hook bash)"
fi
