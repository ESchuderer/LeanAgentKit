# Shared helpers, sourced by every step. POSIX sh.
CLAUDE_DIR=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
CODEX_DIR=${CODEX_HOME:-$HOME/.codex}
say() { printf '%s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
win() { case $(uname -s) in MINGW*|MSYS*|CYGWIN*) return 0 ;; *) return 1 ;; esac; }
backup() { [ -f "$1" ] || return 0; mkdir -p "$BACKUP_DIR"; cp "$1" "$BACKUP_DIR/$(printf '%s' "$1" | tr -c '[:alnum:]._' '_')"; }
cli() { have "$1" && return 0; say "$1 CLI not on PATH: skipped for $1"; return 1; }
writable() { _w=$1; while [ ! -e "$_w" ]; do _w=$(dirname -- "$_w"); done; [ -w "$_w" ]; }  # nearest existing ancestor
npm_g() {  # npm i -g without sudo. Folders: https://docs.npmjs.com/cli/v10/configuring-npm/folders
  have npm || { say "npm not on PATH"; return 1; }
  _npm_prefix=$(npm prefix -g | tr -d '\r'); [ -n "$_npm_prefix" ] || { say "npm prefix -g failed"; return 1; }
  if win; then _npm_prefix=$(cygpath -u "$_npm_prefix") && [ -n "$_npm_prefix" ] || return 1; _npm_bin=$_npm_prefix; _npm_lib=$_npm_prefix/node_modules
  else _npm_bin=$_npm_prefix/bin; _npm_lib=$_npm_prefix/lib/node_modules; fi
  if ! writable "$_npm_lib" || ! writable "$_npm_bin"; then
    say "npm global folders not writable: $_npm_prefix"
    say "Fix: npm config set prefix ~/.local, put its bin folder on PATH (~/.local/bin; Windows: ~/.local), rerun. https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally"
    return 1
  fi
  npm i -g "$@" || return 1
  case ":$PATH:" in *":$_npm_bin:"*) ;; *) PATH="$_npm_bin:$PATH"; export PATH; say "npm bin folder not on PATH, add it: $_npm_bin" ;; esac
}
