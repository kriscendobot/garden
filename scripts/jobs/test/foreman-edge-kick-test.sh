#!/bin/bash
# foreman-edge-kick-test.sh — regression guard for the DETERMINISTIC foreman
# EDGE trigger on gardener job completion (common.sh § foreman_kick; complete-job.sh).
#
# THE BEHAVIOR: the foreman tops off idle gardeners, but on its own it fires only
# on a 5-minute poll + a 240s idle-settle debounce, so after the board drains it
# can be minutes before idle gardeners get refilled. complete-job.sh now ALSO
# edge-kicks the foreman the instant a gardener completes a job — deterministic,
# non-blocking (`start --no-block`), best-effort (all errors swallowed) — via the
# unit_ctl indirection that GARDEN_UNIT_CTL mocks.
#
# SUBTEST 1 — a successful completion invokes
#             `unit_ctl start --no-block garden-foreman.service`.
# SUBTEST 2 — GARDEN_FOREMAN_EDGE_KICK=0 suppresses the kick (no unit_ctl call).
# SUBTEST 3 — a failing/absent unit_ctl (mock exits non-zero) does NOT fail the
#             completion: the job still lands in tada/ and complete-job.sh exits 0.
#
# Usage: foreman-edge-kick-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_* state underneath the fixture).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

STUB="$HERE/unit-ctl-log-stub.sh"

# seed_board <dir> <base> — make a throwaway origin with the board structure, one
# job already CLAIMED into doin/<base> (complete-job moves it doin→tada); echoes
# the bare-repo path. Each subtest gets its own.
seed_board() {
  local tr="$1" base="$2" bare="$1/journal.git" seed="$1/seed" branch=journal2
  local -a git_id=(-c user.name=test -c user.email=test@localhost)
  git init -q --bare "$bare"
  git init -q "$seed"; git -C "$seed" checkout -q -b "$branch"
  ( cd "$seed"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    printf '# %s\n\ndo the work for %s\n' "$base" "$base" > "jobs/doin/$base.md" )
  git -C "$seed" add -A
  git -C "$seed" "${git_id[@]}" commit -q -m "seed: 1 claimed job + structure"
  git -C "$seed" remote add origin "$bare"
  git -C "$seed" push -q -u origin "$branch"
  printf '%s\n' "$bare"
}

# run_complete <dir> <base> <log> [extra env KEY=VAL ...] — run complete-job.sh
# against a fresh clone with the logging unit_ctl mock; echoes the script's rc.
run_complete() {
  local tr="$1" base="$2" log="$3"; shift 3
  local bare rpt rc=0
  bare="$(seed_board "$tr" "$base")"
  rpt="$tr/report.md"; printf 'did the work for %s\n' "$base" > "$rpt"
  : > "$log"
  env GARDEN="okhost" GARDEN_STATE="$tr/state" JOURNAL_REMOTE="$bare" JOURNAL_BRANCH=journal2 \
      GARDEN_UNIT_CTL="$STUB" GARDEN_UNIT_CTL_LOG="$log" "$@" \
      "$JOBS/complete-job.sh" 1 "$base" "$rpt" > "$tr/complete.log" 2>&1 || rc=$?
  printf '%s\n' "$rc"
}

verify_tada() {  # verify_tada <bare> <base> → 0 if job is in tada/ and gone from doin/
  local bare="$1" base="$2" v; v="$(mktemp -d)"
  git clone -q --single-branch --branch journal2 "$bare" "$v" 2>/dev/null
  local r=1
  [ -f "$v/jobs/tada/$base.md" ] && [ ! -e "$v/jobs/doin/$base.md" ] && r=0
  rm -rf "$v"; return "$r"
}

# ============================================================================
hr; echo "SUBTEST 1 — a successful completion edge-kicks the foreman"; hr
T1="$(mktemp -d "${TMPDIR:-/tmp}/garden-fkick1.XXXXXX")"; trap 'rm -rf "$T1"' EXIT
L1="$T1/unit-ctl.log"
rc="$(run_complete "$T1" kickjob "$L1")"
[ "$rc" = "0" ] && ok "complete-job.sh exited 0" || bad "complete-job.sh exited $rc"
grep -qxF "start --no-block garden-foreman.service" "$L1" \
  && ok "completion invoked 'unit_ctl start --no-block garden-foreman.service'" \
  || bad "expected foreman start --no-block not logged (log: $(tr '\n' '|' <"$L1"))"

# ============================================================================
hr; echo "SUBTEST 2 — GARDEN_FOREMAN_EDGE_KICK=0 suppresses the kick"; hr
T2="$(mktemp -d "${TMPDIR:-/tmp}/garden-fkick2.XXXXXX")"
L2="$T2/unit-ctl.log"
rc="$(run_complete "$T2" nokickjob "$L2" GARDEN_FOREMAN_EDGE_KICK=0)"
[ "$rc" = "0" ] && ok "complete-job.sh exited 0 with the kick disabled" || bad "complete-job.sh exited $rc"
[ ! -s "$L2" ] \
  && ok "GARDEN_FOREMAN_EDGE_KICK=0 → no unit_ctl call at all" \
  || bad "kick fired despite the disable toggle (log: $(tr '\n' '|' <"$L2"))"

# ============================================================================
hr; echo "SUBTEST 3 — a failing unit_ctl never fails the completion"; hr
T3="$(mktemp -d "${TMPDIR:-/tmp}/garden-fkick3.XXXXXX")"
L3="$T3/unit-ctl.log"
rc="$(run_complete "$T3" failkick "$L3" GARDEN_UNIT_CTL_FAIL=1)"
[ "$rc" = "0" ] \
  && ok "a non-zero unit_ctl did NOT fail the completion (exit 0)" \
  || bad "failing unit_ctl propagated a failure (complete-job.sh exited $rc; log: $(cat "$T3/complete.log"))"
grep -qxF "start --no-block garden-foreman.service" "$L3" \
  && ok "the kick was still attempted (the failure was swallowed, not skipped)" \
  || bad "kick not attempted (log: $(tr '\n' '|' <"$L3"))"
verify_tada "$T3/journal.git" failkick \
  && ok "the job still landed in tada/ despite the failing kick" \
  || bad "the job did not complete to tada/ when the kick failed"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
