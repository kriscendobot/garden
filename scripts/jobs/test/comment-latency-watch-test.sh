#!/bin/bash
# comment-latency-watch-test.sh — deterministic reactji-latency scenarios.
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d)"; trap 'rm -rf "$TR"' EXIT
STATE="$TR/state"; mkdir -p "$STATE/comment-watcher/heartbeat"
NOW_ISO=2026-09-23T18:00:00Z
NOW="$(date -u -d "$NOW_ISO" +%s)"
FIXTURE="$TR/source.tsv"; REACTIONS="$TR/reactions.tsv"; NOTICES="$TR/notices.log"
TRUSTED="$TR/trusted"; printf 'trusted\n' > "$TRUSTED"

SOURCE="$TR/source.sh"
cat > "$SOURCE" <<'EOF'
#!/bin/bash
cat "$CLW_FIXTURE"
EOF
REACTION_STUB="$TR/reactions.sh"
cat > "$REACTION_STUB" <<'EOF'
#!/bin/bash
awk -F '\t' -v id="$3" '$1 == id { print $2; exit }' "$CLW_REACTIONS"
EOF
NOTICE_STUB="$TR/notice.sh"
cat > "$NOTICE_STUB" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$CLW_NOTICES"
EOF
chmod +x "$SOURCE" "$REACTION_STUB" "$NOTICE_STUB"

heartbeat() {
  local slug="$1"
  cat > "$STATE/comment-watcher/heartbeat/$slug" <<EOF
last_tick_at: $NOW_ISO
outcome: full-poll
outcome_since: $NOW_ISO
EOF
}
row() { # created id author url body
  printf '%s\tcomment\t90\texample/repo\texample-repo\tissue-comment\t%s\t7\t%s\t%s\t%s\n' "$@"
}
run_report() {
  env GARDEN_STATE="$STATE" GARDEN_COMMENT_LATENCY_STATE="$STATE/latency" \
    GARDEN_COMMENT_LATENCY_NOW_EPOCH="$NOW" GARDEN_COMMENT_LATENCY_SOURCE="$SOURCE" \
    GARDEN_COMMENT_LATENCY_REACTIONS="$REACTION_STUB" \
    GARDEN_COMMENT_LATENCY_ASSUME_OPEN=1 \
    GARDEN_COMMENT_LATENCY_TRUSTED_FILE="$TRUSTED" \
    CLW_FIXTURE="$FIXTURE" CLW_REACTIONS="$REACTIONS" \
    "$JOBS/comment-latency-watch.sh" --report-only
}
run_watch() {
  env GARDEN_STATE="$STATE" GARDEN_COMMENT_LATENCY_STATE="$STATE/latency" \
    GARDEN_COMMENT_LATENCY_NOW_EPOCH="$NOW" GARDEN_COMMENT_LATENCY_SOURCE="$SOURCE" \
    GARDEN_COMMENT_LATENCY_REACTIONS="$REACTION_STUB" \
    GARDEN_COMMENT_LATENCY_ASSUME_OPEN=1 \
    GARDEN_COMMENT_LATENCY_NOTICE="$NOTICE_STUB" \
    GARDEN_COMMENT_LATENCY_TRUSTED_FILE="$TRUSTED" \
    GARDEN_COMMENT_LATENCY_ARMED="${ARMED:-}" \
    CLW_FIXTURE="$FIXTURE" CLW_REACTIONS="$REACTIONS" CLW_NOTICES="$NOTICES" \
    "$JOBS/comment-latency-watch.sh" >/dev/null
}

heartbeat example-repo
: > "$REACTIONS"
{
  row 2026-09-23T17:55:00Z 101 trusted https://example/101 '@kriscendobot please build this'
  row 2026-09-23T17:50:00Z 102 trusted https://example/102 '@kriscendobot please build this'
  row 2026-09-23T17:30:00Z 103 trusted https://example/103 '@kriscendobot please build this'
  row 2026-09-23T17:30:00Z 104 kriscendobot https://example/104 '@kriscendobot please build this'
  row 2026-09-23T17:30:00Z 105 mallory https://example/105 '@kriscendobot please build this'
} > "$FIXTURE"
printf '101\t2026-09-23T17:56:40Z\n102\t2026-09-23T17:56:40Z\n' > "$REACTIONS"
out="$(run_report)"
printf '%s\n' "$out" | grep -q $'example/repo\tacked-on-time\t100' || { echo 'FAIL: acked on time'; exit 1; }
printf '%s\n' "$out" | grep -q $'example/repo\tacked-late\t400' || { echo 'FAIL: acked late'; exit 1; }
printf '%s\n' "$out" | grep -q $'example/repo\tnever-acked:blind\t-' || { echo 'FAIL: never acked'; exit 1; }
printf '%s\n' "$out" | grep -q 'example/104' && { echo 'FAIL: bot comment not ignored'; exit 1; }
printf '%s\n' "$out" | grep -q 'example/105' && { echo 'FAIL: untrusted sender not ignored'; exit 1; }

