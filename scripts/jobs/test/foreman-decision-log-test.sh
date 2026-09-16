#!/bin/bash
# foreman-decision-log-test.sh — regression guard for the foreman's per-tick
# DECISION record (job investigate-malingering-foreman, 2026-09-16).
#
# THE INCIDENT this pins: the fleet foreman is intentionally QUIESCED fleet-wide
# by GARDEN_FOREMAN_ACTIVE_TARGET=0 (systemd unit, kriskowal 2026-07-14). With
# target 0 the capacity check `inflight >= target` is ALWAYS true (inflight is a
# count, always >= 0), so EVERY tick takes the "fully subscribed" branch and
# exits 0 having pumped nothing — correct, but historically TRACELESS. A board
# sitting under-target for weeks (124 deferred plan jobs unpromoted) could only
# be diagnosed by live-debugging the running unit, because a successful-but-did-
# nothing tick left no durable record. self-heal-run.sh only captures on rc!=0,
# and this failure mode exits 0.
#
# The fix is a durable, host-local, self-trimming per-tick decision line under
# $GARDEN_STATE/foreman/decisions.log. This suite pins:
#   A. QUIESCE REPRODUCTION — target=0, a board UNDER the default target, still
#      does NOT pump (stub uncalled) AND records `guard=subscribed target=0`.
#      This is the exact malingering behavior, now visible in one line.
#   B. RECOVERY — raise the target above inflight and the foreman PUMPS again
#      (stub called) AND records `guard=pumped`. Proves the reservoir drains the
#      moment the quiesce is lifted (the "post-fix tick actually promoting").
#   C. LOCATION — the log is host-local under $GARDEN_STATE, NOT the journal
#      clone (a line every 5 min must not churn journal2).
#
# systemd is not required: the scripts drive a throwaway journal remote and
# host-local $GARDEN_STATE markers, exactly like foreman-brake-test.sh.
#
# Usage: foreman-decision-log-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/JOURNAL_* state underneath the fixture.
# shellcheck disable=SC2046
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
export GARDEN_TEST=1

STUB="$HERE/foreman-stub.sh"
BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fdlog.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# new_journal <tag> → bare path: a fresh journal seeded with 3 claimable todo jobs
# (inflight=3), so the board is UNDER the default active-job target of 5 but at/over
# a quiesced target of 0. Mirrors foreman-brake-test.sh's seeding.
new_journal() {
  local tag="$1"; local bare="$TR/$tag.git"; local seed="$TR/$tag.seed"
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$BRANCH"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
             schedules cursors config inbox/maintainer/unread inbox/maintainer/read
    for d in jobs/todo jobs/doin jobs/tada jobs/plan work repos msgs hosts entries \
             schedules cursors config inbox/maintainer/unread inbox/maintainer/read; do
      touch "$d/.gitkeep"
    done
    for n in 1 2 3; do printf '# claimme-%s\n\ndo the work for claimme-%s\n' "$n" "$n" > "jobs/todo/claimme-$n.md"; done )
  git -C "$seed" add -A
  git -C "$seed" "${GIT_ID[@]}" commit -q -m "seed: board + 3 claimable jobs"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$BRANCH"
  printf '%s\n' "$bare"
}

# tick <bare> <state> <target> — one real foreman tick (settle window collapsed to
# 0 so a two-tick caller can reach the pump on the second tick). Records handler
# calls to <state>/stub-calls.
tick() {
  local bare="$1" state="$2" target="$3"
  mkdir -p "$state"
  env GARDEN="okhost" GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      GARDEN_FOREMAN_IDLE_SETTLE=0 \
      GARDEN_FOREMAN_ACTIVE_TARGET="$target" \
      GARDEN_FOREMAN_HANDLER="$STUB" \
      GARDEN_FOREMAN_STUB_CALLS="$state/stub-calls" \
      "$JOBS/foreman.sh" >/dev/null 2>&1 || true
}

# ============================================================================
hr; echo "SUBTEST A — QUIESCE (target=0): board under default target still does NOT pump, logs 'subscribed'"; hr
BA="$(new_journal a)"; SA="$TR/state-a/f"; mkdir -p "$SA"; : > "$SA/stub-calls"
tick "$BA" "$SA" 0
tick "$BA" "$SA" 0
DLA="$SA/foreman/decisions.log"
[ ! -s "$SA/stub-calls" ] && ok "target=0 pumps NOTHING though inflight(3) is under the default target(5)" \
  || bad "target=0 unexpectedly pumped (stub called)"
[ -f "$DLA" ] && ok "a decisions.log was written under \$GARDEN_STATE/foreman" \
  || bad "no decisions.log written"
grep -q 'target=0 guard=subscribed' "$DLA" 2>/dev/null \
  && ok "the quiesce is now VISIBLE in one line: 'guard=subscribed target=0'" \
  || bad "decisions.log lacks the 'guard=subscribed target=0' line (got: $(cat "$DLA" 2>/dev/null))"

# ============================================================================
hr; echo "SUBTEST B — RECOVERY (target=5): lifting the quiesce PUMPS again, logs 'pumped'"; hr
BB="$(new_journal b)"; SB="$TR/state-b/f"; mkdir -p "$SB"; : > "$SB/stub-calls"
tick "$BB" "$SB" 5      # tick 1: below target → settle-start (settle=0)
tick "$BB" "$SB" 5      # tick 2: settle elapsed → promote/pump path → stub JOB
DLB="$SB/foreman/decisions.log"
[ -s "$SB/stub-calls" ] && ok "target=5 with inflight(3) < target PUMPS (stub called)" \
  || bad "target=5 did NOT pump (stub uncalled) — reservoir would stay stalled"
grep -q 'guard=pumped' "$DLB" 2>/dev/null \
  && ok "the pump is recorded: 'guard=pumped' (the post-quiesce tick draining the reservoir)" \
  || bad "decisions.log lacks a 'guard=pumped' line (got: $(cat "$DLB" 2>/dev/null))"
grep -q 'guard=settle-start' "$DLB" 2>/dev/null \
  && ok "the settle-clock start is recorded on the first below-target tick" \
  || bad "decisions.log lacks a 'guard=settle-start' line (got: $(cat "$DLB" 2>/dev/null))"

# ============================================================================
hr; echo "SUBTEST C — LOCATION: the decision log is host-local, never in the journal clone"; hr
# The journal clone the foreman syncs lives at $GARDEN_STATE/foreman/journal; the
# decision log is a SIBLING at $GARDEN_STATE/foreman/decisions.log, so it is never
# committed or pushed to journal2.
[ -f "$SA/foreman/decisions.log" ] && [ ! -e "$SA/foreman/journal/decisions.log" ] \
  && ok "decisions.log is host-local (\$GARDEN_STATE/foreman), not inside the synced journal clone" \
  || bad "decisions.log leaked into the journal clone (would churn journal2)"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
