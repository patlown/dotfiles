# Optional helpers that depend on network access.

weather() {
    curl "wttr.in/${1:-}"
}

cheat() {
    curl "cheat.sh/$1"
}