touch "$STATE/draining"
row 2026-09-23T17:30:00Z 103 trusted https://example/103 '@kriscendobot please build this' > "$FIXTURE"
out="$(run_report)"
printf '%s\n' "$out" | grep -q $'example/repo\tmuted\t-' || { echo 'FAIL: drained fleet paged as dead'; exit 1; }
rm -f "$STATE/draining"

: > "$NOTICES"; : > "$REACTIONS"; rm -rf "$STATE/latency"
run_watch
grep -q 'comment-ack-blind-example-repo' "$NOTICES" || { echo 'FAIL: blindness notice missing'; exit 1; }
printf '103\t2026-09-23T17:59:00Z\n' > "$REACTIONS"
run_watch
grep -q -- '--recovered comment-ack-blind-example-repo' "$NOTICES" || { echo 'FAIL: recovery did not close notice'; exit 1; }

# --- 2026-09-23 false-alarm flood regressions --------------------------------
classify() { "$JOBS/comment-latency-watch.sh" --classify "$@"; }
# (b) A cooldown inside the stuck bound is muted; beyond it, stuck — never "dead".
[ "$(classify 2000 - 90 cooldown 30 600 0)" = muted ] || { echo 'FAIL: short cooldown not muted'; exit 1; }
[ "$(classify 2000 - 90 cooldown 30 5000 0)" = never-acked:stuck ] || { echo 'FAIL: stuck cooldown not its own class'; exit 1; }
# (a) A negative (future) heartbeat age is fresh, never dead.
[ "$(classify 2000 - 90 full-poll -13 -13 0)" = never-acked:blind ] || { echo 'FAIL: negative heartbeat age classified as dead'; exit 1; }
[ "$(classify 2000 - 90 cooldown -13 600 0)" = muted ] || { echo 'FAIL: negative-age cooldown not muted'; exit 1; }
# A genuinely stale heartbeat is still dead, whatever its last outcome.
[ "$(classify 2000 - 90 cooldown 1000 600 0)" = never-acked:dead ] || { echo 'FAIL: stale heartbeat not dead'; exit 1; }

# The live incident: 16 armed repos, every heartbeat a few seconds in the FUTURE
# (written after the checker read its clock) and in cooldown for 2h. Expect zero
# dead notices, prior false dead notices recovered, and ONE host-level stuck notice.
: > "$FIXTURE"; : > "$REACTIONS"; : > "$NOTICES"; rm -rf "$STATE/latency"
ARMED="$TR/armed.tsv"; : > "$ARMED"
FUTURE_ISO="$(date -u -d "@$(( NOW + 13 ))" +%FT%TZ)"; SINCE_ISO="$(date -u -d "@$(( NOW - 7200 ))" +%FT%TZ)"
mkdir -p "$STATE/latency/alerts"
for i in $(seq 1 16); do
  printf 'comment\towner-r%s\towner/r%s\t90\n' "$i" "$i" >> "$ARMED"
  printf 'last_tick_at: %s\noutcome: cooldown\noutcome_since: %s\n' "$FUTURE_ISO" "$SINCE_ISO" \
    > "$STATE/comment-watcher/heartbeat/owner-r$i"
  : > "$STATE/latency/alerts/comment-watcher-dead-owner-r$i"   # the deployed false notice
done
run_watch
if grep -q '^comment-watcher-dead-' "$NOTICES"; then echo 'FAIL: cooldown/negative age paged dead'; cat "$NOTICES"; exit 1; fi
[ "$(grep -c -- '^--recovered comment-watcher-dead-' "$NOTICES")" -eq 16 ] || { echo 'FAIL: false dead notices not recovered'; cat "$NOTICES"; exit 1; }
[ "$(grep -c '^comment-watcher-stuck-cooldown-host ' "$NOTICES")" -eq 1 ] || { echo 'FAIL: stuck cooldown not ONE host-level notice'; cat "$NOTICES"; exit 1; }
if grep -q '^comment-latency-storm-' "$NOTICES"; then echo 'FAIL: stuck cooldown raised a storm'; exit 1; fi
# The latch clears: the host-level notice recovers.
for i in $(seq 1 16); do
  printf 'last_tick_at: %s\noutcome: full-poll\noutcome_since: %s\n' "$NOW_ISO" "$NOW_ISO" > "$STATE/comment-watcher/heartbeat/owner-r$i"
done
: > "$NOTICES"; run_watch
grep -q -- '^--recovered comment-watcher-stuck-cooldown-host ' "$NOTICES" || { echo 'FAIL: stuck-cooldown notice not recovered'; exit 1; }

