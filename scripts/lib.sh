# Shared helpers, sourced by every step. POSIX sh.
CLAUDE_DIR=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
CODEX_DIR=${CODEX_HOME:-$HOME/.codex}
say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
win() { case $(uname -s) in MINGW*|MSYS*|CYGWIN*) return 0 ;; *) return 1 ;; esac; }
backup() { [ -f "$1" ] || return 0; mkdir -p "$BACKUP_DIR"; cp "$1" "$BACKUP_DIR/$(printf '%s' "$1" | tr -c '[:alnum:]._' '_')"; }
cli() { have "$1" && return 0; say "$1 CLI not on PATH: skipped for $1"; return 1; }
npm_g() {  # npm i -g without sudo; fails with the fix when the global folder is not writable
  have npm || { say "npm not on PATH"; return 1; }
  r=$(npm root -g | tr -d '\r'); [ -n "$r" ] || { say "npm root -g failed"; return 1; }
  d=$r; win && d=$(cygpath -u "$d")
  while [ ! -e "$d" ]; do d=$(dirname -- "$d"); done
  [ -w "$d" ] || { say "npm global folder not writable: $r"; say "Fix: npm config set prefix ~/.local, put ~/.local/bin on PATH, rerun. https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally"; return 1; }
  npm i -g "$@"
}
