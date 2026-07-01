#!/bin/bash
# elapsed-constancy-classifier-test.sh — regression guard for gardener.sh's
# elapsed-constancy early-escalation (gardener.sh transient branch; the pure
# helpers prior_transient_elapsed_series / elapsed_within_band in common.sh).
#
# The problem: a transient CLASSIFICATION is not proof of a self-resolving blip. A
# job that deterministically OVERRUNS and dies with a transient-claude signature (a
# Claude Code session/usage cap tripping at the same point every run — the
# 2026-07-01 incident — or a prompt that always drives the CLI to the same failure)
# is classified TRANSIENT by gardener.sh's handler-failure classifier and requeued
# UNCHANGED through all GARDEN_REAP_POISON_THRESHOLD (default 5) cycles before the
# reaper's poison counter surfaces it (~5×TTL). Its tell is a near-CONSTANT elapsed
# across requeue cycles: a genuine deploy/drain/OOM blip is killed at a VARIED
# elapsed (and reads as an external-kill/timeout rc), whereas a deterministic
# overrun dies at the same wall-time every cycle.
#
# The fix: after the transient classification (which still leaves the job in doin
# for the reaper — the reaper stays the SOLE requeue writer), the gardener recovers
# the prior cycles' elapsed for this base READ-ONLY from its already-synced progress
# entries and, once the trailing N-cycle window (N = GARDEN_ELAPSED_CONSTANCY_CYCLES,
# default 2) agrees within a tolerance band on a NON-external-kill rc WITH real
# output, emits ONE gardener-inbox kind:error flagging the likely misclassification
# — surfacing a genuinely-stuck job in ~2 cycles instead of ~5, and moving the
# "is this stuck?" judgment off a human/watchman grep into the script.
#
# SUBTEST 1 drives the pure helpers directly. SUBTEST 2 is the integration case: a
# job on its 3rd requeue cycle (reap-count 2) with two constant-elapsed prior notes
# seeded, failing again transiently at the same elapsed — the escalation must fire
# (inbox + kind:error) while the job STAYS in doin (requeue ownership unchanged).
# SUBTEST 3 is the disable gate (GARDEN_ELAPSED_CONSTANCY_CYCLES=0 → no escalation).
# SUBTEST 4 is the dedup guard: a prior escalation entry for the base suppresses a
# second. SUBTEST 5 is the not-enough-cycles guard: a first-pass job (reap-count 0)
# with a transient failure escalates NOTHING (ordinary transient behavior intact).
#
# Usage: elapsed-constancy-classifier-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state underneath the
# fixture; see run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

git_id=(-c user.name=test -c user.email=test@localhost)

# ============================================================================
hr; echo "SUBTEST 1 — pure helpers: elapsed_within_band + prior_transient_elapsed_series"; hr
# Near-constant windows agree; a wide spread does not; a single value / non-integer
# / zero is never "constant" (inconclusive, never a false positive).
elapsed_within_band 15 470 471       && ok "470,471 within ±15% → constant" || bad "470,471 not classified constant"
elapsed_within_band 15 470 471 469   && ok "470,471,469 within ±15% → constant" || bad "470,471,469 not constant"
if elapsed_within_band 15 470 900; then bad "470,900 classified constant (a 91% jump)"; else ok "470,900 → NOT constant (varied elapsed, correctly rejected)"; fi
if elapsed_within_band 15 470;     then bad "single value classified constant"; else ok "single value → NOT constant (needs ≥2)"; fi
if elapsed_within_band 15 470 abc; then bad "non-integer swept into constant"; else ok "non-integer arg → NOT constant (inconclusive)"; fi
if elapsed_within_band 15 0 0;     then bad "zeros classified constant"; else ok "zero values → NOT constant"; fi

# prior_transient_elapsed_series recovers elapsed in chronological order and does
# NOT bleed a base that is only a PREFIX of a different base into the series.
TD="$(mktemp -d "${TMPDIR:-/tmp}/garden-series.XXXXXX")"
mkdir -p "$TD/entries/2026/07/01"
printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 0, elapsed=470s); left in doin\n' > "$TD/entries/2026/07/01/010000Z-progress-gardener-a.md"
printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 1, elapsed=472s); left in doin\n' > "$TD/entries/2026/07/01/020000Z-progress-gardener-b.md"
printf 'job overrunjob-extra handler exited rc=1 (…); elapsed=99s\n' > "$TD/entries/2026/07/01/030000Z-progress-gardener-c.md"
series="$(prior_transient_elapsed_series "$TD" overrunjob | paste -sd, -)"
if [ "$series" = "470,472" ]; then ok "series recovered oldest→newest (470,472), prefix base 'overrunjob-extra' (99s) NOT bled in"; else bad "series wrong: got '$series' (expected 470,472)"; fi
rm -rf "$TD"