# Storm guard: 7 truly stale heartbeats collapse into ONE summary; 3 stay individual.
STALE_ISO="$(date -u -d "@$(( NOW - 3600 ))" +%FT%TZ)"
for i in $(seq 1 7); do
  printf 'last_tick_at: %s\noutcome: full-poll\noutcome_since: %s\n' "$STALE_ISO" "$STALE_ISO" > "$STATE/comment-watcher/heartbeat/owner-r$i"
done
: > "$NOTICES"; run_watch
[ "$(grep -c '^comment-latency-storm-dead ' "$NOTICES")" -eq 1 ] || { echo 'FAIL: storm not collapsed to one summary'; cat "$NOTICES"; exit 1; }
if grep -q '^comment-watcher-dead-' "$NOTICES"; then echo 'FAIL: storming class opened individual notices'; exit 1; fi
for i in $(seq 4 7); do
  printf 'last_tick_at: %s\noutcome: full-poll\noutcome_since: %s\n' "$NOW_ISO" "$NOW_ISO" > "$STATE/comment-watcher/heartbeat/owner-r$i"
done
: > "$NOTICES"; run_watch
grep -q -- '^--recovered comment-latency-storm-dead ' "$NOTICES" || { echo 'FAIL: storm summary not recovered'; exit 1; }
[ "$(grep -c '^comment-watcher-dead-owner-r[123] ' "$NOTICES")" -eq 3 ] || { echo 'FAIL: sub-storm dead notices not individual'; cat "$NOTICES"; exit 1; }
unset ARMED

# A failing notice handler (journal/push outage) is nonfatal: the tick exits 0,
# writes its liveness heartbeat, and keeps alert state so the next tick retries.
FAIL_NOTICE="$TR/notice-fail.sh"
cat > "$FAIL_NOTICE" <<'EOF'
#!/bin/bash
printf '%s\n' "$*" >> "$CLW_NOTICES"
exit 1
EOF
chmod +x "$FAIL_NOTICE"
heartbeat example-repo
row 2026-09-23T17:30:00Z 103 trusted https://example/103 '@kriscendobot please build this' > "$FIXTURE"
: > "$REACTIONS"; : > "$NOTICES"; rm -rf "$STATE/latency"
NOTICE_STUB_SAVED="$NOTICE_STUB"; NOTICE_STUB="$FAIL_NOTICE"
run_watch 2>/dev/null || { echo 'FAIL: notice failure aborted the tick'; exit 1; }
[ -s "$STATE/latency/heartbeat" ] || { echo 'FAIL: heartbeat not written after notice failure'; exit 1; }
grep -q '^comment-ack-blind-example-repo ' "$NOTICES" || { echo 'FAIL: failing notice not attempted'; exit 1; }
[ -e "$STATE/latency/alerts/comment-ack-blind-example-repo" ] || { echo 'FAIL: alert state lost on failed open'; exit 1; }
# The condition clears but the recovery delivery fails: the marker is retained...
printf '103\t2026-09-23T17:59:00Z\n' > "$REACTIONS"; : > "$NOTICES"
run_watch 2>/dev/null || { echo 'FAIL: recovery failure aborted the tick'; exit 1; }
grep -q -- '^--recovered comment-ack-blind-example-repo ' "$NOTICES" || { echo 'FAIL: recovery not attempted'; exit 1; }
[ -e "$STATE/latency/alerts/comment-ack-blind-example-repo" ] || { echo 'FAIL: alert state dropped on failed recovery'; exit 1; }
# ...and the next tick, with delivery restored, retries and closes it.
NOTICE_STUB="$NOTICE_STUB_SAVED"; : > "$NOTICES"
run_watch
grep -q -- '^--recovered comment-ack-blind-example-repo ' "$NOTICES" || { echo 'FAIL: failed recovery not retried'; exit 1; }
[ ! -e "$STATE/latency/alerts/comment-ack-blind-example-repo" ] || { echo 'FAIL: retried recovery left marker'; exit 1; }

# An existing but empty samples/<slug>/ (the age cleanup removed the last one)
# must not feed an unmatched glob to awk and kill the tick under set -e.
: > "$REACTIONS"; : > "$NOTICES"; rm -rf "$STATE/latency"
mkdir -p "$STATE/latency/samples/example-repo"
run_watch || { echo 'FAIL: empty samples dir aborted the tick'; exit 1; }
[ -s "$STATE/latency/heartbeat" ] || { echo 'FAIL: heartbeat not written with empty samples dir'; exit 1; }
[ ! -e "$STATE/latency/stats/example-repo" ] || { echo 'FAIL: stats written from empty samples dir'; exit 1; }

echo 'PASS: comment latency watch scenarios'
