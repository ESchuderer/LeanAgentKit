# Shared helpers, sourced by every step. POSIX sh.
CLAUDE_DIR=${CLAUDE_CONFIG_DIR:-$HOME/.claude}
CODEX_DIR=${CODEX_HOME:-$HOME/.codex}
SKILLS_DIR=$HOME/.agents/skills  # skills CLI global folder
if [ -n "${XDG_STATE_HOME:-}" ]; then SKILLS_LOCK=$XDG_STATE_HOME/skills/.skill-lock.json; else SKILLS_LOCK=$HOME/.agents/.skill-lock.json; fi  # skills CLI 1.7.2 getSkillLockPath
kit_skill() {  # true when the skills CLI lock says $1 was installed from this kit's skills-optional/; both paths through node's path.resolve (Windows unverified)
  node -e 'const p = require("path"), s = require(process.argv[1]).skills[process.argv[2]]; process.exit(s && p.resolve(s.source) === p.resolve(process.argv[3]) ? 0 : 1)' "$SKILLS_LOCK" "$1" "$ROOT/skills-optional" 2>/dev/null
}
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
