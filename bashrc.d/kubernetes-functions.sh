function first_pod_of_app() {
    local rcname="${*: -1}" 
    local -a remainingargs
    remainingargs=("${@:1:$(($# - 1))}")
    local podname
    podname="$(oc get po -l app="$rcname" --no-headers "${remainingargs[@]}" \
        | cut -f1 -d' ' | head -n 1)"

    echo "${remainingargs[*]} $podname"
}

function configmap_json() {
    local namespace=""
    if [ $# -gt 2 ] && [ "$1" = "-n" ]; then
        namespace=', "namespace": "'"$2"'"'
        shift; shift
    fi
    if [ $# -ne 2 ]; then
        err "usage: $0 [-n namespace] configname configdir"
        return 1
    fi
    local configname="$1"  configdir="$2" sep=" "

    cat <<EOF 
{ "apiVersion": "v1",
  "kind": "ConfigMap",
  "metadata": {
    "name": "$configname"
    $namespace
  },
  "data": {
EOF
    find "$configdir"/* -maxdepth 0 -type f | while read -r file; do
        printf '  %s "%s": ' "$sep" "$(basename "$file")"
        jq -csrR '@json' < "$file"
        sep=","
    done
    cat <<EOF
  }
}
EOF
}

function configmap_from_dir() {
    local action="create"
    if [ "$1" = "-r" ]; then
        action="replace"
        shift
    fi
    configmap_json "$@" | oc "$action" -f -
}
