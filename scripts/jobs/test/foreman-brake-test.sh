#!/bin/bash
# foreman-brake-test.sh — regression guard for the FOREMAN's independent brake
# (job garden-foreman-independent-brake): a throttle that stops ONLY the foreman
# pump, independent of the fleet drain.
#
# THE TRUTH TABLE this pins (foreman_braked = fleet_draining OR brake-set):
#
#   fleet drain | foreman brake | gardeners claim? | foreman pumps?
#   ------------|---------------|------------------|----------------
#   on          | either        | no               | no
#   off         | on            | yes              | no   ← the whole point
#   off         | off           | yes              | yes
#
# The foreman brake is JOURNAL-BACKED (config/foreman-brake on journal2), read
# from the journal clone the foreman already syncs each tick. This is the mechanical
# precursor to designs/omega-task-rank-and-foreman-retirement.md: the brake decouples
# "silence the pump" from "drain the fleet", which the all-or-nothing drain conflated.
#
# Each row is exercised with the REAL foreman.sh (pump detector: the stub handler
# is CALLED only when the guard lets the tick through) AND the REAL claim-job.sh
# (a gardener still claims under a brake — a test that only checked the foreman
# would prove nothing). systemd is not required: the scripts drive throwaway
# journal remotes and host-local $GARDEN_STATE markers.
#
# SUBTESTS:
#   1. CLI — brake-foreman.sh on|off|status writes/clears the journal flag.
#   2. drain off, brake off → foreman PUMPS, gardener CLAIMS.
#   3. drain off, brake on  → foreman IDLE,  gardener CLAIMS. (the whole point)
#   4. drain on,  brake off → foreman IDLE,  gardener does NOT claim. (no regression)
#   5. drain on,  brake on  → foreman IDLE,  gardener does NOT claim.
#   6. brake set then cleared → foreman RESUMES pumping.
#   7. fail-safe — a corrupt/garbage brake flag still BRAKES (existence is the signal).
#   8. fail-safe ordering — foreman.sh reads the brake AFTER sync_clone, so an
#      unreadable journal exits the tick before the read (never unbrakes).
#
# Usage: foreman-brake-test.sh
set -euo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env so a live gardener running this as a board job does not
# splice its own GARDEN_*/JOURNAL_* state underneath the fixture.
# shellcheck disable=SC2046  # deliberate word-splitting: unset each matched var
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true
# Re-assert the test-context sentinel AFTER the scrub (which stripped it): the
# production-journal push guard keys on GARDEN_TEST=1.
export GARDEN_TEST=1

STUB="$HERE/foreman-stub.sh"
BRANCH=journal2
declare -a GIT_ID=(-c user.name=test -c user.email=test@localhost)

TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-fbrake.XXXXXX")"; trap 'rm -rf "$TR"' EXIT

# --- new_journal <tag> → echo bare path: a fresh throwaway journal, board seeded
# with 3 claimable todo jobs (so the board is under the target AND a gardener has
# something to claim). Each subtest gets its own so rows never interfere. ----------
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

# brake_file_present <bare> → 0 if config/foreman-brake exists on the remote.
brake_file_present() {
  local bare="$1" v r=1; v="$(mktemp -d "$TR/bv.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$bare" "$v" 2>/dev/null
  [ -e "$v/config/foreman-brake" ] && r=0
  rm -rf "$v"; return "$r"
}

# pump_probe <bare> <state> → echo PUMPED | IDLE. Runs prime+real foreman ticks
# (IDLE_SETTLE=0): under the guard the priming tick exits before recording the
# settle clock, so the handler is NEVER called; unbraked, the second tick pumps and
# the stub records a call. The stub-calls file is the cost-gate signal.
pump_probe() {
  local bare="$1" state="$2"; local calls="$state/stub-calls"
  mkdir -p "$state"; : > "$calls"
  for _ in 1 2; do
    env GARDEN="okhost" GARDEN_STATE="$state" HOME="$TR" \
        JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
        GARDEN_FOREMAN_IDLE_SETTLE=0 \
        GARDEN_FOREMAN_HANDLER="$STUB" \
        GARDEN_FOREMAN_STUB_CALLS="$calls" \
        "$JOBS/foreman.sh" >/dev/null 2>&1 || true
  done
  if [ -s "$calls" ]; then echo PUMPED; else echo IDLE; fi
}

# claim_probe <bare> <state> → echo CLAIMED | NONE. A real gardener claim against
# the same journal + host-local drain marker the foreman saw.
claim_probe() {
  local bare="$1" state="$2" out rc=0
  out="$(env GARDEN="okhost" GARDEN_STATE="$state" HOME="$TR" \
             JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
             "$JOBS/claim-job.sh" 1 2>/dev/null)" || rc=$?
  if [ "$rc" -eq 0 ] && [ -n "$out" ]; then echo CLAIMED; else echo NONE; fi
}