# ---------------------------------------------------------------------------
# Shared integration fixture builder: a throwaway origin with the board structure,
# ONE job in todo carrying a seeded reap-count marker, and (optionally) prior
# constant-elapsed progress notes + a prior escalation entry seeded into entries/.
# Echoes "<TR> <BARE>".
build_fixture() {
  local reaps="$1" seed_priors="$2" seed_dedup="$3"
  local TR BARE SEED BRANCH=journal2
  TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-elapsed.XXXXXX")"
  BARE="$TR/journal.git"; SEED="$TR/seed"
  git init -q --bare "$BARE"
  git init -q "$SEED"
  git -C "$SEED" checkout -q -b "$BRANCH"
  (
    cd "$SEED"
    mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
    for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
    # The claimed-again job. A body reap-count marker makes reap_count() return
    # $reaps after the claim (the claim preserves the body).
    {
      printf '# overrunjob\n\ndo the work for overrunjob\n\n'
      [ "$reaps" -gt 0 ] && printf '<!-- garden-reaped: %s -->\n' "$reaps"
    } > jobs/todo/overrunjob.md
    if [ "$seed_priors" = 1 ]; then
      mkdir -p entries/2026/07/01
      printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 0, elapsed=3s); left in doin\n' > entries/2026/07/01/010000Z-progress-gardener-a.md
      printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 1, elapsed=3s); left in doin\n' > entries/2026/07/01/020000Z-progress-gardener-b.md
    fi
    if [ "$seed_dedup" = 1 ]; then
      mkdir -p entries/2026/07/01
      printf 'gardener-x on h: job overrunjob … escalated ONE kind:error to the gardener inbox (elapsed-constancy overrun-suspect: overrunjob, sha=deadbeef), left in doin\n' > entries/2026/07/01/025959Z-error-gardener-z.md
    fi
  )
  git -C "$SEED" add -A
  git -C "$SEED" "${git_id[@]}" commit -q -m "seed"
  git -C "$SEED" remote add origin "$BARE"
  git -C "$SEED" push -q -u origin "$BRANCH"
  printf '%s %s\n' "$TR" "$BARE"
}

# Run the REAL gardener.sh oneshot against the elapsed-constancy stub (sleeps ~3s,
# emits the session-cap transient signature, exits rc=1). Extra env is appended.
run_gardener() {
  local BARE="$1" host="$2" TR="$3"; shift 3
  env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
      GARDEN="$host" GARDEN_STATE="$TR/state" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=1 GARDEN_STUB_SLEEP=3 \
      GARDEN_ELAPSED_CONSTANCY_TOLERANCE_PCT=60 \
      GARDEN_JOB_HANDLER="$HERE/elapsed-constancy-handler-stub.sh" \
      "$@" \
      "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true
}

# ============================================================================
hr; echo "SUBTEST 2 — integration: 3rd cycle, constant elapsed, transient rc=1 → ESCALATES (job stays in doin)"; hr
read -r TR2 BARE2 < <(build_fixture 2 1 0)
trap 'rm -rf "$TR2"' EXIT
run_gardener "$BARE2" echost2 "$TR2" GARDEN_ELAPSED_CONSTANCY_CYCLES=2
CLONE2="$TR2/state/gardeners/1/journal"

# (a) still classified TRANSIENT (the base classification is unchanged).
if grep -Eq "looks transient \(rc=1[,)]" "$TR2/gardener.log"; then
  ok "handler failure still classified transient (rc=1)"
else
  bad "transient verdict not logged; log: $(grep -i 'transient\|constancy\|FAILED' "$TR2/gardener.log" | tail -3)"
fi
# (b) the elapsed-constancy escalation fired (the new behavior).
if grep -q "elapsed-constancy early-escalation for 'overrunjob'" "$TR2/gardener.log"; then
  ok "elapsed-constancy early-escalation fired at cycle 2 (before the ~5-cycle poison threshold)"
else
  bad "escalation did NOT fire; log: $(grep -i 'constancy\|transient\|cycle' "$TR2/gardener.log" | tail -5)"
fi
# (c) ONE gardener-inbox kind:error was appended (report-error.sh created the file).
if [ -e "$CLONE2/inboxes/echost2/gardener.md" ] && grep -q "elapsed-constancy-overrun-suspect" "$CLONE2/inboxes/echost2/gardener.md"; then
  ok "gardener inbox carries the elapsed-constancy-overrun-suspect escalation"
