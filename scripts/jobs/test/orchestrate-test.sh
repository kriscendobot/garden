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
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/orch work \
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

# Simulate a child FAILING: the reaper poisoned/dropped it — it vanishes from the
# board WITHOUT a tada report.
fail_child() {  # fail_child <base>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  git -C "$wt" "${git_id[@]}" commit -q -m "poison-drop($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

tick() { "$JOBS/orchestrate.sh" >"$TR/tick.log" 2>&1 || { echo "  (orchestrate.sh rc=$? — see $TR/tick.log)"; cat "$TR/tick.log"; }; }

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
fail_child h-a            # h-a vanishes without tada (poisoned)
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
hr; echo "SUBTEST 5 — POISON-PARK: a poisoned child parked in plan/ is treated as failed, not re-promoted"; hr
# The reaper no longer DROPS a poisoned child; it PARKS it in plan/<child>.md under
# a held gate carrying `poisoned: true` (reaper.sh poison branch). The watcher must
# read that as a FAILURE — apply the on-child-failure policy — rather than seeing a
# fresh parked child and re-promoting it into an endless re-run loop.
poison_park_child() {  # poison_park_child <base>  — mimic the reaper's poison park
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  {
    printf -- '---\ngate: go-ahead\npriority: normal\n'
    printf 'poisoned: true\npoison_signature: requeue-exhausted\nposted_by: reaper:testhost\n---\n\n'
    printf '# %s\n\noriginal body for %s\n' "$1" "$1"
  } > "$wt/jobs/plan/$1.md"
  git -C "$wt" add "jobs/plan/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "poison-park($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-poison x-a >/dev/null
"$JOBS/post-plan.sh" --orchestrated --orchestrated-by orch-poison x-b >/dev/null
"$JOBS/post-orchestration.sh" --serial --on-child-failure halt orch-poison x-a x-b >/dev/null

tick                        # promote x-a
in_dir jobs/todo x-a || bad "poison setup: x-a not promoted"
poison_park_child x-a       # reaper poisons x-a → parks it in plan/ (poisoned: true)
tick                        # watcher must read the poisoned plan as FAILED → HALT

pois_ok=1
in_dir jobs/todo x-a && { pois_ok=0; echo "    x-a was RE-PROMOTED (poison plan mis-read as parked)"; }
in_dir jobs/todo x-b && { pois_ok=0; echo "    x-b promoted despite the halt"; }
in_dir jobs/plan x-a || { pois_ok=0; echo "    poisoned x-a plan not preserved in plan/"; }
in_dir jobs/orch orch-poison && { pois_ok=0; echo "    orchestration not closed"; }
in_dir jobs/tada orch-poison || { pois_ok=0; echo "    halt summary not written"; }
{ [ "$pois_ok" -eq 1 ]; } \
  && ok "poisoned parked child read as FAILED: not re-promoted, work preserved in plan/, run halted" \
  || bad "poison-park: todo=[$(board jobs/todo)] plan=[$(board jobs/plan)] orch=[$(board jobs/orch)] tada=[$(board jobs/tada)]"
grep -qi '^orchestration-status: halted' "$V/jobs/tada/orch-poison.md" 2>/dev/null \
  && ok "poisoned-child halt summary marks orchestration-status: halted" \
  || bad "poison-park halt summary missing status marker"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
