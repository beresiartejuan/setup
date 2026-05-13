rm() {
    for arg in "$@"; do
        [[ "$arg" == "/" ]] && echo "Bloqueado: rm en /" && return 1
    done
    command rm "$@"
}