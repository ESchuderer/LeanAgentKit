#!/bin/sh
# Optional issue-tracking skills from skills-optional/ (issues-github, issues-jira). Order: LAK_GITHUB_ISSUES, LAK_JIRA, LAK_JIRA_SITES; else a question when stdin is a terminal; else the saved choice; else no.
set -eu
. "$ROOT/scripts/lib.sh"
export DO_NOT_TRACK=1  # skills CLI telemetry, this process only
conf=${LAK_STATE_DIR:-$HOME/.leanagentkit}/tracking.conf  # key=value lines, parsed, never sourced; the jira skill reads jira_sites
get() { sed -n "s/^$1=//p" "$conf" 2>/dev/null | tail -n 1 | tr -d '\r'; }
yn() { case $1 in [yY]|[yY][eE][sS]) echo yes ;; [nN]|[nN][oO]) echo no ;; *) say "expected yes or no: $1" >&2; return 1 ;; esac; }
saved() { v=$(get "$1"); [ -n "$v" ] || { echo no; return 0; }; yn "$v" 2>/dev/null || { say "$conf: $1=$v is not yes or no, using no" >&2; echo no; }; }
# key rule from the Data Center docs; Jira Cloud may not allow the underscore (unverified). https://confluence.atlassian.com/adminjiraserver/changing-the-project-key-format-938847081.html
sites_ok() { [ -z "$1" ] || [ "$1" = - ] || ! printf '%s\n' "$1" | tr ';' '\n' | grep -Evq '^https://[A-Za-z0-9.-]+=[A-Z][A-Z0-9_]+(,[A-Z][A-Z0-9_]+)*$'; }
ask() {  # ask <question> <default> <check>: the terminal answer, asked again while <check> rejects it; the default when stdin is no terminal or at end of input
  [ -t 0 ] && ( : </dev/tty ) 2>/dev/null || { printf '%s\n' "$2"; return 0; }
  while :; do
    printf '%s [%s]: ' "$1" "$2" >/dev/tty
    read -r a </dev/tty || { echo >/dev/tty; printf '%s\n' "$2"; return 0; }
    a=${a:-$2}
    "$3" "$a" >/dev/null 2>&1 && { printf '%s\n' "$a"; return 0; }
    printf 'not valid: %s\n' "$a" >/dev/tty
  done
}
old_gh=$(saved github_issues); old_jira=$(saved jira)
gh=$(yn "${LAK_GITHUB_ISSUES:-$(ask 'Install issues-github: GitHub issues through the gh CLI (yes/no)' "$old_gh" yn)}")
jira=$(yn "${LAK_JIRA:-$(ask 'Install issues-jira: Jira Cloud work items (yes/no)' "$old_jira" yn)}")
sites=$(get jira_sites); sites_ok "$sites" || { say "$conf: jira_sites=$sites is not valid, ignored" >&2; sites=""; }
if [ "$jira" = yes ]; then
  sites=${LAK_JIRA_SITES:-$(ask 'Jira sites and project keys, - clears (https://a.atlassian.net=KEY1,KEY2;https://b.atlassian.net=KEY3)' "$sites" sites_ok)}
  sites_ok "$sites" || { say "jira sites (LAK_JIRA_SITES or $conf): expected https://host=KEY[,KEY][;https://host=KEY...], got: $sites"; exit 1; }
  [ "$sites" != - ] || sites=""
  [ -n "$sites" ] || say "jira: no sites given; the skill asks for site and project key"
fi
[ "$jira" = yes ] || [ -z "${LAK_JIRA_SITES:-}" ] || say "LAK_JIRA_SITES ignored: jira=$jira, set LAK_JIRA=yes"

# remove only a skill chosen before and installed from this kit (skills CLI lock), so a same-name skill from another source stays; the conf is written last, so a failed run is retried
drop() { [ -e "$SKILLS_DIR/$1" ] || return 0; if kit_skill "$1"; then del="$del $1"; else say "$1: not installed from this kit, kept"; fi; }
add=""; del=""
if [ "$gh" = yes ]; then add="$add issues-github"; elif [ "$old_gh" = yes ]; then drop issues-github; fi
if [ "$jira" = yes ]; then add="$add issues-jira"; elif [ "$old_jira" = yes ]; then drop issues-jira; fi
[ -z "$del" ] || npx -y "skills@$SKILLS_CLI" remove $del -g -a claude-code -a codex -y
[ -z "$add" ] || npx -y "skills@$SKILLS_CLI" add "$ROOT/skills-optional" $(printf ' -s %s' $add) -g -a claude-code -a codex -y
# the skills CLI exits 0 when a copy or delete fails (EACCES), so check the result
for s in $add; do [ -f "$SKILLS_DIR/$s/SKILL.md" ] || { say "$s: not installed in $SKILLS_DIR"; exit 1; }; done
for s in $del; do [ ! -e "$SKILLS_DIR/$s" ] || { say "$s: still in $SKILLS_DIR"; exit 1; }; done
mkdir -p "${conf%/*}"
printf 'github_issues=%s\njira=%s\njira_sites=%s\n' "$gh" "$jira" "$sites" > "$conf"
[ "$gh" = no ] || have gh || say "gh CLI not on PATH: https://cli.github.com/"
say "tracking: github=$gh jira=$jira ($conf)"
