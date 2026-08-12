#!/bin/bash
# orchestrate-test.sh — validate the orchestration-job pattern on a throwaway
# journal: a deterministic watcher (orchestrate.sh) that sequences a multi-part
# job's parked child sub-jobs into todo/ and watches them to completion.
#
# Subtests (all hermetic; no systemd, no network — a local bare journal):
#   1. SERIAL     — children promoted ONE AT A TIME, each only after the prior
#                   reaches jobs/tada/; the orchestration completes when all do.
#   2. PARALLEL   — all children promoted at once on the first tick.
#   3. HALT       — a child that FAILS (vanishes without tada) halts a serial run
#                   (policy=halt): the next child is NOT promoted, downstream
#                   parked children are swept, and the failure surfaces to the
#                   maintainer — not a silent stall.
#   4. CONTINUE   — the same failure with policy=continue proceeds to the next
#                   child rather than halting.
#   5. STALL       — a NON-PRODUCTIVE requeue streak that EXCEEDS
#                   GARDEN_ORCH_STALL_REQUEUE_LIMIT, or an expired handler budget, is
#                   a deterministic failed child; a requeue within the limit, or one
#                   carrying the productive-cycle hint, stays active (not endless
#                   active, not a first-requeue false halt).
#   6. BUDGET      — fresh CostRecord aggregation gates serial promotion, fails
#                   closed, preserves the remainder, reports unused budget, and
#                   supports a separately-budgeted resume.
#   7. PRODUCTIVE  — a requeued child that advanced a per-job worktree HEAD (the
#                   productive-cycle hint) stays active and advances its reap baseline.
#   8. SERIAL GATE — a serial run never promotes child N+1 while child N still
#                   occupies jobs/todo or jobs/doin (at most one child in flight).
#
# Usage: orchestrate-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-orch-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: a live gardener may invoke this test with the fleet's own
# GARDEN_*/JOURNAL_* exported (see run-test.sh). Scrub them so ONLY the throwaway
# $TR settings are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch usage work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch usage work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + orch structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# common env pointing every script at the throwaway journal
export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
# keep pushes fast and quiet
export GARDEN_POST_ATTEMPTS=50
# shellcheck source=../common.sh
source "$JOBS/common.sh"

# --- board inspection helpers (fresh clone each call) -----------------------
V="$TR/verify"
board() {  # board <subdir> → basenames present (no .gitkeep, no .md)
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  ls -1 "$V/$1" 2>/dev/null | grep -v -x '.gitkeep' | sed 's/\.md$//' | sort | tr '\n' ' '
}
in_dir() { board "$1" | tr ' ' '\n' | grep -qx "$2"; }   # in_dir <subdir> <base>

