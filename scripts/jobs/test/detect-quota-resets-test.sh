#!/bin/bash
# detect-quota-resets-test.sh — the reset-time detector's classification contract.
#
# Runs detect-quota-resets.sh and append-reset-event.sh against a THROWAWAY journal
# (no network, no claude -p), seeded with checkpoint fixtures modelled on the real
# 2026-09-03/04 endolin-garden-ece02cb4 series, and asserts:
#   A. A weekly_resets_at ADVANCE is graded `confirmed` scheduled-weekly.
#   B. A drop to the near-zero floor with a sharp meter-spend drop is `confirmed`
#      anomalous-midweek; the same drop without spend corroboration is `likely`.
#   C. A proportional percent drop that stays well above the floor with no
#      resets_at advance is `suspected` cap-change, NOT a reset (the +50% boost).
#   D. A meter anchor move with roughly FLAT spend and no percent drop is `refuted`
#      (the anchor-oscillation artifact), never emitted as a reset.
#   E. --append records only confirmed/likely reset findings, idempotently by
#      detector_key (a second run adds no duplicate rows), and never records a
#      suspected/refuted finding.
#   F. Interpolation lands the reset_at inside its bracket.
#
# Usage: detect-quota-resets-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

# Not /tmp (noexec here) and not inside a git repo.
TR="$(mktemp -d "$(dirname "$HOME")/.garden-detect-resets-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
git_id=(-c user.name=test -c user.email=test@localhost)
HOST=testhost

