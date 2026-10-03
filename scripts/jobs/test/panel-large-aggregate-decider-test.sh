#!/bin/bash
# panel-large-aggregate-decider-test.sh — regression guard for the foreperson
# decider's prompt transport in panel.sh.
#
# THE BUG: decide_disposition passed the whole seat aggregate to `claude -p` as ONE
# argv string. Linux caps a single argument at 128 KiB (MAX_ARG_STRLEN), so a
# full code panel (~30 seats) over a large PR — endo-but-for-bots#1419 produced a
# 194 KB aggregate — failed exec with "Argument list too long" on both decider
# attempts, and the panel exited `decider-error` deterministically on every retry.
# The fix pipes the prompt on stdin.
#
# The test runs the real decide_disposition (no GARDEN_PANEL_DECIDE) against a fake
# `claude` on PATH, with two seats padded so the aggregate exceeds 128 KiB, and
# asserts the panel passes and the aggregate reached the decider via stdin.
#
# Usage: panel-large-aggregate-decider-test.sh

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-large-agg.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

mkdir -p "$TR/wt" "$TR/out"
out="$(PATH="$HERE/panel-large-aggregate-bin:$PATH" \
  LARGE_AGG_OUT="$TR/out" LARGE_AGG_SEAT_BYTES=100000 \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS="assessor typist" \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-large-aggregate-seat-stub.sh" \
  GARDEN_PANEL_APPELLATE=":" \
  GARDEN_PANEL_FIXER="true" \
  GARDEN_PANEL_UNDRAFT="true" \
  GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_DECIDE_BACKOFF=0 \
  GARDEN_PANEL_RECORD=":" \
  GARDEN_PANEL_RELATED_DESIGN=":" \
  GARDEN_PANEL_RUNDIR="$TR/rd" \
    bash "$PANEL" "$TR/wt" 777 HEAD~1 2>&1)"; rc=$?

agg_bytes="$(wc -c < "$TR/rd/round-1.md" 2>/dev/null || echo 0)"
[ "$agg_bytes" -gt 131072 ] \
  && ok "aggregate is $agg_bytes bytes, over the 128 KiB single-argument cap" \
  || bad "aggregate is only $agg_bytes bytes; the test does not exercise the cap"
[ "$rc" -eq 0 ] \
  && ok "panel exited 0 with a large aggregate" \
  || bad "panel exited $rc with a large aggregate: $out"
last="$(printf '%s\n' "$out" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}')"
[ "$last" = pass ] \
  && ok "terminal token is 'pass'" \
  || bad "terminal token was '$last' (want pass)"
sin="$(cat "$TR/out/stdin-bytes" 2>/dev/null || echo 0)"
[ "$sin" -ge "$agg_bytes" ] \
  && ok "decider read the aggregate on stdin ($sin bytes)" \
  || bad "decider read $sin bytes on stdin, less than the $agg_bytes-byte aggregate"
argv="$(cat "$TR/out/argv-bytes" 2>/dev/null || echo 999999)"
[ "$argv" -lt 8192 ] \
  && ok "decider argv stayed small ($argv bytes)" \
  || bad "decider argv is $argv bytes; the aggregate is still on the command line"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