# set_brake <bare> <state> on|off — drive the real CLI against the fixture.
set_brake() {
  local bare="$1" state="$2" act="$3"
  env GARDEN="okhost" GARDEN_STATE="$state" HOME="$TR" \
      JOURNAL_REMOTE="$bare" JOURNAL_BRANCH="$BRANCH" \
      "$JOBS/brake-foreman.sh" "$act" >/dev/null 2>&1
}

# ============================================================================
hr; echo "SUBTEST 1 — CLI: brake-foreman.sh on|off|status writes/clears the journal flag"; hr
B1="$(new_journal cli)"; S1="$TR/state-cli"
# Capture status output into a var (NOT `| grep -q`): the script runs under
# `set -o pipefail`, and grep -q exits on its first match, which SIGPIPEs the
# still-writing CLI upstream and would fail the pipeline despite a match.
status_out() {  # status_out <bare> <state> → the CLI's status text
  env GARDEN="okhost" GARDEN_STATE="$2" HOME="$TR" JOURNAL_REMOTE="$1" JOURNAL_BRANCH="$BRANCH" \
      "$JOBS/brake-foreman.sh" status 2>&1
}
so="$(status_out "$B1" "$S1")"
grep -q 'not braked' <<<"$so" && ok "status reports 'not braked' before any brake" || bad "status did not report not-braked initially (got: $so)"
set_brake "$B1" "$S1" on
brake_file_present "$B1" && ok "brake-foreman.sh on wrote config/foreman-brake to journal2" || bad "brake file not on the remote after 'on'"
so="$(status_out "$B1" "$S1")"
grep -q 'BRAKED' <<<"$so" && ok "status reports 'BRAKED' while set" || bad "status did not report BRAKED while set (got: $so)"
set_brake "$B1" "$S1" off
brake_file_present "$B1" && bad "brake file still on the remote after 'off'" || ok "brake-foreman.sh off removed config/foreman-brake"

# ============================================================================
hr; echo "SUBTEST 2 — drain OFF, brake OFF → foreman PUMPS, gardener CLAIMS"; hr
B2="$(new_journal r2)"; S2="$TR/state-r2"
p="$(pump_probe "$B2" "$S2/f")"; c="$(claim_probe "$B2" "$S2/g")"
[ "$p" = PUMPED ]  && ok "foreman pumped (handler called) with neither brake nor drain" || bad "foreman did NOT pump when free ($p)"
[ "$c" = CLAIMED ] && ok "gardener claimed with neither brake nor drain"                || bad "gardener did NOT claim when free ($c)"

# ============================================================================
hr; echo "SUBTEST 3 — drain OFF, brake ON → foreman IDLE, gardener CLAIMS (the point)"; hr
B3="$(new_journal r3)"; S3="$TR/state-r3"
set_brake "$B3" "$S3/f" on   # brake lives in the journal; set it via the CLI
p="$(pump_probe "$B3" "$S3/f")"; c="$(claim_probe "$B3" "$S3/g")"
[ "$p" = IDLE ]    && ok "foreman IDLE under the brake (no pump)"                        || bad "foreman pumped despite the brake ($p)"
[ "$c" = CLAIMED ] && ok "gardener STILL CLAIMS under the brake (drain off) — decoupled" || bad "brake wrongly stopped the gardener ($c)"

# ============================================================================
hr; echo "SUBTEST 4 — drain ON, brake OFF → foreman IDLE, gardener does NOT claim (no regression)"; hr
B4="$(new_journal r4)"; S4="$TR/state-r4"
mkdir -p "$S4/f" "$S4/g"; touch "$S4/f/draining" "$S4/g/draining"   # host-local drain marker
p="$(pump_probe "$B4" "$S4/f")"; c="$(claim_probe "$B4" "$S4/g")"
[ "$p" = IDLE ] && ok "drain still stops the foreman with no brake set (first table row)" || bad "foreman pumped while draining ($p)"
[ "$c" = NONE ] && ok "drain still stops the gardener (unchanged)"                         || bad "gardener claimed while draining ($c)"

# ============================================================================
hr; echo "SUBTEST 5 — drain ON, brake ON → foreman IDLE, gardener does NOT claim"; hr
B5="$(new_journal r5)"; S5="$TR/state-r5"
set_brake "$B5" "$S5/f" on
mkdir -p "$S5/f" "$S5/g"; touch "$S5/f/draining" "$S5/g/draining"
p="$(pump_probe "$B5" "$S5/f")"; c="$(claim_probe "$B5" "$S5/g")"
[ "$p" = IDLE ] && ok "foreman IDLE with both drain and brake" || bad "foreman pumped with drain+brake ($p)"
[ "$c" = NONE ] && ok "gardener held by the drain with both set" || bad "gardener claimed with drain+brake ($c)"