# Simulate a gardener COMPLETING a child: remove it from todo/doin and write a
# tada report under the same base.
complete_child() {  # complete_child <base>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  printf '# %s done\n\nwork complete\n' "$1" > "$wt/jobs/tada/$1.md"
  git -C "$wt" add "jobs/tada/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# Simulate a child FAILING: the reaper doomed/dropped it — it vanishes from the
# board WITHOUT a tada report.
fail_child() {  # fail_child <base>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  git -C "$wt" "${git_id[@]}" commit -q -m "doom-drop($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# Append a literal CostRecord (or malformed fixture text) to one child's ledger.
append_usage() {  # append_usage <base> <line>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  printf '%s\n' "$2" >> "$wt/usage/$1.jsonl"
  git -C "$wt" add "usage/$1.jsonl"
  git -C "$wt" "${git_id[@]}" commit -q -m "usage($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

tick() { "$JOBS/orchestrate.sh" >"$TR/tick.log" 2>&1 || { echo "  (orchestrate.sh rc=$? — see $TR/tick.log)"; cat "$TR/tick.log"; }; }

# ============================================================================
hr; echo "SUBTEST 0 — FAILURE VERDICT CONTRACT: decorated legacy, frontmatter, and prose mention"; hr
decorated="$TR/decorated-report.md"
frontmatter="$TR/frontmatter-report.md"
mention="$TR/prose-mention-report.md"
bullet="$TR/bulleted-report.md"
printf '%s\n' \
  'The precondition gate correctly halted this job. Here is my report.' \
  '' \
  '---' \
  '' \
  '## Botanist sweep — HALTED at precondition (deploy is the blocker)' \
  '' \
  '**Outcome: `orchestration-failed: true`** — this is the correct disposition …' \
  > "$decorated"
printf '%s\n' '---' 'orchestration-failed: true' '---' '# clean stamped report' > "$frontmatter"
printf '%s\n' \
  'The job body told the child to end the job with `orchestration-failed: true` in the report.' \
  > "$mention"
printf '%s\n' '  - **`orchestration-failed: yes`**' > "$bullet"

tada_failed "$decorated" \
  && ok "decorated Outcome verdict from the real incident is classified failed" \
  || bad "decorated Outcome verdict was missed"
tada_failed "$frontmatter" \
  && ok "clean leading-frontmatter declaration is classified failed" \
  || bad "leading-frontmatter declaration was missed"
tada_failed "$mention" \
  && bad "ordinary prose mentioning the token was misclassified failed" \
  || ok "ordinary prose mentioning the token does NOT declare failure"
tada_failed "$bullet" \
  && ok "leading whitespace plus list/emphasis/backtick decoration is classified failed" \
  || bad "bulleted decorated verdict was missed"

# ============================================================================
hr; echo "SUBTEST 1 — SERIAL: promote one child at a time, in order"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-serial s-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-serial s-b >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-serial s-c >/dev/null
"$JOBS/post-orchestration.sh" --serial orch-serial s-a s-b s-c >/dev/null

tick   # should promote s-a only
{ in_dir jobs/todo s-a && ! in_dir jobs/todo s-b && ! in_dir jobs/todo s-c \
  && in_dir jobs/plan s-b && in_dir jobs/plan s-c; } \
  && ok "tick 1: only s-a promoted (s-b, s-c still parked)" \
  || bad "tick 1 promoted: todo=[$(board jobs/todo)] plan=[$(board jobs/plan)]"

tick   # s-a still in flight (active) → no advance
{ ! in_dir jobs/todo s-b; } && ok "tick 2: s-b NOT promoted while s-a in flight" \
  || bad "tick 2: s-b promoted early (todo=[$(board jobs/todo)])"

complete_child s-a
tick   # s-a done → promote s-b
{ in_dir jobs/tada s-a && in_dir jobs/todo s-b && ! in_dir jobs/todo s-c && in_dir jobs/plan s-c; } \
  && ok "tick 3: s-a done → s-b promoted (s-c still parked)" \
  || bad "tick 3: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] plan=[$(board jobs/plan)]"

complete_child s-b
tick   # s-b done → promote s-c
{ in_dir jobs/todo s-c; } && ok "tick 4: s-b done → s-c promoted" \
  || bad "tick 4: s-c not promoted (todo=[$(board jobs/todo)])"

complete_child s-c
tick   # all done → orchestration completes
{ in_dir jobs/tada orch-serial && ! in_dir jobs/orch orch-serial; } \
  && ok "tick 5: all children done → orchestration completed (tada/orch-serial, record removed)" \
  || bad "tick 5: orch not completed (tada=[$(board jobs/tada)] orch=[$(board jobs/orch)])"
{ grep -q '^Child dispositions:' "$V/jobs/tada/orch-serial.md" \
  && grep -q '^- s-a: tada report present; no machine-readable failure declaration detected$' "$V/jobs/tada/orch-serial.md" \
  && ! grep -q '^All children succeeded\.$' "$V/jobs/tada/orch-serial.md"; } \
  && ok "completion report restates scoped child dispositions instead of blanket success" \
  || bad "completion report retained a confident blanket-success assertion"

# ============================================================================
hr; echo "SUBTEST 2 — PARALLEL: promote all children at once"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-par p-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-par p-b >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-par p-c >/dev/null
"$JOBS/post-orchestration.sh" --parallel orch-par p-a p-b p-c >/dev/null

tick   # promote ALL three at once
{ in_dir jobs/todo p-a && in_dir jobs/todo p-b && in_dir jobs/todo p-c \
  && ! in_dir jobs/plan p-a && ! in_dir jobs/plan p-b && ! in_dir jobs/plan p-c; } \
  && ok "tick 1: all 3 children promoted at once" \
  || bad "tick 1: not all promoted (todo=[$(board jobs/todo)] plan=[$(board jobs/plan)])"

tick   # none done yet → still waiting, not complete
{ ! in_dir jobs/tada orch-par && in_dir jobs/orch orch-par; } \
  && ok "tick 2: orchestration still running (no child done yet)" \
  || bad "tick 2: orch completed prematurely"

complete_child p-a; complete_child p-b; complete_child p-c
tick   # all done → complete
{ in_dir jobs/tada orch-par && ! in_dir jobs/orch orch-par; } \
  && ok "tick 3: all children done → orchestration completed" \
  || bad "tick 3: orch not completed (tada=[$(board jobs/tada)] orch=[$(board jobs/orch)])"

# ============================================================================
hr; echo "SUBTEST 3 — HALT: a serial child failure halts the run (policy=halt)"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-halt h-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-halt h-b >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-halt h-c >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-halt h-a h-b h-c >/dev/null

tick                      # promote h-a
in_dir jobs/todo h-a || bad "halt setup: h-a not promoted"
fail_child h-a            # h-a vanishes without tada (doomed)
tick                      # detect failure → HALT

halt_ok=1
in_dir jobs/todo h-b && halt_ok=0          # h-b must NOT be promoted
in_dir jobs/plan h-b && halt_ok=0          # h-b swept (not left parked)
in_dir jobs/plan h-c && halt_ok=0          # h-c swept
in_dir jobs/orch orch-halt && halt_ok=0    # orchestration record removed
in_dir jobs/tada orch-halt || halt_ok=0    # halt summary written
{ [ "$halt_ok" -eq 1 ]; } \
  && ok "failed child halted the run: h-b NOT promoted, downstream swept, orchestration closed" \
  || bad "halt: todo=[$(board jobs/todo)] plan=[$(board jobs/plan)] orch=[$(board jobs/orch)] tada=[$(board jobs/tada)]"

# the failure surfaced to the maintainer inbox (not a silent stall)
note_ok=0; grep -rqi 'halt' "$V/inbox/maintainer/unread" 2>/dev/null && note_ok=1
[ "$note_ok" -eq 1 ] && ok "halt surfaced to the maintainer inbox" \
  || bad "halt did not surface a maintainer note (inbox: $(ls "$V/inbox/maintainer/unread" 2>/dev/null))"

# the halt summary carries the failure marker
grep -qi '^orchestration-status: halted' "$V/jobs/tada/orch-halt.md" 2>/dev/null \
  && ok "halt summary marks orchestration-status: halted" \
  || bad "halt summary missing status marker"

# ============================================================================
hr; echo "SUBTEST 4 — CONTINUE: a serial child failure proceeds (policy=continue)"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-cont c-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-cont c-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure continue orch-cont c-a c-b >/dev/null

tick                      # promote c-a
in_dir jobs/todo c-a || bad "continue setup: c-a not promoted"
fail_child c-a            # c-a fails
tick                      # policy=continue → promote c-b despite the failure
{ in_dir jobs/todo c-b; } \
  && ok "failed child did NOT halt: c-b promoted (policy=continue)" \
  || bad "continue: c-b not promoted (todo=[$(board jobs/todo)])"

complete_child c-b
tick                      # all terminal → complete-with-failures
{ in_dir jobs/tada orch-cont && ! in_dir jobs/orch orch-cont; } \
  && ok "orchestration completed after continue-past-failure" \
  || bad "continue: orch not completed (tada=[$(board jobs/tada)] orch=[$(board jobs/orch)])"
grep -qi 'complete-with-failures' "$V/jobs/tada/orch-cont.md" 2>/dev/null \
  && ok "completion summary records the continued-past failure" \
  || bad "completion summary missing complete-with-failures marker"

# ============================================================================
hr; echo "SUBTEST 5 — DOOM-PARK: a doomed child parked in plan/ is treated as failed, not re-promoted"; hr
# The reaper no longer DROPS a doomed child; it PARKS it in plan/<child>.md under
# a held gate carrying `doomed: true` (reaper.sh doom branch). The watcher must
# read that as a FAILURE — apply the on-child-failure policy — rather than seeing a
# fresh parked child and re-promoting it into an endless re-run loop.
doom_park_child() {  # doom_park_child <base>  — mimic the reaper's doom park
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  {
    printf -- '---\ngate: go-ahead\npriority: normal\n'
    printf 'doomed: true\ndoom_signature: requeue-exhausted\nposted_by: reaper:testhost\n---\n\n'
    printf '# %s\n\noriginal body for %s\n' "$1" "$1"
  } > "$wt/jobs/plan/$1.md"
  git -C "$wt" add "jobs/plan/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "doom-park($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-doom x-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-doom x-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-doom x-a x-b >/dev/null

tick                        # promote x-a
in_dir jobs/todo x-a || bad "doom setup: x-a not promoted"
doom_park_child x-a       # reaper dooms x-a → parks it in plan/ (doomed: true)
tick                        # watcher must read the doomed plan as FAILED → HALT

pois_ok=1
in_dir jobs/todo x-a && { pois_ok=0; echo "    x-a was RE-PROMOTED (doom plan mis-read as parked)"; }
in_dir jobs/todo x-b && { pois_ok=0; echo "    x-b promoted despite the halt"; }
in_dir jobs/plan x-a || { pois_ok=0; echo "    doomed x-a plan not preserved in plan/"; }
in_dir jobs/orch orch-doom && { pois_ok=0; echo "    orchestration not closed"; }
in_dir jobs/tada orch-doom || { pois_ok=0; echo "    halt summary not written"; }
{ [ "$pois_ok" -eq 1 ]; } \
  && ok "doomed parked child read as FAILED: not re-promoted, work preserved in plan/, run halted" \
  || bad "doom-park: todo=[$(board jobs/todo)] plan=[$(board jobs/plan)] orch=[$(board jobs/orch)] tada=[$(board jobs/tada)]"
grep -qi '^orchestration-status: halted' "$V/jobs/tada/orch-doom.md" 2>/dev/null \
  && ok "doomed-child halt summary marks orchestration-status: halted" \
  || bad "doom-park halt summary missing status marker"

# ============================================================================
hr; echo "SUBTEST 6 — STALL: a requeue rise across ticks halts with host-specific reason"; hr
claim_child() {  # claim_child <base> <claimed-at>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" mv "jobs/todo/$1.md" "jobs/doin/$1.md"
  {
    printf '\n---\nclaim:\n'
    printf '  host: stall-host\n  gardener: 1\n  claimed_at: %s\n' "$2"
  } >> "$wt/jobs/doin/$1.md"
  git -C "$wt" add "jobs/doin/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "claim($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
requeue_child() {  # requeue_child <base> <count>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" mv "jobs/doin/$1.md" "jobs/todo/$1.md"
  printf '\n<!-- garden-reaped: %s -->\n' "$2" >> "$wt/jobs/todo/$1.md"
  git -C "$wt" add "jobs/todo/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "requeue($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
set_reap() {  # set_reap <subdir> <base> <count> — overwrite the reap marker on a job in <subdir>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  sed -i '/^<!-- garden-reaped: [0-9]* -->$/d' "$wt/$1/$2.md"
  printf '\n<!-- garden-reaped: %s -->\n' "$3" >> "$wt/$1/$2.md"
  git -C "$wt" add "$1/$2.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "set-reap($2=$3)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
# Simulate a PRODUCTIVE resume cycle: the child is claimed in doin with a prior
# non-productive requeue count AND the gardener's productive-cycle hint (it advanced a
# per-job worktree HEAD this cycle). Under the OLD "any requeue rise = failed" rule this
# would have been torn down; the watcher must now read the hint and keep it active.
claim_progressing() {  # claim_progressing <base> <reapcount>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  [ -f "$wt/jobs/todo/$1.md" ] && git -C "$wt" mv "jobs/todo/$1.md" "jobs/doin/$1.md"
  sed -i '/^<!-- garden-reaped: [0-9]* -->$/d;/^<!-- garden-productive-cycle -->$/d' "$wt/jobs/doin/$1.md"
  {
    printf '\n<!-- garden-reaped: %s -->\n' "$2"
    printf '<!-- garden-productive-cycle -->\n'
  } >> "$wt/jobs/doin/$1.md"
  git -C "$wt" add "jobs/doin/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "progressing($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-stall r-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-stall r-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-stall r-a r-b >/dev/null
tick                            # promotes r-a and snapshots reaps=0
claim_child r-a "$(date -u +%FT%TZ)"
tick                            # captures claim host for the later notice
requeue_child r-a 1
tick                            # reaps 0 → 1 WITHIN the limit (2), no productive hint: tolerated
{ ! in_dir jobs/tada orch-stall && ! in_dir jobs/todo r-b && in_dir jobs/todo r-a; } \
  && ok "one requeue below GARDEN_ORCH_STALL_REQUEUE_LIMIT is tolerated (child stays active)" \
  || bad "requeue within limit was wrongly failed (tada=$(board jobs/tada), todo=$(board jobs/todo))"
set_reap jobs/todo r-a 2
tick                            # reaps == limit (2): still tolerated
{ ! in_dir jobs/tada orch-stall && in_dir jobs/todo r-a; } \
  && ok "requeue count equal to the limit is still tolerated" \
  || bad "requeue at the limit was wrongly failed (tada=$(board jobs/tada), todo=$(board jobs/todo))"
set_reap jobs/todo r-a 3
tick                            # reaps 3 EXCEEDS the limit (2), no progress hint: deterministic failure
stall_ok=1
in_dir jobs/tada orch-stall || stall_ok=0
in_dir jobs/todo r-b && stall_ok=0
grep -q 'stalled after 3 requeues on host stall-host' "$V/jobs/tada/orch-stall.md" 2>/dev/null || stall_ok=0
grep -rqi 'stalled after 3 requeues on host stall-host' "$V/inbox/maintainer/unread" 2>/dev/null || stall_ok=0
[ "$stall_ok" -eq 1 ] && ok "a requeue streak past the limit with no progress hint stalls, halts, and names its host" \
  || bad "requeue stall not surfaced correctly (tada=$(board jobs/tada), todo=$(board jobs/todo))"

# ============================================================================
hr; echo "SUBTEST 7 — STALL: handler-timeout bounds claimed in-flight work"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-time t-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-time t-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-time t-a t-b >/dev/null
tick
claim_child t-a "$(date -u -d '2 minutes ago' +%FT%TZ)"
# The default timeout in this hermetic watcher is 2400s, so add a one-second
# header after claim to isolate the elapsed-time rule from the requeue rule.
wt="$(mktemp -d "$TR/edit.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
sed -i '1i handler-timeout: 1' "$wt/jobs/doin/t-a.md"
git -C "$wt" add jobs/doin/t-a.md; git -C "$wt" "${git_id[@]}" commit -q -m "short-timeout(t-a)"
git -C "$wt" push -q origin "HEAD:$BRANCH"; rm -rf "$wt"
tick
time_ok=1
in_dir jobs/tada orch-time || time_ok=0
in_dir jobs/todo t-b && time_ok=0
grep -q 'stalled in flight' "$V/jobs/tada/orch-time.md" 2>/dev/null || time_ok=0
[ "$time_ok" -eq 1 ] && ok "expired handler-timeout is a deterministic stalled child" \
  || bad "handler-timeout stall not detected (tada=$(board jobs/tada), todo=$(board jobs/todo))"

# ============================================================================
hr; echo "SUBTEST 8 — BUDGET VALIDATION: positive integers and serial-only"; hr
validation_ok=1
"$JOBS/post-orchestration.sh" --serial --budget-tokens 0 invalid-budget child 2>/dev/null && validation_ok=0
"$JOBS/post-orchestration.sh" --serial --budget-tokens nope invalid-budget child 2>/dev/null && validation_ok=0
"$JOBS/post-orchestration.sh" --parallel --budget-tokens 10 invalid-budget child 2>/dev/null && validation_ok=0
[ "$validation_ok" -eq 1 ] && ok "invalid/zero budgets and budgeted parallel dispatch are rejected" \
  || bad "budget validation accepted an illegal declaration"

# ============================================================================
hr; echo "SUBTEST 9 — BUDGET FOLD: under cap promotes; epoch/outcome semantics"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-under u-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-under u-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --budget-tokens 100 orch-under u-a u-b >/dev/null
append_usage u-a '{"ts":"2000-01-01T00:00:00Z","source":"result","outcome":"tada","input_tokens":900}'
now="$(date -u +%FT%TZ)"
append_usage u-a "{\"ts\":\"$now\",\"source\":\"result\",\"outcome\":\"requeue\",\"input_tokens\":20,\"output_tokens\":10,\"cache_creation_tokens\":5,\"cache_read_tokens\":900,\"total_cost_usd\":1.5}"
append_usage u-a "{\"ts\":\"$now\",\"source\":\"delta\",\"outcome\":\"fail\",\"input_tokens\":10,\"output_tokens\":5,\"cache_creation_tokens\":10}"
tick
fold_ok=1
in_dir jobs/todo u-a || fold_ok=0
grep -q 'campaign spend 60/100' "$TR/tick.log" || fold_ok=0
[ "$fold_ok" -eq 1 ] && ok "fresh fold excluded prior epoch/cache reads, counted requeue+fail, and promoted under cap" \
  || bad "under-budget fold/promotion mismatch (todo=$(board jobs/todo); log=$(cat "$TR/tick.log"))"

# ============================================================================
hr; echo "SUBTEST 10 — EXACT CAP: stop terminally and preserve parked remainder"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-exact e-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-exact e-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --budget-tokens 100 orch-exact e-a e-b >/dev/null
now="$(date -u +%FT%TZ)"
append_usage e-a "{\"ts\":\"$now\",\"source\":\"result\",\"outcome\":\"tada\",\"input_tokens\":100,\"total_cost_usd\":2}"
tick
exact_ok=1
in_dir jobs/tada orch-exact || exact_ok=0
in_dir jobs/orch orch-exact && exact_ok=0
in_dir jobs/plan e-a || exact_ok=0
in_dir jobs/plan e-b || exact_ok=0
grep -q '^orchestration-status: budget-exhausted' "$V/jobs/tada/orch-exact.md" 2>/dev/null || exact_ok=0
grep -q '^campaign-parked-children: e-a e-b' "$V/jobs/tada/orch-exact.md" 2>/dev/null || exact_ok=0
[ "$exact_ok" -eq 1 ] && ok "spend == cap closed budget-exhausted without sweeping the visible remainder" \
  || bad "exact-cap state mismatch (plan=$(board jobs/plan), tada=$(board jobs/tada))"

# ============================================================================
hr; echo "SUBTEST 11 — OVERSHOOT: one admitted child may cross the cap"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-over o-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-over o-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --budget-tokens 100 orch-over o-a o-b >/dev/null
tick
complete_child o-a
now="$(date -u +%FT%TZ)"
append_usage o-a "{\"ts\":\"$now\",\"source\":\"result\",\"outcome\":\"tada\",\"input_tokens\":120,\"total_cost_usd\":3}"
tick
over_ok=1
in_dir jobs/tada orch-over || over_ok=0
in_dir jobs/plan o-b || over_ok=0
grep -q '^campaign-overshoot-tokens: 20' "$V/jobs/tada/orch-over.md" 2>/dev/null || over_ok=0
grep -q '^campaign-unspent-tokens: 0' "$V/jobs/tada/orch-over.md" 2>/dev/null || over_ok=0
[ "$over_ok" -eq 1 ] && ok "post-child overshoot reported and next child remained parked" \
  || bad "overshoot state/report mismatch"

# ============================================================================
hr; echo "SUBTEST 12 — FAIL CLOSED: unmetered and malformed campaign rows"; hr
for kind in unmetered malformed; do
  campaign="orch-$kind"; child="m-$kind"
  "$JOBS/post-plan.sh" --orchestrated --orchestrated-by "$campaign" "$child" >/dev/null
  "$JOBS/post-orchestration.sh" --serial --budget-tokens 100 "$campaign" "$child" >/dev/null
  if [ "$kind" = unmetered ]; then
    now="$(date -u +%FT%TZ)"; append_usage "$child" "{\"ts\":\"$now\",\"source\":\"none\",\"outcome\":\"fail\"}"
  else
    append_usage "$child" '{not-json'
  fi
  tick
done
meter_ok=1
for kind in unmetered malformed; do
  in_dir jobs/tada "orch-$kind" || meter_ok=0
  in_dir jobs/plan "m-$kind" || meter_ok=0
  grep -q '^orchestration-status: budget-meter-incomplete' "$V/jobs/tada/orch-$kind.md" 2>/dev/null || meter_ok=0
done
[ "$meter_ok" -eq 1 ] && ok "unmetered and malformed ledgers terminated fail-closed with work parked" \
  || bad "meter-incomplete terminal behavior mismatch"

# ============================================================================
hr; echo "SUBTEST 13 — COMPLETION: report and notify unused budget"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-unspent n-a >/dev/null
"$JOBS/post-orchestration.sh" --serial --budget-tokens 100 orch-unspent n-a >/dev/null
tick
complete_child n-a
now="$(date -u +%FT%TZ)"
append_usage n-a "{\"ts\":\"$now\",\"source\":\"result\",\"outcome\":\"tada\",\"input_tokens\":40,\"total_cost_usd\":1}"
tick
unspent_ok=1
in_dir jobs/tada orch-unspent || unspent_ok=0
grep -q '^campaign-spend-tokens: 40' "$V/jobs/tada/orch-unspent.md" 2>/dev/null || unspent_ok=0
grep -q '^campaign-unspent-tokens: 60' "$V/jobs/tada/orch-unspent.md" 2>/dev/null || unspent_ok=0
grep -rqi '60 token(s) remain unused' "$V/inbox/maintainer/unread" 2>/dev/null || unspent_ok=0
[ "$unspent_ok" -eq 1 ] && ok "under-budget completion surfaced 60 unused tokens in report and maintainer inbox" \
  || bad "under-budget completion did not surface unused budget"

# ============================================================================
hr; echo "SUBTEST 14 — RESUME: new budget epoch atomically retags remainder"; hr
"$JOBS/post-orchestration.sh" --serial --budget-tokens 50 --resume-from orch-exact \
  orch-resume e-a e-b >/dev/null
resume_ok=1
resume_view="$(mktemp -d "$TR/resume-view.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$resume_view"
grep -q '^resume_from: orch-exact' "$resume_view/jobs/orch/orch-resume.md" || resume_ok=0
grep -q '^orchestrated_by: orch-resume' "$resume_view/jobs/plan/e-a.md" || resume_ok=0
grep -q '^orchestrated_by: orch-resume' "$resume_view/jobs/plan/e-b.md" || resume_ok=0
rm -rf "$resume_view"
tick
in_dir jobs/todo e-a || resume_ok=0
in_dir jobs/plan e-b || resume_ok=0
[ "$resume_ok" -eq 1 ] && ok "resume created a distinct budget epoch, retagged atomically, and excluded old spend" \
  || bad "separately-budgeted resume mismatch (todo=$(board jobs/todo), plan=$(board jobs/plan))"

# ============================================================================
hr; echo "SUBTEST 15 — PRODUCTIVE: a requeued child that advanced a HEAD stays active and advances its baseline"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-prod pr-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-prod pr-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-prod pr-a pr-b >/dev/null
tick                              # promote pr-a, baseline reaps=0
claim_child pr-a "$(date -u +%FT%TZ)"
tick                              # capture claim host
claim_progressing pr-a 1          # prior requeue count 1 (>baseline) BUT a productive-cycle hint
tick                              # honor the hint → progressing, NOT failed; advance baseline
prod_ok=1
in_dir jobs/tada orch-prod && { prod_ok=0; echo "    orchestration halted a progressing child"; }
in_dir jobs/todo pr-b && { prod_ok=0; echo "    pr-b promoted early"; }
in_dir jobs/doin pr-a || { prod_ok=0; echo "    pr-a no longer in flight"; }
pview="$(mktemp -d "$TR/prod-view.XXXXXX")"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$pview"
grep -q '^child-pr-a-reap-count: 1' "$pview/jobs/orch/orch-prod.md" 2>/dev/null \
  || { prod_ok=0; echo "    reap baseline not advanced to the new floor (1)"; }
rm -rf "$pview"
[ "$prod_ok" -eq 1 ] && ok "productive-cycle child (worktree HEAD advanced) stayed active and advanced its reap baseline" \
  || bad "productive-cycle handling mismatch (orch=$(board jobs/orch) tada=$(board jobs/tada) doin=$(board jobs/doin))"

# ============================================================================
hr; echo "SUBTEST 16 — SERIAL GATE: N+1 is NOT promoted while N still occupies todo/doin"; hr
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-gate g-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-gate g-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure continue orch-gate g-a g-b >/dev/null
tick                              # promote g-a
in_dir jobs/todo g-a || bad "gate setup: g-a not promoted"
claim_child g-a "$(date -u +%FT%TZ)"
# Force g-a to classify as FAILED (no hint, requeue streak past the limit) while it is
# STILL in doin. Under policy=continue the ordered loop advances past it; the serial gate
# must nevertheless refuse to promote g-b while g-a still occupies the board.
set_reap jobs/doin g-a 3
tick
gate_ok=1
in_dir jobs/doin g-a || { gate_ok=0; echo "    g-a unexpectedly left doin"; }
in_dir jobs/todo g-b && { gate_ok=0; echo "    g-b PROMOTED while g-a still in flight (serial gate breached)"; }
[ "$gate_ok" -eq 1 ] && ok "serial run held g-b parked while g-a still occupied doin (no concurrent promotion)" \
  || bad "serial gate breached (doin=$(board jobs/doin) todo=$(board jobs/todo))"
fail_child g-a                    # g-a genuinely vanishes from the board
tick                              # only now may continue promote g-b
{ in_dir jobs/todo g-b; } \
  && ok "once g-a vanished, policy=continue released the gate and promoted g-b" \
  || bad "g-b not promoted after g-a vanished (todo=$(board jobs/todo))"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
