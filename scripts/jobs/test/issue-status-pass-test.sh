#!/bin/bash
# issue-status-pass-test.sh — the status pass's rules, gate, templates, idempotency.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT
fail() { echo "FAIL: $*"; exit 1; }
P="$JOBS/issue-status-pass.sh"
NOW_ISO=2026-11-04T04:00:00Z; NOW="$(date -u -d "$NOW_ISO" +%s)"
ago() { date -u -d "@$(( NOW - $1 ))" +%FT%TZ; }

# Rule table.
d() { "$P" --decide "$@"; }
[ "$(d 1199 todo 0 -)" = hold ] || fail 'timeout fired at 1199s'
[ "$(d 1200 todo 0 -)" = post ] || fail 'timeout did not fire at 1200s'
[ "$(d 300 todo 5 -)" = hold ] || fail 'early rule fired at ahead 5'
[ "$(d 300 todo 6 -)" = post ] || fail 'early rule did not fire at ahead 6'
[ "$(d 299 todo 9 -)" = hold ] || fail 'early rule fired before 300s'
[ "$(d 600 not-on-board 9 -)" = hold ] || fail 'early rule fired off the board'
[ "$(d 1300 doin 0 299)" = hold ] || fail 'claim grace did not hold at 299s'
[ "$(d 1300 doin 0 301)" = post ] || fail 'claim grace held at 301s'
[ "$(d 1500 doin 0 10)" = post ] || fail 'claim grace held past the 25-minute ceiling'

# Templates: board values only.
r="$("$P" --render issue-x-1 todo 3 2 - 0 1 issue)"
case "$r" in *'queued as `issue-x-1`, with 3 jobs ahead and 2 running'*'automatic status note.'*'<!-- garden-status:1:issue -->'*) ;; *) fail "todo template: $r" ;; esac
r="$("$P" --render s doin 0 1 2026-11-04T03:50:00Z 1 2 99)"
case "$r" in *'claimed this as `s` at 2026-11-04T03:50:00Z'*'paused for maintenance'*'garden-status:2:99'*) ;; *) fail "doin/paused template: $r" ;; esac
r="$("$P" --render s not-on-board 0 0 - 0 3 issue)"
case "$r" in *'not on the job board yet'*) ;; *) fail "not-on-board template: $r" ;; esac

