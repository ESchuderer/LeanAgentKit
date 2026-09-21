# Shared helpers, sourced by every step. POSIX sh.
CLAUDE_DIR=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
CODEX_DIR=${CODEX_HOME:-$HOME/.codex}
say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
win() { case $(uname -s) in MINGW*|MSYS*|CYGWIN*) return 0 ;; *) return 1 ;; esac; }
backup() { [ -f "$1" ] || return 0; mkdir -p "$BACKUP_DIR"; cp "$1" "$BACKUP_DIR/$(printf '%s' "$1" | tr -c '[:alnum:]._' '_')"; }
