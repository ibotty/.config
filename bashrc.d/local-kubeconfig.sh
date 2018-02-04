_LOCAL_KUBECONFIG_LAST_WD=

_set_local_kubeconfig() {
    # don't run when KUBECONFIG has been set externally
    if [[ -v "$KUBECONFIG" ]] && ! [[ -v "_LOCAL_KUBECONFIG_SET" ]]; then
        return
    fi

    # don't process last dir again
    if [[ "$_LOCAL_KUBECONFIG_LAST_WD" == "$PWD" ]]; then
        return
    fi

    # if not within a local kubeconfig dir unset KUBECONFIG
    if ! [[ "$PWD" == "${_LOCAL_KUBECONFIG_LAST_WD}"* ]]; then
        echo "unsetting KUBECONFIG"
        unset _LOCAL_KUBECONFIG_SET
        unset KUBECONFIG
    fi

    if [[ -f .kubeconfig ]]; then
        echo "setting kubeconfig to $PWD/.kubeconfig"
        _LOCAL_KUBECONFIG_SET=
        export KUBECONFIG=$PWD/.kubeconfig
    fi

    _LOCAL_KUBECONFIG_LAST_WD="$PWD"
}

_local_kubeconfig_hook() {
    local rc="$?"
    _set_local_kubeconfig
    return "$rc"
}

if ! [[ "$PROMPT_COMMAND" =~ _local_kubeconfig_hook ]]; then
    PROMPT_COMMAND="local_kubeconfig_hook;$PROMPT_COMMAND";
fi