# End to end with stubs.
BOARD="$TR/board"; mkdir -p "$BOARD/jobs/todo" "$BOARD/jobs/doin" "$BOARD/jobs/tada"
M="$TR/maint"; printf 'dckc\n' > "$M"
SRC="$TR/src.tsv"; COMMENTS="$TR/comments"; mkdir -p "$COMMENTS"; POSTS="$TR/posts.log"
cat > "$TR/source.sh" <<'S'
#!/bin/bash
cat "$IST_SRC"
S
cat > "$TR/comments.sh" <<'S'
#!/bin/bash
cat "$IST_COMMENTS/$2" 2>/dev/null || true
S
cat > "$TR/post.sh" <<'S'
#!/bin/bash
printf '%s %s\n' "$2" "$(tail -1 "$3")" >> "$IST_POSTS"
printf '%s\t%s\t%s\n' "$IST_NOW_ISO" kriscendobot "$(sed -n 's/.*garden-status:\([0-9]*:[A-Za-z0-9]*\).*/\1/p' "$3")" >> "$IST_COMMENTS/$2"
S
chmod +x "$TR"/*.sh
run() {
  env GARDEN_STATE="$TR/state" GARDEN_API_COOLDOWN_DIR="$TR/cooldown" GARDEN_ISSUE_STATUS_DRY_RUN="${DRY:-0}" \
    GARDEN_ISSUE_STATUS_REPO=kriscendobot/garden GARDEN_ISSUE_STATUS_MAINTAINERS_FILE="$M" \
    GARDEN_ISSUE_STATUS_BOARD="$BOARD" GARDEN_ISSUE_STATUS_SOURCE="${STATUS_SOURCE:-$TR/source.sh}" \
    GARDEN_ISSUE_STATUS_COMMENTS="${STATUS_COMMENTS:-$TR/comments.sh}" GARDEN_ISSUE_STATUS_POST="$TR/post.sh" \
    GARDEN_ISSUE_STATUS_TICK_BUDGET_SECS="${STATUS_TICK_BUDGET:-480}" \
    GARDEN_ISSUE_STATUS_READ_TIMEOUT_SECS="${STATUS_READ_TIMEOUT:-180}" \
    GARDEN_ISSUE_STATUS_KILL_AFTER_SECS="${STATUS_KILL_AFTER:-10}" \
    GARDEN_ISSUE_STATUS_NOW_EPOCH="$NOW" IST_SRC="$SRC" IST_COMMENTS="$COMMENTS" IST_POSTS="$POSTS" \
    IST_NOW_ISO="$NOW_ISO" "$P" 2>>"$TR/log" || { cat "$TR/log"; fail "pass exited non-zero"; }
}
row() { # kind created id number author state body
  printf '%s\t%s\t%s\t%s\t%s\tdckc\t%s\t-\t-\thttps://x\t%s\n' "$@"
}
{
  row issue "$(ago 1300)" 128 128 dckc open 'BODY-NEVER-ECHOED'
  row issue "$(ago 1300)" 129 129 mallory open 'untrusted'
  row issue-comment "$(ago 1300)" 5001 130 mallory open '@kriscendobot do it'
  row issue-comment "$(ago 1300)" 5002 131 dckc open 'not addressed to the bot'
  row issue-comment "$(ago 1290)" 5003 132 dckc open '@kriscendobot first'
  row issue-comment "$(ago 1280)" 5004 132 dckc open '@kriscendobot second'
  row issue "$(ago 1300)" 133 133 dckc closed 'closed'
} > "$SRC"
: > "$POSTS"; run
[ "$(wc -l < "$POSTS")" -eq 2 ] || { cat "$POSTS"; fail 'expected exactly two posts (#128 and one for the #132 burst)'; }
grep -q '^128 ' "$POSTS" || fail '#128 got no status'
grep -q '^132 ' "$POSTS" || fail '#132 burst got no status'
grep -q 'BODY-NEVER-ECHOED' "$POSTS" && fail 'issue text echoed'
grep -qE '^(129|130|131|133) ' "$POSTS" && fail 'gated arrival got a status'
: > "$POSTS"; run
[ ! -s "$POSTS" ] || fail 'second tick posted again'
# A later addressed comment gets its own timer.
row issue-comment "$(ago 600)" 5005 128 dckc open '@kriscendobot later' >> "$SRC"
run; [ ! -s "$POSTS" ] || fail 'later comment posted before its timeout'
row issue-comment "$(ago 1250)" 5006 134 dckc open '@kriscendobot x' > "$SRC"
printf '%s\tkriscendobot\t-\n' "$(ago 100)" > "$COMMENTS/134"
run; [ ! -s "$POSTS" ] || fail 'a bot reply did not suppress the status'
# The live comment read (gh_api_retry) ends without a trailing newline, so the
# newest comment, usually the bot reply, is an unterminated last line (#51, 2026-11-13).
printf '%s\tdckc\t-\n%s\tkriscendobot\t-' "$(ago 1250)" "$(ago 100)" > "$COMMENTS/134"
run; [ ! -s "$POSTS" ] || fail 'an unterminated last-line bot reply did not suppress the status'
row issue "$(ago 1300)" 135 135 dckc open x | tr -d '\n' > "$SRC"
run; grep -q '^135 ' "$POSTS" || fail 'an unterminated last source row was dropped'
: > "$POSTS"
# Deep queue: an early status at 5 minutes; pinned jobs do not count.
row issue "$(ago 400)" 140 140 dckc open x > "$SRC"
printf -- '---\nposted_at: %s\n---\n' "$(ago 300)" > "$BOARD/jobs/todo/issue-kriscendobot-garden-140.md"
for i in 1 2 3 4 5; do printf -- '---\nposted_at: %s\n---\n' "$(ago 5000)" > "$BOARD/jobs/todo/j$i.md"; done
printf -- '---\nposted_at: %s\n---\n' "$(ago 5000)" > "$BOARD/jobs/todo/scholar-ingest-x.md"
printf -- '---\nposted_at: %s\nrequires: host:a\n---\n' "$(ago 5000)" > "$BOARD/jobs/todo/pinned.md"
run; [ ! -s "$POSTS" ] || fail 'pinned jobs counted toward ahead'
printf -- '---\nposted_at: %s\n---\n' "$(ago 5000)" > "$BOARD/jobs/todo/j6.md"
run; grep -q '^140 .*garden-status:140:issue' "$POSTS" || fail 'deep queue did not post early'
# REST cooldown: no post; the next tick posts.
: > "$POSTS"; row issue "$(ago 1300)" 150 150 dckc open x > "$SRC"
( export GARDEN_API_COOLDOWN_DIR="$TR/cooldown"; source "$JOBS/common.sh"; start_api_cooldown test:primary 3600 rest )
run; [ ! -s "$POSTS" ] || fail 'posted under a REST cooldown'
rm -rf "$TR/cooldown"; run; grep -q '^150 ' "$POSTS" || fail 'no post after the cooldown lifted'
# Dry run posts nothing.
: > "$POSTS"; row issue "$(ago 1300)" 160 160 dckc open x > "$SRC"
DRY=1 run; [ ! -s "$POSTS" ] || fail 'dry run posted'
grep -q 'DRY RUN would post on kriscendobot/garden#160' "$TR/log" || fail 'dry run did not log'

# Every source/comment read is clipped to the shared remaining-time budget. A
# timeout exits 0 and leaves GitHub as the only state, so the next tick retries.
cat > "$TR/sleep-source.sh" <<'S'
#!/bin/bash
sleep 30
S
cat > "$TR/sleep-comments.sh" <<'S'
#!/bin/bash
sleep 30
S
cat > "$TR/recheck-comments.sh" <<'S'
#!/bin/bash
n="$(cat "$IST_RECHECK_COUNT" 2>/dev/null || echo 0)"
n=$(( n + 1 )); printf '%s\n' "$n" > "$IST_RECHECK_COUNT"
[ "$n" -eq 1 ] || sleep 30
S
chmod +x "$TR/sleep-source.sh" "$TR/sleep-comments.sh" "$TR/recheck-comments.sh"
: > "$POSTS"; row issue "$(ago 1300)" 170 170 dckc open x > "$SRC"
start="$(date +%s)"
STATUS_SOURCE="$TR/sleep-source.sh" STATUS_TICK_BUDGET=3 STATUS_READ_TIMEOUT=2 STATUS_KILL_AFTER=1 run
elapsed=$(( $(date +%s) - start ))
[ "$elapsed" -lt 6 ] || fail "source timeout exceeded the internal deadline (${elapsed}s)"
grep -q 'issue source read exceeded the remaining tick budget' "$TR/log" || fail 'source timeout did not log clean defer'
[ ! -s "$POSTS" ] || fail 'source timeout posted'

start="$(date +%s)"
STATUS_COMMENTS="$TR/sleep-comments.sh" STATUS_TICK_BUDGET=3 STATUS_READ_TIMEOUT=2 STATUS_KILL_AFTER=1 run
elapsed=$(( $(date +%s) - start ))
[ "$elapsed" -lt 6 ] || fail "comment timeout exceeded the internal deadline (${elapsed}s)"
grep -q 'comment read for #170 exceeded the remaining tick budget' "$TR/log" || fail 'comment timeout did not log clean defer'
[ ! -s "$POSTS" ] || fail 'comment timeout posted'

RECHECK_COUNT="$TR/recheck-count"; rm -f "$RECHECK_COUNT"
start="$(date +%s)"
IST_RECHECK_COUNT="$RECHECK_COUNT" STATUS_COMMENTS="$TR/recheck-comments.sh" \
  STATUS_TICK_BUDGET=3 STATUS_READ_TIMEOUT=2 STATUS_KILL_AFTER=1 run
elapsed=$(( $(date +%s) - start ))
[ "$elapsed" -lt 6 ] || fail "final re-check timeout exceeded the internal deadline (${elapsed}s)"
grep -q 'final comment re-check for #170 exceeded the remaining tick budget' "$TR/log" || fail 'final re-check timeout did not log clean defer'
[ ! -s "$POSTS" ] || fail 'final re-check timeout posted'
echo 'PASS: issue status pass'