# ============================================================================
hr; echo "SUBTEST 6 — brake set then cleared → foreman RESUMES pumping"; hr
B6="$(new_journal r6)"; S6="$TR/state-r6"
set_brake "$B6" "$S6/f1" on
p_on="$(pump_probe "$B6" "$S6/f1")"
set_brake "$B6" "$S6/f2" off
p_off="$(pump_probe "$B6" "$S6/f2")"   # fresh foreman state so idle-since does not carry
[ "$p_on"  = IDLE ]   && ok "braked → IDLE"                     || bad "braked foreman pumped ($p_on)"
[ "$p_off" = PUMPED ] && ok "cleared → PUMPS again (resumes)"   || bad "cleared foreman did not resume ($p_off)"

# ============================================================================
hr; echo "SUBTEST 7 — fail-safe: a corrupt/garbage brake flag still BRAKES"; hr
# Existence is the signal (like the drain marker): a present-but-garbage flag must
# still brake, so an unreadable brake never silently UNbrakes. Assert both the pure
# predicate (foreman_braked) and the end-to-end foreman tick.
B7="$(new_journal r7)"; S7="$TR/state-r7"
# Push a garbage (non-prose, binary-ish) brake file directly.
GV="$(mktemp -d "$TR/gv.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$B7" "$GV"
printf '\x00\xff\x01garbage-not-a-reason\x00' > "$GV/config/foreman-brake"
git -C "$GV" add config/foreman-brake
git -C "$GV" "${GIT_ID[@]}" commit -q -m "corrupt brake flag"
git -C "$GV" push -q origin "HEAD:$BRANCH"
rm -rf "$GV"
p="$(pump_probe "$B7" "$S7/f")"
[ "$p" = IDLE ] && ok "a corrupt brake flag still stops the foreman (existence is the signal)" || bad "corrupt brake flag failed OPEN — foreman pumped ($p)"
# Pure-predicate check: foreman_braked against a clone whose brake file is garbage.
( set +e
  export GARDEN_STATE="$S7/pred"; mkdir -p "$GARDEN_STATE"
  # shellcheck source=../common.sh
  source "$JOBS/common.sh"
  CLONE="$TR/pred-clone"; mkdir -p "$CLONE/config"
  printf '\x00garbage' > "$CLONE/$GARDEN_FOREMAN_BRAKE_PATH"
  if foreman_braked "$CLONE"; then echo PRED_BRAKED; else echo PRED_FREE; fi
  rm -f "$CLONE/$GARDEN_FOREMAN_BRAKE_PATH"
  if foreman_braked "$CLONE"; then echo PRED_BRAKED2; else echo PRED_FREE2; fi
) > "$TR/pred.out" 2>/dev/null || true
grep -qx PRED_BRAKED  "$TR/pred.out" && ok "foreman_braked() true for a present garbage flag" || bad "foreman_braked() false for a garbage flag (should brake)"
grep -qx PRED_FREE2   "$TR/pred.out" && ok "foreman_braked() false once the flag is absent"     || bad "foreman_braked() true with no flag and no drain (should be free)"

# ============================================================================
hr; echo "SUBTEST 8 — fail-safe ordering: the brake is read AFTER the clone sync"; hr
# The journal-backed read is fail-safe ONLY if the clone is synced before the guard:
# sync_clone exits the tick on an offline/unreadable journal, so the pump can never
# fire on a journal it could not read. Pin that ordering so a future edit cannot
# reorder the guard above the sync and reintroduce a stale/absent-clone read.
sync_ln="$(grep -n '^sync_clone "\$DIR"' "$JOBS/foreman.sh" | head -1 | cut -d: -f1 || true)"
guard_ln="$(grep -n '^foreman_braked "\$DIR" && exit 0' "$JOBS/foreman.sh" | head -1 | cut -d: -f1 || true)"
{ [ -n "$sync_ln" ] && [ -n "$guard_ln" ] && [ "$sync_ln" -lt "$guard_ln" ]; } \
  && ok "foreman.sh reads the brake (line $guard_ln) AFTER sync_clone (line $sync_ln)" \
  || bad "foreman.sh brake guard is not strictly after sync_clone (sync=$sync_ln guard=$guard_ln)"
# And the guard uses foreman_braked, not the bare fleet_draining, at exactly one site.
[ "$(grep -c 'foreman_braked "\$DIR"' "$JOBS/foreman.sh")" -eq 1 ] \
  && ok "exactly one foreman_braked guard call site in foreman.sh" \
  || bad "expected exactly one foreman_braked call site in foreman.sh"
grep -q 'fleet_draining && exit 0' "$JOBS/foreman.sh" \
  && bad "foreman.sh still short-circuits on bare fleet_draining (should be foreman_braked)" \
  || ok "foreman.sh no longer guards on bare fleet_draining"

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
