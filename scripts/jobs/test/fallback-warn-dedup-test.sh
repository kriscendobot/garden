#!/bin/bash
# fallback-warn-dedup-test.sh — journal_remote's cached-remote fallback and
# leader_host's leader-cache fallback warn ONCE per episode (fallback_warn), not
# once per tick; a direct read closes the episode; a persistent episode escalates
# exactly once after GARDEN_FALLBACK_ESCALATE_AFTER. Hermetic: throwaway state and
# a plain (non-git) stand-in for $GARDEN_ROOT; no network.
set -uo pipefail
JOBS="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TR="$(mktemp -d /var/tmp/garden-fallback-warn.XXXXXX)"
trap 'rm -rf "$TR"' EXIT
export GARDEN_TEST=1 GARDEN_ROOT="$TR/root" GARDEN_STATE="$TR/state" JOURNAL_REMOTE=''
export GARDEN_JOURNAL_ORIGIN_READ_SLEEP=0
mkdir -p "$GARDEN_ROOT/journal" "$GARDEN_STATE"
# shellcheck source=../common.sh
. "$JOBS/common.sh"
set +e

pass=0 failn=0
ok()  { echo "  PASS: $*"; pass=$((pass+1)); }
bad() { echo "  FAIL: $*"; failn=$((failn+1)); }
count() { grep -c -- "$1" "$2" 2>/dev/null || true; }

echo "journal_remote cache fallback: one WARN across repeated ticks"
UP="$TR/upstream.git"
mkdir -p "$(dirname "$JOURNAL_REMOTE_CACHE")"
printf '%s\n' "$UP" > "$JOURNAL_REMOTE_CACHE"
: > "$TR/err"
for _ in 1 2 3 4 5 6 7; do
  out="$( journal_remote 2>>"$TR/err" )"
  [ "$out" = "$UP" ] || bad "tick returned '$out', expected cached $UP"
done
[ "$(count 'using cached journal remote' "$TR/err")" = 1 ] \
  && ok "seven cache fallbacks logged one WARN" \
  || bad "expected 1 cache WARN, got $(count 'using cached journal remote' "$TR/err"): $(cat "$TR/err")"
[ "$(stat -c %s "$GARDEN_FALLBACK_WARN_DIR/journal-remote-cache/count" 2>/dev/null)" = 6 ] \
  && ok "six suppressed repeats counted" || bad "suppressed count wrong"
grep -q 'ERROR' "$TR/err" && bad "escalated before the bound" || ok "no escalation inside the bound"

echo "persistent episode escalates once"
echo 1 > "$GARDEN_FALLBACK_WARN_DIR/journal-remote-cache/first"
: > "$TR/err"
for _ in 1 2 3; do journal_remote >/dev/null 2>>"$TR/err"; done
[ "$(count '^.*ERROR: .*fallback persistent' "$TR/err")" = 1 ] \
  && ok "one ERROR escalation after the bound" || bad "escalation count wrong: $(cat "$TR/err")"
grep -q 'WARN' "$TR/err" && bad "WARN re-emitted during the episode" || ok "no repeat WARN"

echo "direct origin read closes the episode"
git init -q "$TR/direct"
git -C "$TR/direct" remote add origin "$UP"
rm -rf "$GARDEN_ROOT/journal"; ln -s "$TR/direct" "$GARDEN_ROOT/journal"
: > "$TR/err"
out="$( journal_remote 2>>"$TR/err" )"
[ "$out" = "$UP" ] || bad "direct read returned '$out'"
[ "$(count 'recovered: journal-remote-cache fallback episode closed' "$TR/err")" = 1 ] \
  && ok "recovery logged once" || bad "no recovery line: $(cat "$TR/err")"
[ -e "$GARDEN_FALLBACK_WARN_DIR/journal-remote-cache" ] && bad "marker survived recovery" || ok "marker cleared"
journal_remote >/dev/null 2>"$TR/err"
[ -s "$TR/err" ] && bad "healthy read logged: $(cat "$TR/err")" || ok "healthy read is silent"

echo "next outage opens a fresh episode"
rm -f "$GARDEN_ROOT/journal"; mkdir -p "$GARDEN_ROOT/journal"
: > "$TR/err"
journal_remote >/dev/null 2>>"$TR/err"; journal_remote >/dev/null 2>>"$TR/err"
[ "$(count 'using cached journal remote' "$TR/err")" = 1 ] && ok "fresh episode warns once" || bad "fresh episode: $(cat "$TR/err")"

