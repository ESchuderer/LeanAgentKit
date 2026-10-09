# Shared helpers, sourced by every step. POSIX sh.
CLAUDE_DIR=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
CODEX_DIR=${CODEX_HOME:-$HOME/.codex}
. "$ROOT/scripts/versions.sh"
say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
win() { case $(uname -s) in MINGW*|MSYS*|CYGWIN*) return 0 ;; *) return 1 ;; esac; }
backup() { [ -f "$1" ] || return 0; mkdir -p "$BACKUP_DIR"; cp "$1" "$BACKUP_DIR/$(printf '%s' "$1" | tr -c '[:alnum:]._' '_')"; }
cli() { have "$1" && return 0; say "$1 CLI not on PATH: skipped for $1"; return 1; }
npm_g() {  # npm i -g without sudo; install.sh puts npm's bin folder on PATH
  have npm || { say "npm not on PATH"; return 1; }
  npm i -g "$@" || { say "npm i -g $* failed. On EACCES: npm config set prefix ~/.local, put its bin folder on PATH (~/.local/bin; Windows: ~/.local), rerun. https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally"; return 1; }
}
