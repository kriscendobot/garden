#!/bin/bash
# claude-session-limit-classifier-test.sh — regression guard for the
# transient-signature branch of the gardener handler-failure classifier
# (gardener.sh:311, is_transient_claude_signature in common.sh).
#
# Regression: on 2026-07-01T00:26–00:50Z, 9 unrelated gardener jobs on endolinbot2
# all failed with the byte-identical inner-`claude -p` capture
#   "You've hit your session limit · resets 1:10am (UTC)"
# (blob 35b3d8ab…). That wording matched NONE of the then-current transient
# alternatives (overloaded|rate-limit|connection error|429|5xx|api-error|
# econnreset|etimedout), so each fell through to the real-failure branch
# (gardener.sh:357), was escalated to the gardener inbox as a lane-0
# handler-nonzero defect, and left in doin — where the reaper requeues it to
# re-fail identically until the cap resets, doom-counting toward a FALSE
# maintainer escalation. A Claude Code session/usage cap that names its own reset
# time is the definitive self-resolving transient: requeuing past the reset
# succeeds. The fix extends the canonical GARDEN_TRANSIENT_CLAUDE_SIGNATURES set
# (common.sh — the single source of truth both gardener.sh and follow-up-claude.sh
# consume) to match the cap wording case-insensitively.
#
# SUBTEST 1 drives the pure helper is_transient_claude_signature (common.sh)
# directly on the EXACT incident string and a few wording variants, and pins that
# an ordinary crash is still classified a real failure. SUBTEST 2 is an integration
# test: it runs the real gardener.sh against a stub that emits the exact string and
# exits rc=1 (a non-signal, non-timeout, non-offline code — the path where only the
# transient-signature match can rescue it), and asserts the job is logged as a
# transient outage (no inbox escalation, kind:progress not kind:error, left in doin
# for the reaper's requeue).
#
# Usage: claude-session-limit-classifier-test.sh
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Scrub ambient fleet env (a live gardener running this test as a board job would
# otherwise splice its own GARDEN_*/JOURNAL_*/SELF_HEAL_* state — clone, remote,
# offline rc, and notably GARDEN_TRANSIENT_CLAUDE_SIGNATURES — underneath the
# fixture; see run-test.sh § hermetic baseline).
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

# shellcheck source=../common.sh
source "$JOBS/common.sh"

# ============================================================================
hr; echo "SUBTEST 1 — is_transient_claude_signature: the session-cap wording is transient"; hr
INCIDENT="You've hit your session limit · resets 1:10am (UTC)"
assert_transient() { if is_transient_claude_signature "$1"; then ok "transient: $2"; else bad "NOT transient (expected transient): $2 — [$1]"; fi; }
assert_real()      { if is_transient_claude_signature "$1"; then bad "transient (expected real failure): $2 — [$1]"; else ok "real failure: $2"; fi; }

# The exact incident capture (blob 35b3d8ab…), verbatim.
assert_transient "$INCIDENT" "exact incident string: session limit + reset time"
# Case-insensitivity (grep -qiE): the classifier lowercases nothing itself.
assert_transient "YOU'VE HIT YOUR SESSION LIMIT · RESETS 1:10AM (UTC)" "uppercased incident string"
# Usage-cap wording (the other Claude Code cap phrasing).
assert_transient "You've hit your usage limit · resets 3:00pm (UTC)" "usage-limit wording + reset time"
# The 'limit reached/reset' shapes and the 5-hour framing.
assert_transient "session limit reached" "'session limit reached'"
assert_transient "usage limit reset at 12:00am" "'usage limit reset'"
assert_transient "5-hour limit reached" "'5-hour limit reached'"
# A bare 'resets H:MM… (UTC)' reset clause (the usage-cap wording that leads with
# the reset) — the reset-time clause alone is enough.
assert_transient "resets 9:45pm (UTC)" "'resets … (utc)' clause alone"
# The prior alternatives must STILL classify transient (no drift).
assert_transient "Error: overloaded_error (529)" "pre-existing: overloaded"
assert_transient "connection error: ECONNRESET" "pre-existing: connection error / econnreset"
# A genuine crash / malformed-prompt defect must NOT be swept up as transient.
assert_real "TypeError: cannot read properties of undefined (reading 'x')" "an ordinary crash is a real failure"
assert_real "no such file or directory: /home/kris/nope" "a missing-path defect is a real failure"

# ============================================================================
hr; echo "SUBTEST 1b — is_explicit_cap_signature: cap wordings only (the floor-exempt subset)"; hr
# The explicit-cap subset (common.sh) exempts first-person cap statements from
# gardener.sh's GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS floor (a real cap rejection is one
# fast API round trip — the 2026-07-17 00:43Z 2s incident). It must match the cap
# wordings and NOT the ambiguous overload-shaped alternatives, which keep the floor.
assert_cap()    { if is_explicit_cap_signature "$1"; then ok "explicit cap: $2"; else bad "NOT explicit cap (expected match): $2 — [$1]"; fi; }
assert_notcap() { if is_explicit_cap_signature "$1"; then bad "explicit cap (expected NO match): $2 — [$1]"; else ok "not explicit cap: $2"; fi; }
assert_cap "$INCIDENT" "exact 2026-07-01 incident string"
assert_cap "You've hit your session limit · resets 2am (UTC)" "exact 2026-07-17 incident string"
assert_cap "You've hit your usage limit · resets 3:00pm (UTC)" "usage-limit wording"
assert_cap "5-hour limit reached" "'5-hour limit reached'"
assert_cap "resets 9:45pm (UTC)" "'resets … (utc)' clause alone"
assert_notcap "Error: overloaded_error (529)" "overloaded stays floor-gated"
assert_notcap "connection error: ECONNRESET" "connection drop stays floor-gated"
assert_notcap "api error: 429 rate limit" "rate-limit/429 stays floor-gated"
# Subset invariant: every explicit-cap match is also a transient match.
assert_transient "You've hit your session limit · resets 2am (UTC)" "explicit-cap subset ⊆ transient set"

# ============================================================================
hr; echo "SUBTEST 2 — integration: exact capture + rc=1 → transient, no escalation"; hr
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-sessioncap.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
BARE="$TR/journal.git"; BRANCH=journal2
git_id=(-c user.name=test -c user.email=test@localhost)

# Seed a throwaway origin with the board structure + one job.
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# capjob\n\ndo the work for capjob\n' > "jobs/todo/capjob.md" )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"

# Run the REAL gardener.sh: oneshot, stub handler that emits the exact session-cap
# string on stdout (folded into $capture) then exits rc=1 — a non-signal,
# non-timeout, non-offline code, so ONLY the transient-signature match can rescue
# it from the real-failure escalation. GARDEN_STUB_RC=1 is the stub default; set it
# explicitly for clarity.
# GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 DISABLES the very-short-elapsed floor: this
# stub exits near-instantly, so with the floor live the fast signature would be
# reclassified a real failure and defeat this test's purpose (proving the SIGNATURE
# match rescues the job to transient). The floor is a SEPARATE classification axis
# with its own regression guard in elapsed-constancy-classifier-test.sh.
env GARDEN="caphost" GARDEN_STATE="$TR/state" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=1 \
    GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=0 \
    GARDEN_JOB_HANDLER="$HERE/claude-session-limit-handler-stub.sh" \
    "$JOBS/gardener.sh" 1 > "$TR/gardener.log" 2>&1 || true

CLONE="$TR/state/gardeners/1/journal"

# (a) classified TRANSIENT: the gardener logged the transient-outage verdict line.
# The transient branch's log line reads "handler outage for '<base>' looks
# transient (rc=1, …)".
if grep -Eq "looks transient \(rc=1[,)]" "$TR/gardener.log"; then
  ok "rc=1 with the session-cap capture logged as a transient outage"
else
  bad "rc=1 session-cap capture NOT logged transient; log: $(grep -i 'handler\|transient\|FAILED' "$TR/gardener.log" | tail -3)"
fi

# (b) NO inbox escalation: report-error.sh appends to <clone>/inboxes/<host>/gardener.md;
# a transient classification must NOT create it (this is the false lane-0
# handler-nonzero escalation the fix prevents).
if [ -e "$CLONE/inboxes/caphost/gardener.md" ]; then
  bad "gardener inbox escalation file created — the session cap was falsely escalated as a defect"
else
  ok "no gardener inbox escalation file (session cap not escalated)"
fi

# (c) NO kind:error journal entry for the failed handler (the loud path emits
# journal-entry.sh error); a transient note is kind:progress instead.
nerr=$(grep -rl 'handler FAILED' "$CLONE/entries" 2>/dev/null | grep -c 'error' || true)
if [ "${nerr:-0}" -eq 0 ]; then
  ok "no kind:error journal entry for the session-capped handler"
else
  bad "$nerr kind:error journal entr(y/ies) emitted for a session-capped handler"
fi

# (d) the job stays in doin for the reaper's requeue (not completed to tada,
# not escalated away).
V="$TR/verify"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V" 2>/dev/null
if [ -f "$V/jobs/doin/capjob.md" ] && [ ! -f "$V/jobs/tada/capjob.md" ]; then
  ok "job left in doin (for reaper requeue), not completed to tada"
else
  bad "job not left in doin (doin=$([ -f "$V/jobs/doin/capjob.md" ] && echo y || echo n) tada=$([ -f "$V/jobs/tada/capjob.md" ] && echo y || echo n))"
fi

# ============================================================================
hr; echo "SUBTEST 3 — CLOBBER fail-safe: is_explicit_cap_signature UNDEFINED → still transient"; hr
# Regression: a0cd3eae13 (2026-07-21) rewrote common.sh from a stale base and
# deleted is_explicit_cap_signature outright (restored 2026-07-28 by da2572a260).
# A call to an undefined function under `if` is not a crash — bash prints
# `command not found`, returns 127, and the branch simply reads FALSE — so the
# floor's cap EXEMPTION silently vanished and every fast-dying capped handler was
# reclassified a DETERMINISTIC defect. That lands on the real-failure branch,
# which (unlike the transient branch) leaves the claim in doin with NO reap-now
# hint, so each cycle stranded the job for the full GARDEN_CLAIM_TTL (4h):
# endojs-endo-but-for-bots-pr882-shepherd reached `garden-reaped: 4` and ~12.5h of
# latency on an already-green PR, and the fleet emitted 243 kind:error escalations
# over 2026-07-28/29. gardener.sh now probes the helper with `declare -F` and fails
# SAFE to transient when it is absent. This subtest reproduces the clobber against
# the REAL gardener.sh — a mirrored scripts/jobs/ whose common.sh has the function
# stripped — with the elapsed floor LIVE, and pins the fail-safe.
CR="$TR/clobber"; mkdir -p "$CR/root/scripts"
# Mirror scripts/jobs/ by symlink so every sibling script is the real one, then
# substitute a common.sh with is_explicit_cap_signature excised.
mkdir -p "$CR/root/scripts/jobs"
for p in "$JOBS"/* "$JOBS"/.[!.]*; do
  [ -e "$p" ] || continue
  [ "$(basename "$p")" = common.sh ] && continue
  ln -s "$p" "$CR/root/scripts/jobs/$(basename "$p")"
done
ln -s "$(cd "$JOBS/../.." && pwd)/skills" "$CR/root/skills"
# Excise the function body: from its `name() {` header to the closing `}` at
# column 0 (the file's uniform style for top-level definitions).
awk '/^is_explicit_cap_signature\(\)/ {skip=1} skip && /^\}/ {skip=0; next} !skip' \
  "$JOBS/common.sh" > "$CR/root/scripts/jobs/common.sh"
if grep -q '^is_explicit_cap_signature()' "$CR/root/scripts/jobs/common.sh"; then
  bad "fixture setup: is_explicit_cap_signature was NOT stripped from the mirrored common.sh"
else
  ok "fixture: mirrored common.sh has is_explicit_cap_signature stripped (the a0cd3eae13 clobber)"
fi

# A second throwaway origin, same shape as SUBTEST 2's.
CBARE="$CR/journal.git"; git init -q --bare "$CBARE"
CSEED="$CR/seed"; git init -q "$CSEED"; git -C "$CSEED" checkout -q -b "$BRANCH"
( cd "$CSEED"
  mkdir -p jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors
  for d in jobs/todo jobs/doin jobs/tada work repos msgs hosts entries schedules cursors; do touch "$d/.gitkeep"; done
  printf '# clobberjob\n\ndo the work for clobberjob\n' > "jobs/todo/clobberjob.md" )
git -C "$CSEED" add -A
git -C "$CSEED" "${git_id[@]}" commit -q -m "seed: 1 job + structure"
git -C "$CSEED" remote add origin "$CBARE"
git -C "$CSEED" push -q -u origin "$BRANCH"

# The floor is LIVE here (unlike SUBTEST 2, which disables it): the stub exits in
# well under 5s with an EXPLICIT cap wording, so the ONLY thing that can keep this
# transient is the exemption — or, with the exemption's helper missing, the
# fail-safe. Pre-fix this run classified real and escalated.
env GARDEN="clobberhost" GARDEN_ROOT="$CR/root" GARDEN_STATE="$CR/state" \
    JOURNAL_REMOTE="$CBARE" JOURNAL_BRANCH="$BRANCH" \
    GARDEN_ONESHOT=1 GARDEN_IDLE_SLEEP=1 GARDEN_STUB_RC=1 \
    GARDEN_MIN_PLAUSIBLE_OVERRUN_SECS=5 \
    GARDEN_JOB_HANDLER="$HERE/claude-session-limit-handler-stub.sh" \
    "$CR/root/scripts/jobs/gardener.sh" 1 > "$CR/gardener.log" 2>&1 || true

CCLONE="$CR/state/gardeners/1/journal"

# (a) the fail-safe fired and NAMED the missing helper (greppable, not a bare
# bash `command not found` buried in the unit log).
if grep -q "is_explicit_cap_signature is UNDEFINED" "$CR/gardener.log"; then
  ok "missing helper surfaced by name with the fail-safe verdict"
else
  bad "fail-safe line absent; log: $(grep -i 'transient\|UNDEFINED\|FAILED' "$CR/gardener.log" | tail -3)"
fi

# (b) THE REGRESSION: classified transient despite the sub-floor elapsed.
if grep -Eq "looks transient \(rc=1[,)]" "$CR/gardener.log"; then
  ok "clobbered common.sh still classifies a sub-floor cap as transient (fail-safe)"
else
  bad "clobbered common.sh reclassified a sub-floor cap as a REAL failure (the pr882 shape); log: $(grep -i 'transient\|DETERMINISTIC\|FAILED' "$CR/gardener.log" | tail -3)"
fi

# (c) no false lane-0 defect escalation (the 243-entry flood).
if [ -e "$CCLONE/inboxes/clobberhost/gardener.md" ]; then
  bad "gardener inbox escalation created — the missing helper still produces a false defect escalation"
else
  ok "no gardener inbox escalation under the clobber"
fi

# (d) the job stays in doin for the reaper, as every transient requeue does.
CV="$CR/verify"; git clone -q --single-branch --branch "$BRANCH" "$CBARE" "$CV" 2>/dev/null
if [ -f "$CV/jobs/doin/clobberjob.md" ] && [ ! -f "$CV/jobs/tada/clobberjob.md" ]; then
  ok "job left in doin under the clobber (for reaper requeue), not completed to tada"
else
  bad "job not left in doin (doin=$([ -f "$CV/jobs/doin/clobberjob.md" ] && echo y || echo n) tada=$([ -f "$CV/jobs/tada/clobberjob.md" ] && echo y || echo n))"
fi

hr
echo "RESULTS: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