else
  bad "no elapsed-constancy inbox escalation (file=$([ -e "$CLONE2/inboxes/echost2/gardener.md" ] && echo y || echo n))"
fi
# (d) exactly ONE inbox section for this escalation (fires once per run). Count the
# section headers ("## lane N -- <state> failure at …"), not raw string hits (the
# state name also appears on the section's `- State:` line).
nsect=$(grep -cE "^## lane .* elapsed-constancy-overrun-suspect failure at " "$CLONE2/inboxes/echost2/gardener.md" 2>/dev/null || echo 0)
if [ "${nsect:-0}" -eq 1 ]; then ok "exactly ONE inbox section emitted"; else bad "expected 1 inbox section, got ${nsect:-0}"; fi
# (e) the job STAYS in doin (requeue ownership unchanged — reaper still owns it).
V2="$TR2/verify"; git clone -q --single-branch --branch journal2 "$BARE2" "$V2" 2>/dev/null
if [ -f "$V2/jobs/doin/overrunjob.md" ] && [ ! -f "$V2/jobs/tada/overrunjob.md" ]; then
  ok "job left in doin (not completed, not requeued by the gardener)"
else
  bad "job not left in doin (doin=$([ -f "$V2/jobs/doin/overrunjob.md" ] && echo y || echo n) tada=$([ -f "$V2/jobs/tada/overrunjob.md" ] && echo y || echo n))"
fi

# ============================================================================
hr; echo "SUBTEST 3 — disable gate: GARDEN_ELAPSED_CONSTANCY_CYCLES=0 → NO escalation"; hr
read -r TR3 BARE3 < <(build_fixture 2 1 0)
trap 'rm -rf "$TR2" "$TR3"' EXIT
run_gardener "$BARE3" echost3 "$TR3" GARDEN_ELAPSED_CONSTANCY_CYCLES=0
CLONE3="$TR3/state/gardeners/1/journal"
if grep -q "elapsed-constancy early-escalation" "$TR3/gardener.log"; then
  bad "escalation fired with the check disabled (GARDEN_ELAPSED_CONSTANCY_CYCLES=0)"
else
  ok "no escalation when disabled (GARDEN_ELAPSED_CONSTANCY_CYCLES=0)"
fi
if [ -e "$CLONE3/inboxes/echost3/gardener.md" ]; then
  bad "inbox escalation created with the check disabled"
else
  ok "no gardener inbox escalation when disabled"
fi

# ============================================================================
hr; echo "SUBTEST 4 — dedup: a prior escalation entry for the base suppresses a second"; hr
read -r TR4 BARE4 < <(build_fixture 2 1 1)
trap 'rm -rf "$TR2" "$TR3" "$TR4"' EXIT
run_gardener "$BARE4" echost4 "$TR4" GARDEN_ELAPSED_CONSTANCY_CYCLES=2
CLONE4="$TR4/state/gardeners/1/journal"
if grep -q "elapsed-constancy early-escalation" "$TR4/gardener.log"; then
  bad "escalation fired again despite a prior overrun-suspect entry for this base"
else
  ok "dedup held: no second escalation when the base was already flagged"
fi
if [ -e "$CLONE4/inboxes/echost4/gardener.md" ]; then
  bad "a second inbox escalation was appended despite the dedup marker"
else
  ok "no duplicate inbox escalation (fires at most once per base)"
fi

# ============================================================================
hr; echo "SUBTEST 5 — not enough cycles: a first-pass job (reap-count 0) escalates NOTHING"; hr
read -r TR5 BARE5 < <(build_fixture 0 0 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5"' EXIT
run_gardener "$BARE5" echost5 "$TR5" GARDEN_ELAPSED_CONSTANCY_CYCLES=2
CLONE5="$TR5/state/gardeners/1/journal"
# Ordinary transient behavior must be intact: transient verdict, NO inbox escalation.
if grep -Eq "looks transient \(rc=1[,)]" "$TR5/gardener.log"; then
  ok "first-pass transient failure still classified transient"
else
  bad "first-pass transient verdict not logged"
fi
if grep -q "elapsed-constancy early-escalation" "$TR5/gardener.log"; then
  bad "escalation fired on a first-pass job (cycle 0 < 2)"
else
  ok "no escalation on a first-pass job (cycle 0 < the 2-cycle floor)"
fi
if [ -e "$CLONE5/inboxes/echost5/gardener.md" ]; then
  bad "inbox escalation created on a first-pass transient failure"
else
  ok "no inbox escalation on a first-pass transient failure (ordinary transient path intact)"
fi

# ============================================================================
hr
echo "elapsed-constancy-classifier-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
