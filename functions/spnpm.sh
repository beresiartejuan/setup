spnpm() {
    systemd-run --user -t \
        --property=ProtectSystem=strict \
        --property=ProtectHome=yes \
        --property=PrivateTmp=yes \
        --property=NoNewPrivileges=true \
        --working-directory="$PWD" \
        -- pnpm "$@"
}