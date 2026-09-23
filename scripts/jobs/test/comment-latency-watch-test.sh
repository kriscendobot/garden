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

echo 'PASS: comment latency watch scenarios'
