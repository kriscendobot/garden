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
# UNCHANGED through all GARDEN_REAP_DOOM_THRESHOLD (default 5) cycles before the
# reaper's doom counter surfaces it (~5×TTL). Its tell is a near-CONSTANT elapsed
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
# (inbox + kind:error), the EARLY-DOOM overrun counter must be stamped (so the
# reaper dooms after GARDEN_REAP_OVERRUN_THRESHOLD, not the full doom threshold),
# and the job STAYS in doin (requeue ownership unchanged).
# SUBTEST 3 is the disable gate (GARDEN_ELAPSED_CONSTANCY_CYCLES=0 → no escalation).
# SUBTEST 4 is the dedup guard: a prior escalation entry for the base suppresses a
# second. SUBTEST 5 is the not-enough-cycles guard: a first-pass job (reap-count 0)
# with a transient failure escalates NOTHING (ordinary transient behavior intact).
# SUBTEST 6 is the very-short-elapsed floor (GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS): an
# AMBIGUOUS overload-shaped signature that appears BELOW the floor is reclassified a
# REAL deterministic failure outright (a sub-few-second overload is implausible — a
# setup/spec defect, not a self-resolving blip), and floor=0 preserves the old
# behavior. SUBTEST 7 is the explicit-cap EXEMPTION: the first-person session/usage
# cap wording stays transient below the floor (a real cap rejection IS fast — the
# 2026-07-17 incident; is_explicit_cap_signature in common.sh).
#
# Usage: elapsed-constancy-classifier-test.sh
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
    elif [ "$seed_priors" = 2 ]; then
      # VARIED priors: the prior cycles died at a wildly different elapsed than the
      # stub's ~3s, so the trailing window is NOT near-constant and nothing may fire.
      mkdir -p entries/2026/07/01
      printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 0, elapsed=470s); left in doin\n' > entries/2026/07/01/010000Z-progress-gardener-a.md
      printf 'job overrunjob handler exited rc=1 (…); transient handler outage (requeue cycle 1, elapsed=900s); left in doin\n' > entries/2026/07/01/020000Z-progress-gardener-b.md
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
# GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 DISABLES the very-short-elapsed floor so this
# test isolates the elapsed-CONSTANCY axis: the stub's ~3s elapsed would otherwise
# trip the floor and be reclassified a real failure before the constancy window is
# even consulted. The floor is exercised by its own subtest in this file (below).
run_gardener() {
  local BARE="$1" host="$2" TR="$3"; shift 3
  env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 \
      GARDEN="$host" GARDEN_STATE="$TR/state" \
      GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=1 GARDEN_STUB_SLEEP=3 \
      GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 \
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
  ok "elapsed-constancy early-escalation fired at cycle 2 (before the ~5-cycle doom threshold)"
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
# (f) the EARLY-DOOM hint was stamped: the confirming cycle stamps the SAME
# deadline-overrun counter the rc=124 wall-hit path uses, so the reaper dooms this
# job after GARDEN_REAP_OVERRUN_THRESHOLD (1) cycle rather than the full doom
# threshold. deadline_overrun_count reads the counter that landed on the doin body.
if [ -f "$V2/jobs/doin/overrunjob.md" ] && [ "$(deadline_overrun_count "$V2/jobs/doin/overrunjob.md")" -ge 1 ]; then
  ok "early-doom overrun counter stamped on the doin job (deadline_overrun_count=$(deadline_overrun_count "$V2/jobs/doin/overrunjob.md")) — reaper dooms after GARDEN_REAP_OVERRUN_THRESHOLD, not the full threshold"
else
  bad "no early-doom overrun counter on the doin job (constancy path did not stamp it; count=$([ -f "$V2/jobs/doin/overrunjob.md" ] && deadline_overrun_count "$V2/jobs/doin/overrunjob.md" || echo n/a))"
fi
# (g) the commit reason distinguishes the constancy stamp from a plain wall-hit.
# Materialize the log FIRST: under `set -o pipefail` (line 45) a `git log | grep -q`
# fails even on a match — grep -q exits at the first hit, git dies of SIGPIPE (141),
# and pipefail promotes that to the pipeline's status. That is why this case read as
# "commit reason missing" while the very log the failure message printed contained it.
V2LOG="$TR2/verify-log"; git -C "$V2" log --oneline -20 > "$V2LOG"
if grep -q "elapsed-constancy deterministic overrun" "$V2LOG"; then
  ok "early-doom stamp carried the elapsed-constancy commit reason (audit trail honest)"
else
  bad "early-doom stamp commit reason missing/wrong; log: $(git -C "$V2" log --oneline -5 | tr '\n' '|')"
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
hr; echo "SUBTEST 6 — very-short-elapsed floor: a sub-floor AMBIGUOUS transient signature is reclassified a REAL failure"; hr
# A GENUINE overload/5xx cannot trip in a couple of seconds. The stub emits an
# AMBIGUOUS overload-shaped signature but exits in only ~3s; with
# GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS raised ABOVE that elapsed, the signature is too
# fast to be a real overload and is reclassified a DETERMINISTIC real failure
# OUTRIGHT — escalated NOW (a first-pass job, no requeue history, so NOTHING about
# cross-cycle constancy is consulted). This is the fix for the four 1–2s jobs of the
# 2026-07-03 batch that were mis-held transient. (The EXPLICIT session-cap wording is
# EXEMPT from the floor — see the subtest below; the floor bites only the ambiguous
# overload-shaped alternatives, hence GARDEN_STUB_MESSAGE here.)
read -r TR6 BARE6 < <(build_fixture 0 0 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5" "$TR6"' EXIT
run_gardener "$BARE6" echost6 "$TR6" GARDEN_ELAPSED_CONSTANCY_CYCLES=2 GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=30 \
  GARDEN_STUB_MESSAGE="Error: overloaded_error (529)"
CLONE6="$TR6/state/gardeners/1/journal"
# (a) the floor tripped: the reclassification log line names the too-fast signature.
if grep -q "too fast for a genuine usage/session cap" "$TR6/gardener.log"; then
  ok "sub-floor signature reclassified a real failure (floor tripped at ~3s < 30s)"
else
  bad "floor did NOT trip; log: $(grep -i 'transient\|floor\|FAILED\|too fast' "$TR6/gardener.log" | tail -5)"
fi
# (b) NOT classified transient (the whole point — it no longer takes the transient path).
if grep -Eq "looks transient \(rc=1[,)]" "$TR6/gardener.log"; then
  bad "sub-floor signature STILL logged transient (floor did not reclassify it)"
else
  ok "sub-floor signature NOT on the transient path"
fi
# (c) a REAL-failure inbox escalation WAS created (surfaces the setup/spec defect now).
if [ -e "$CLONE6/inboxes/echost6/gardener.md" ] && grep -q "handler-nonzero" "$CLONE6/inboxes/echost6/gardener.md"; then
  ok "real-failure escalation created (handler-nonzero) — the defect surfaces immediately, not after the doom cycle"
else
  bad "no real-failure inbox escalation for the sub-floor signature (file=$([ -e "$CLONE6/inboxes/echost6/gardener.md" ] && echo y || echo n))"
fi
# (d) floor=0 DISABLES it: the same fast signature stays transient (regression: the
# unconditional-transient behavior is preserved when the floor is off).
read -r TR7 BARE7 < <(build_fixture 0 0 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5" "$TR6" "$TR7"' EXIT
run_gardener "$BARE7" echost7 "$TR7" GARDEN_ELAPSED_CONSTANCY_CYCLES=2 GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 \
  GARDEN_STUB_MESSAGE="Error: overloaded_error (529)"
CLONE7="$TR7/state/gardeners/1/journal"
if grep -Eq "looks transient \(rc=1[,)]" "$TR7/gardener.log" && [ ! -e "$CLONE7/inboxes/echost7/gardener.md" ]; then
  ok "floor=0 disables the reclassification (fast signature stays transient, no escalation)"
else
  bad "floor=0 did not preserve transient behavior (transient=$(grep -Eq "looks transient" "$TR7/gardener.log" && echo y || echo n) inbox=$([ -e "$CLONE7/inboxes/echost7/gardener.md" ] && echo y || echo n))"
fi

# ============================================================================
hr; echo "SUBTEST 7 — explicit-cap exemption: a sub-floor EXPLICIT session-cap wording stays TRANSIENT"; hr
# The floor's "too fast for a real cap" premise is FALSE for the first-person
# session/usage-cap wordings: a real cap rejection is one fast API round trip
# (2026-07-17 00:43Z, rc=1 after 2s, "You've hit your session limit · resets 2am
# (UTC)" — misclassified deterministic twice, killing a review job and a press claim
# for hours). The stub's DEFAULT message is exactly that wording; with the floor
# raised above the ~3s elapsed, is_explicit_cap_signature must keep it transient —
# no reclassification, no inbox escalation, job left in doin for the reaper.
read -r TR8 BARE8 < <(build_fixture 0 0 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5" "$TR6" "$TR7" "$TR8"' EXIT
run_gardener "$BARE8" echost8 "$TR8" GARDEN_ELAPSED_CONSTANCY_CYCLES=2 GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=30
CLONE8="$TR8/state/gardeners/1/journal"
# (a) the exemption log line fired (the floor was consulted and bypassed by content).
if grep -q "EXPLICIT session/usage-cap wording" "$TR8/gardener.log"; then
  ok "exemption fired: sub-floor explicit-cap capture kept transient by content"
else
  bad "exemption did NOT fire; log: $(grep -i 'transient\|floor\|too fast\|FAILED' "$TR8/gardener.log" | tail -5)"
fi
# (b) classified transient (the transient-outage verdict line), NOT reclassified.
if grep -Eq "looks transient \(rc=1[,)]" "$TR8/gardener.log" && ! grep -q "too fast for a genuine usage/session cap" "$TR8/gardener.log"; then
  ok "explicit-cap capture on the transient path (no 'too fast' reclassification)"
else
  bad "explicit-cap capture reclassified or not transient (transient=$(grep -Eq "looks transient" "$TR8/gardener.log" && echo y || echo n) toofast=$(grep -q "too fast" "$TR8/gardener.log" && echo y || echo n))"
fi
# (c) NO real-failure inbox escalation (the 2026-07-17 false escalation is the regression).
if [ -e "$CLONE8/inboxes/echost8/gardener.md" ]; then
  bad "inbox escalation created for a genuine sub-floor session cap (the 2026-07-17 misclassification)"
else
  ok "no inbox escalation — genuine cap left for the reaper's requeue past the reset"
fi

# ============================================================================
hr; echo "SUBTEST 9 — SELF-SAMPLE regression: reap-count 2 with NO prior notes must NOT confirm constancy"; hr
# THE 2026-07-28 DEFECT. The check reads the prior cycles' elapsed out of $CLONE and
# appends this cycle's elapsed itself. But this cycle's OWN progress note is written
# (and pushed) BEFORE that read, and stamp_reap_now_hint's sync_clone then hard-resets
# $CLONE onto the origin tip that now CONTAINS it — so the "prior" series ended with
# THIS cycle's elapsed and the appended current value duplicated it. The window was
# [current, current]: bit-identical by construction, so constancy was ALWAYS confirmed.
# On 2026-07-28 that stamped the early-doom overrun counter on nine unrelated jobs in
# eight minutes on one host — each reported as a perfect pair at a DIFFERENT value
# (12,12s / 61,61s / 1403,1403s …) — and at GARDEN_REAP_OVERRUN_THRESHOLD=1 the reaper
# doom-parked four of them, one of which had only ever run ONE cycle.
#
# This fixture is exactly that shape: the cycle floor is CLEARED (reap-count 2) but
# there are NO prior notes at all, so a correct window can never be full. Nothing may
# escalate, and — the damaging half — the early-doom counter must NOT be stamped.
read -r TR9 BARE9 < <(build_fixture 2 0 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5" "$TR6" "$TR7" "$TR8" "$TR9"' EXIT
run_gardener "$BARE9" echost9 "$TR9" GARDEN_ELAPSED_CONSTANCY_CYCLES=2
CLONE9="$TR9/state/gardeners/1/journal"
V9="$TR9/verify"; git clone -q --single-branch --branch journal2 "$BARE9" "$V9" 2>/dev/null
# (a) the base transient classification is untouched.
if grep -Eq "looks transient \(rc=1[,)]" "$TR9/gardener.log"; then
  ok "handler failure still classified transient (rc=1)"
else
  bad "transient verdict not logged; log: $(grep -i 'transient\|constancy\|FAILED' "$TR9/gardener.log" | tail -3)"
fi
# (b) NO escalation: a single cycle cannot evidence a cross-cycle constant.
if grep -q "elapsed-constancy early-escalation" "$TR9/gardener.log"; then
  bad "SELF-SAMPLE: escalation fired with ZERO prior cycles (this cycle's own note counted as its own predecessor)"
else
  ok "no escalation with zero prior cycles (the window was never full)"
fi
# (c) the damaging half: NO early-doom overrun counter stamped.
if [ -f "$V9/jobs/doin/overrunjob.md" ] && [ "$(deadline_overrun_count "$V9/jobs/doin/overrunjob.md")" -ge 1 ]; then
  bad "SELF-SAMPLE: early-doom overrun counter stamped with zero prior cycles — the reaper would doom this job at GARDEN_REAP_OVERRUN_THRESHOLD=1 on its FIRST run"
else
  ok "no early-doom overrun counter stamped (job cannot be doom-parked on its first cycle)"
fi
# (d) no inbox escalation either.
if [ -e "$CLONE9/inboxes/echost9/gardener.md" ]; then
  bad "inbox escalation created with zero prior cycles"
else
  ok "no gardener inbox escalation with zero prior cycles"
fi

# ============================================================================
hr; echo "SUBTEST 10 — VARIED priors: a genuinely varied elapsed series must NOT confirm constancy"; hr
# The complement of SUBTEST 2: same cleared cycle floor, but the prior cycles died at
# 470s and 900s while this one dies at ~3s. A correct trailing window (900, 3) is
# nowhere near constant, so neither the escalation nor the early-doom stamp may
# fire. Under the self-sample defect the window was (3, 3) and BOTH did.
read -r TR10 BARE10 < <(build_fixture 2 2 0)
trap 'rm -rf "$TR2" "$TR3" "$TR4" "$TR5" "$TR6" "$TR7" "$TR8" "$TR9" "$TR10"' EXIT
run_gardener "$BARE10" echost10 "$TR10" GARDEN_ELAPSED_CONSTANCY_CYCLES=2
CLONE10="$TR10/state/gardeners/1/journal"
V10="$TR10/verify"; git clone -q --single-branch --branch journal2 "$BARE10" "$V10" 2>/dev/null
if grep -q "elapsed-constancy early-escalation" "$TR10/gardener.log"; then
  bad "SELF-SAMPLE: escalation fired on a VARIED series (470,900 → 3s)"
else
  ok "no escalation on a varied elapsed series (470,900 → 3s)"
fi
if [ -f "$V10/jobs/doin/overrunjob.md" ] && [ "$(deadline_overrun_count "$V10/jobs/doin/overrunjob.md")" -ge 1 ]; then
  bad "SELF-SAMPLE: early-doom overrun counter stamped on a VARIED series"
else
  ok "no early-doom overrun counter stamped on a varied elapsed series"
fi
if [ -e "$CLONE10/inboxes/echost10/gardener.md" ]; then
  bad "inbox escalation created on a varied elapsed series"
else
  ok "no gardener inbox escalation on a varied elapsed series"
fi

# ============================================================================
hr
echo "elapsed-constancy-classifier-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
