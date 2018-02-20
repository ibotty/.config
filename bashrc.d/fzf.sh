[ -f /usr/share/fzf/shell/key-bindings.bash ] && \
    source /usr/share/fzf/shell/key-bindings.bash

if hash fzf 2> /dev/null; then

    alias fzf=fzf-tmux
    export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow -g "!{.git,node_modules,vendor}/*" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="rg --hidden --files -g '!{.git,node_modules,vendor}/*' --null 2> /dev/null | xargs -0 dirname | awk '!h[\$0]++'"
    bind -x '"\C-p": nvim $(fzf);'
fi
