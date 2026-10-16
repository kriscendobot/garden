#!/bin/bash
# Regression: a finished monk job's retired session transcript still counts in
# the host usage meter's window, and is pruned once outside the retention age.
#
# monk-claude.sh used to rm -f the top-level transcript on genuine completion
# (resume safety), which dropped every finished job's top-level tokens out of
# _meter_session_total and held budget/live spend flat while monks ran
# (oros-studio, 2026-10-16). It now retires the file via meter_retire_transcript
# into GARDEN_RETIRED_TRANSCRIPTS, which the window scan reads alongside the logdir.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-meter-retired-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
pass=0; fail=0
ok() { echo "PASS: $*"; pass=$((pass+1)); }
bad() { echo "FAIL: $*"; fail=$((fail+1)); }

NOW="$(date -u -d 2026-10-16T09:00:00Z +%s)"
LOGDIR="$TR/projects"; RETIRED="$TR/retired"
mkdir -p "$LOGDIR/-scratch-live" "$LOGDIR/-scratch-done"

turn() { # <msg-id> <iso-ts> <input> <output> <cache-creation>
  printf '{"type":"assistant","timestamp":"%s","message":{"id":"%s","model":"claude-opus-5-5","usage":{"input_tokens":%s,"output_tokens":%s,"cache_creation_input_tokens":%s,"cache_read_input_tokens":100000}}}\n' "$2" "$1" "$3" "$4" "$5"
}
# A still-running session (live in the projects tree): 100 billable.
turn m-live 2026-10-16T08:00:00Z 50 30 20 > "$LOGDIR/-scratch-live/live.jsonl"
touch -d @"$((NOW - 3600))" "$LOGDIR/-scratch-live/live.jsonl"
# A finished session about to be retired: 1000 billable, line repeated (dedupe).
{ turn m-done 2026-10-16T07:00:00Z 600 300 100; turn m-done 2026-10-16T07:00:00Z 600 300 100; } \
  > "$LOGDIR/-scratch-done/sid-done.jsonl"
touch -d @"$((NOW - 7200))" "$LOGDIR/-scratch-done/sid-done.jsonl"
# A retired transcript from an old job, past the 8-day retention.
mkdir -p "$RETIRED"
turn m-old 2026-10-05T07:00:00Z 7777 0 0 > "$RETIRED/old-job-sid-old.jsonl"
touch -d @"$((NOW - 11 * 86400))" "$RETIRED/old-job-sid-old.jsonl"

run() { # <snippet>
  GARDEN_USAGE_NOW="$NOW" GARDEN_CCUSAGE_LOGDIR="$LOGDIR" GARDEN_RETIRED_TRANSCRIPTS="$RETIRED" \
  GARDEN_STATE="$TR/state" bash -c 'set -u; source "$1/common.sh"; eval "$2"' _ "$JOBS" "$1"
}
CUT=$((NOW - 604800))

before="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $CUT")"
[ "$before" = 1100 ] && ok "baseline counts live+finished (=1100)" || bad "baseline=$before"

run 'meter_retire_transcript "$GARDEN_CCUSAGE_LOGDIR/-scratch-done/sid-done.jsonl" "fix-foo"'
[ ! -e "$LOGDIR/-scratch-done/sid-done.jsonl" ] && ok "transcript removed from projects tree (resume-safe)" \
  || bad "transcript still resumable under the projects tree"
dest="$RETIRED/fix-foo-sid-done.jsonl"
if [ -f "$dest" ] && [ "$(stat -c %Y "$dest")" = "$((NOW - 7200))" ]; then
  ok "retired as <base>-<sid>.jsonl with mtime preserved"
else
  bad "retired file missing or mtime changed: $(ls -l "$RETIRED" 2>&1)"
fi
[ ! -e "$RETIRED/old-job-sid-old.jsonl" ] && ok "retired transcript outside retention pruned" \
  || bad "old retired transcript survived the prune"

after="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $CUT")"
[ "$after" = 1100 ] && ok "retired transcript still counted in window (=1100)" || bad "after retire=$after"

wt="$(run 'meter_window_total 604800')"
[ "$wt" = 1100 ] && ok "meter_window_total includes retired spend" || bad "meter_window_total=$wt"

# Overlap (a copy still in the logdir) is deduped by message id.
cp -p "$dest" "$LOGDIR/-scratch-done/dup.jsonl"
dup="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $CUT")"
[ "$dup" = 1100 ] && ok "overlap deduped by message id" || bad "overlap total=$dup"
rm -f "$LOGDIR/-scratch-done/dup.jsonl"

# A retired transcript older than the window cutoff is not counted.
narrow="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $((NOW - 5400))")"
[ "$narrow" = 100 ] && ok "retired turns before the cutoff excluded (=100)" || bad "narrow=$narrow"

# Liveness: an empty projects tree with only retired history is a genuine idle 0.
rm -rf "${LOGDIR:?}"/*
idle="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $NOW")"
[ "$idle" = 0 ] && ok "retired history proves the sensor live (idle=0)" || bad "idle=$idle"

# Absent retired dir: the scan still works (no find error from a missing root).
rm -rf "$RETIRED"
set +e; none="$(run "_meter_session_total \"\$GARDEN_CCUSAGE_LOGDIR\" $NOW")"; nrc=$?; set -e
[ "$nrc" -eq 1 ] && ok "no session files anywhere is still blind (rc=1)" || bad "blind rc=$nrc out=$none"

echo "meter-retired-transcript: $pass passed, $fail failed"
[ "$fail" -eq 0 ]