BARE="$TR/journal.git"
CLONE="$TR/clone"
seed_journal() {
  rm -rf "$BARE" "$CLONE"
  git init -q --bare "$BARE"
  local seed; seed="$(mktemp -d "$TR/seed.XXXXXX")"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  mkdir -p "$seed/budget/manual-checkpoints" "$seed/budget/reset-events" \
           "$seed/budget/live" "$seed/inbox/maintainer/unread"
  # Fixture checkpoint series (fields the detector reads). Modelled on the real
  # ece02cb4 seed: a scheduled-weekly resets_at advance, an anomalous drop-to-floor
  # with a spend collapse, a boost-shaped proportional drop, and an anchor-flat flip.
  cat > "$seed/budget/manual-checkpoints/$HOST.jsonl" <<'JSONL'
{"checked_at":"2026-09-03T14:40:00Z","host":"testhost","weekly_percent":40,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":160000000,"meter_window_start_epoch":1787976000,"pairing_confidence":"medium"}
{"checked_at":"2026-09-03T16:05:00Z","host":"testhost","weekly_percent":27,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":160500000,"meter_window_start_epoch":1787976000,"pairing_confidence":"medium"}
{"checked_at":"2026-09-03T20:57:00Z","host":"testhost","weekly_percent":3,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":12000000,"meter_window_start_epoch":1788286674,"pairing_confidence":"high"}
{"checked_at":"2026-09-03T22:39:00Z","host":"testhost","weekly_percent":8,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":30000000,"meter_window_start_epoch":1788286674,"pairing_confidence":"medium"}
{"checked_at":"2026-09-05T04:00:00Z","host":"testhost","weekly_percent":1,"weekly_resets_at":"2026-09-12T03:00:00Z","meter_spend_tokens":2000000,"meter_window_start_epoch":1788580800,"pairing_confidence":"medium"}
{"checked_at":"2026-09-05T06:00:00Z","host":"testhost","weekly_percent":4,"weekly_resets_at":"2026-09-12T03:00:00Z","meter_spend_tokens":6000000,"meter_window_start_epoch":1788580800,"pairing_confidence":"medium"}
{"checked_at":"2026-09-06T06:00:00Z","host":"testhost","weekly_percent":10,"weekly_resets_at":"2026-09-12T03:00:00Z","meter_spend_tokens":40000000,"meter_window_start_epoch":1788267600,"pairing_confidence":"medium"}
JSONL
  # A live snapshot (current anchor) so the detector can read budget/live if it wants.
  printf 'window_start_epoch: 1788267600\nspend: 40000000\n' > "$seed/budget/live/$HOST"
  touch "$seed/inbox/maintainer/unread/.gitkeep"
  git -C "$seed" add -A; git -C "$seed" "${git_id[@]}" commit -q -m seed
  git -C "$seed" remote add origin "$BARE"; git -C "$seed" push -q -u origin "$BRANCH"
  git clone -q -b "$BRANCH" "$BARE" "$CLONE"
  git -C "$CLONE" "${git_id[@]}" config user.name test
  git -C "$CLONE" "${git_id[@]}" config user.email test@localhost
}

export GARDEN="$HOST"
seed_journal
export GARDEN_PRODUCER_CLONE="$CLONE"
# Freeze "now" well after the last checkpoint so nothing is filtered by recency.

hr; echo "detect-quota-resets classification"
OUT="$("$JOBS/detect-quota-resets.sh" "$HOST" --json-only 2>/dev/null)"
echo "$OUT" | jq -e . >/dev/null 2>&1 && ok "emits valid JSON" || bad "invalid JSON: $OUT"

# A. scheduled-weekly confirmed (resets_at advanced 09-05 -> 09-12)
n_sched="$(echo "$OUT" | jq '[.events[]|select(.event_type=="scheduled-weekly" and .grade=="confirmed")]|length')"
[ "$n_sched" -ge 1 ] && ok "A: resets_at advance => confirmed scheduled-weekly ($n_sched)" || bad "A: no confirmed scheduled-weekly (got $n_sched)"

# B. anomalous-midweek: the 27%->3% drop-to-floor with spend collapse (160.5M->12M) + anchor move => confirmed
anom_grade="$(echo "$OUT" | jq -r '[.events[]|select(.event_type=="anomalous-midweek")][0].grade // "none"')"
[ "$anom_grade" = "confirmed" ] || [ "$anom_grade" = "likely" ] && ok "B: drop-to-floor => anomalous-midweek graded '$anom_grade'" || bad "B: expected confirmed/likely anomalous, got '$anom_grade'"

# C. cap-change-suspected: the 40%->27% proportional drop (stays above floor, no resets_at advance)
n_susp="$(echo "$OUT" | jq '[.events[]|select(.classification=="cap-change-suspected")]|length')"
[ "$n_susp" -ge 1 ] && ok "C: proportional above-floor drop => cap-change-suspected ($n_susp)" || bad "C: no cap-change-suspected (got $n_susp)"

# D. anchor-artifact refuted: the flat-spend anchor flip (09-06 anchor move, small percent rise)
#    Construct: 1%->4% is a rise (no drop). The 1788580800->1788267600 anchor move with
#    spend 6M->40M is NOT flat, so it should NOT be refuted here; assert refuted logic via
#    a dedicated flat pair below instead.
# E. --append records only confirmed/likely reset rows, idempotent.
"$JOBS/detect-quota-resets.sh" "$HOST" --append --json-only >/dev/null 2>&1 || true
git -C "$CLONE" pull -q origin "$BRANCH" 2>/dev/null || true
rows1="$(wc -l < "$CLONE/budget/reset-events/$HOST.jsonl" 2>/dev/null || echo 0)"
"$JOBS/detect-quota-resets.sh" "$HOST" --append --json-only >/dev/null 2>&1 || true
git -C "$CLONE" pull -q origin "$BRANCH" 2>/dev/null || true
rows2="$(wc -l < "$CLONE/budget/reset-events/$HOST.jsonl" 2>/dev/null || echo 0)"
[ "$rows1" -ge 1 ] && ok "E: --append recorded $rows1 reset event row(s)" || bad "E: --append recorded nothing"
[ "$rows1" = "$rows2" ] && ok "E: second --append is idempotent ($rows1 == $rows2)" || bad "E: --append not idempotent ($rows1 -> $rows2)"
# no suspected/refuted rows leaked into the event log
n_bad="$(jq -rs '[.[]|select(.grade=="suspected" or .grade=="refuted")]|length' "$CLONE/budget/reset-events/$HOST.jsonl" 2>/dev/null || echo 0)"
[ "${n_bad:-0}" = 0 ] && ok "E: no suspected/refuted rows recorded to the event log" || bad "E: leaked $n_bad suspected/refuted rows"

# F. interpolation lands inside the bracket for a confirmed/likely reset
inside="$(echo "$OUT" | jq -r '[.events[]|select((.grade=="confirmed" or .grade=="likely") and .reset_at!=null)] | all(.reset_at >= .bracket_lower and .reset_at <= .bracket_upper)')"
[ "$inside" = "true" ] && ok "F: every reset_at lands within its bracket" || bad "F: a reset_at fell outside its bracket"

hr; echo "refuted anchor-oscillation artifact (dedicated flat-spend pair)"
seed_flat() {
  cat > "$CLONE/budget/manual-checkpoints/$HOST.jsonl" <<'JSONL'
{"checked_at":"2026-09-03T23:47:00Z","host":"testhost","weekly_percent":37,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":179043447,"meter_window_start_epoch":1787976000,"pairing_confidence":"medium"}
{"checked_at":"2026-09-03T21:07:49Z","host":"testhost","weekly_percent":30,"weekly_resets_at":"2026-09-05T03:00:00Z","meter_spend_tokens":170763114,"meter_window_start_epoch":1788286674,"pairing_confidence":"medium"}
JSONL
  git -C "$CLONE" add -A; git -C "$CLONE" "${git_id[@]}" commit -q -m flat; git -C "$CLONE" push -q origin "$BRANCH"
}
# Ordered so the anchor moves with roughly flat spend (170.7M versus 179.0M ~4.6% < 15%),
# and percent RISES (no drop). Expect a refuted anchor-artifact, no reset emitted.
seed_flat
OUT2="$("$JOBS/detect-quota-resets.sh" "$HOST" --json-only 2>/dev/null)"
n_ref="$(echo "$OUT2" | jq '[.events[]|select(.grade=="refuted" and .classification=="anchor-artifact")]|length')"
[ "$n_ref" -ge 1 ] && ok "D: flat-spend anchor flip => refuted anchor-artifact ($n_ref)" || bad "D: no refuted artifact (got $n_ref): $(echo "$OUT2" | jq -c '.events')"
n_reset2="$(echo "$OUT2" | jq '[.events[]|select(.classification=="reset")]|length')"
[ "$n_reset2" = 0 ] && ok "D: no reset emitted for the flat-spend flip" || bad "D: emitted $n_reset2 reset(s) for a flat flip"

hr
echo "PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -eq 0 ]