echo "a momentarily-empty worktree origin read is retried, not warned"
# Stand-in for the config-lock / worktree-repair window: the first read is
# empty, the second sees the origin. No fallback, no WARN, cache untouched.
real_once="$(declare -f _journal_worktree_origin_once)"
: > "$TR/reads"
_journal_worktree_origin_once() {
  printf '.' >> "$TR/reads"
  [ "$(stat -c %s "$TR/reads")" -ge 2 ] && printf '%s\n' "$UP"
}
: > "$TR/err"
out="$( journal_remote 2>>"$TR/err" )"
[ "$out" = "$UP" ] && ok "retry returned the worktree origin" || bad "retry returned '$out'"
[ "$(stat -c %s "$TR/reads")" = 2 ] && ok "second attempt succeeded" || bad "reads: $(stat -c %s "$TR/reads")"
grep -q 'yielded no origin' "$TR/err" && bad "WARN despite a successful retry: $(cat "$TR/err")" || ok "no WARN when a retry succeeds"
[ -e "$GARDEN_FALLBACK_WARN_DIR/journal-remote-cache" ] && bad "retry opened a fallback episode" || ok "no fallback episode opened"

echo "every attempt empty: bounded reads, then the cache fallback warns"
: > "$TR/reads"
_journal_worktree_origin_once() { printf '.' >> "$TR/reads"; return 1; }
: > "$TR/err"
out="$( journal_remote 2>>"$TR/err" )"
[ "$out" = "$UP" ] && ok "fell back to the cache" || bad "fallback returned '$out'"
[ "$(stat -c %s "$TR/reads")" = 3 ] && ok "three attempts by default" || bad "reads: $(stat -c %s "$TR/reads")"
[ "$(count 'using cached journal remote' "$TR/err")" = 1 ] && ok "WARN only after retries fail" || bad "cache WARN: $(cat "$TR/err")"
: > "$TR/reads"
GARDEN_JOURNAL_ORIGIN_READ_ATTEMPTS=2 journal_remote >/dev/null 2>&1
[ "$(stat -c %s "$TR/reads")" = 2 ] && ok "attempt count is configurable" || bad "reads: $(stat -c %s "$TR/reads")"
eval "$real_once"
fallback_warn_clear journal-remote-cache 2>/dev/null

echo "leader fetch fallback: one WARN, cleared by a successful fetch"
: > "$TR/err"
for _ in 1 2 3; do fallback_warn leader-fetch "leader fetch failed; using last-known leader cache (not fresh)" 2>>"$TR/err"; done
[ "$(count 'leader fetch failed' "$TR/err")" = 1 ] && ok "three leader fallbacks logged one WARN" || bad "leader WARN count: $(cat "$TR/err")"
fallback_warn_clear leader-fetch 2>>"$TR/err"
[ "$(count 'recovered: leader-fetch' "$TR/err")" = 1 ] && ok "leader episode closed" || bad "leader recovery missing"
fallback_warn_clear leader-fetch 2>"$TR/err2"
[ -s "$TR/err2" ] && bad "clear with no episode logged" || ok "clear with no open episode is silent"
grep -q 'fallback_warn_clear leader-fetch' "$JOBS/common.sh" && grep -q 'fallback_warn leader-fetch' "$JOBS/common.sh" \
  && ok "leader_host routes through fallback_warn / fallback_warn_clear" || bad "leader_host not wired"

echo "a leftover marker older than the bound does not swallow a new episode"
mkdir -p "$GARDEN_FALLBACK_WARN_DIR/stale-src"; echo 1 > "$GARDEN_FALLBACK_WARN_DIR/stale-src/first"
printf '...' > "$GARDEN_FALLBACK_WARN_DIR/stale-src/count"
touch -d @1 "$GARDEN_FALLBACK_WARN_DIR/stale-src/first" "$GARDEN_FALLBACK_WARN_DIR/stale-src/count"
fallback_warn stale-src "stale probe" 2>"$TR/err"
grep -q 'WARN: stale probe' "$TR/err" && ! grep -q ERROR "$TR/err" \
  && ok "stale marker reopened as a fresh episode (WARN, no ERROR)" || bad "stale marker: $(cat "$TR/err")"

echo "----------------------------------------------------------------"
echo "fallback-warn-dedup-test: $pass passed, $failn failed"
[ "$failn" = 0 ]
