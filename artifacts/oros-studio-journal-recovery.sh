#!/bin/bash
# oros-studio-journal-recovery.sh — sense and repair a garden instance that
# cannot bring itself up because its journal2 clones (and/or its root repo's
# object store) grew too large/corrupted to self-heal on the standing timers.
#
# WHO THIS IS FOR: an operator/liaison running this INSIDE their own garden
# container, at the root of their checkout (same directory CLAUDE.md refers to
# as $GARDEN_ROOT). It only ever touches THIS host's own state — never anything
# shared or another host's.
#
# WHY THIS EXISTS: origin/journal2 on github.com/kriscendobot/garden was
# rewritten on 2026-09-23 to a single fresh orphan-root commit (full prior
# history of 146k+ commits preserved on journal2-archive-20260923) because
# unbounded journal growth had made every consumer clone's fetch/gc
# impractically slow across the whole fleet. Any host whose LOCAL clones still
# carry the old pre-rewrite history is not "corrupted" in the git sense — it
# is just carrying tens of gigabytes of now-irrelevant history that its own
# `git fetch` + `git reset --hard origin/journal2` would normally discard in
# one step, EXCEPT that step itself can be too slow/blocked to ever complete
# once a clone is bloated enough (a `.git/gc.log` from a failed automatic gc
# PERMANENTLY disables git's own cleanup until removed, and packs/temp files
# then grow without bound). That is precisely the failure mode two of our own
# hosts hit this week, and the fix that worked both times is below.
#
# WHAT THIS SCRIPT DOES, IN ORDER:
#   1. Diagnose: disk space (bytes AND inodes — they fail independently),
#      and the root repo's object-store health (packs, loose objects,
#      gc.log, gc.pid lock liveness).
#   2. Repair (safe, non-destructive, proven today): every named consumer
#      clone under $GARDEN_STATE/*/journal is disposable and gets rebuilt
#      from scratch by the ordinary `ensure_clone` path — this alone
#      recovered ~200G on one host and ~100G on another this week, and
#      cannot lose anything because journal2 itself is the durable copy.
#   3. Repair (the root repo, via the EXISTING guard, not reinvented here):
#      invokes root-repo-guard.sh with the same authorized escalation the
#      sysop `maintain` op uses, which can break a CONFIRMED-STALE gc.pid
#      lock (never a live one) and run one bounded `git gc`. You are running
#      this directly at your own console, which is the same authority a
#      sysop-bus `maintain` op needs attestation for — no bus round-trip
#      required for a local operator.
#   4. Verify: re-fetch and hard-reset the journal/ worktree; report whether
#      it now matches the small post-rewrite origin/journal2.
#   5. If still broken after all of the above, STOP and print a clear,
#      specific diagnosis. This script never drops a ref or discards
#      genuine history on its own — exactly like root-repo-guard, a
#      non-empty missing-object count after a non-destructive `--refetch`
#      is a human decision, not a script's.
#
# USAGE:
#   cd <your garden root>
#   bash oros-studio-journal-recovery.sh
#
# Safe to re-run; every step is idempotent.

set -uo pipefail

HERE="$(pwd)"
echo "== oros-studio journal recovery — starting from $HERE =="
echo

if [ ! -d "scripts/jobs" ] || [ ! -f "scripts/jobs/common.sh" ]; then
  echo "FATAL: this doesn't look like a garden root (no scripts/jobs/common.sh here)."
  echo "cd to your garden checkout root first, then re-run."
  exit 2
fi

# shellcheck source=/dev/null
source scripts/jobs/common.sh 2>/dev/null || {
  echo "FATAL: could not source scripts/jobs/common.sh. If this errors with a"
  echo "missing-file message, your root repo's checked-out TREE itself may be"
  echo "damaged (not just git history) — that is beyond this script's scope;"
  echo "report the exact error to your liaison for a by-hand look."
  exit 2
}

echo "GARDEN_ROOT   = $GARDEN_ROOT"
echo "GARDEN_STATE  = $GARDEN_STATE"
echo

# ---------------------------------------------------------------------------
echo "== Step 1: diagnose disk space =="
echo "--- bytes ---"
df -h -- "$GARDEN_ROOT" "$GARDEN_STATE" 2>/dev/null | sort -u
echo "--- inodes ---"
df -i -- "$GARDEN_ROOT" "$GARDEN_STATE" 2>/dev/null | sort -u
echo
echo "--- current $GARDEN_STATE size (this may itself be slow on a bloated host — be patient) ---"
du -sh "$GARDEN_STATE" 2>/dev/null || echo "(du did not complete — that alone is evidence of the problem)"
echo

# ---------------------------------------------------------------------------
echo "== Step 2: rebuild every named consumer journal clone under \$GARDEN_STATE =="
echo "(safe: each one is a disposable cache; origin/journal2 is the durable copy)"
ts="recovery-retired-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$GARDEN_STATE/../$ts" 2>/dev/null || mkdir -p "/tmp/$ts"
retired_dir="$GARDEN_STATE/../$ts"
[ -d "$retired_dir" ] || retired_dir="/tmp/$ts"

moved=0
if [ -d "$GARDEN_STATE" ]; then
  for d in "$GARDEN_STATE"/*/journal; do
    [ -d "$d" ] || continue
    kind="$(basename "$(dirname "$d")")"
    mkdir -p "$retired_dir/$kind" 2>/dev/null || true
    if mv "$d" "$retired_dir/$kind/journal" 2>/dev/null; then
      moved=$((moved + 1))
    fi
  done
fi
echo "moved $moved clone(s) aside into $retired_dir"
if [ "$moved" -gt 0 ]; then
  echo "removing the retired copies in the background (this can take a while; safe to leave running)"
  nohup rm -rf "$retired_dir" >/dev/null 2>&1 &
  disown 2>/dev/null || true
fi
echo "(each clone rebuilds itself, small, the next time its own consumer runs — no action needed)"
echo

# ---------------------------------------------------------------------------
echo "== Step 3: repair the root repo's object store, via the existing guard =="
echo "(same authorized escalation the sysop 'maintain' op uses: breaks a"
echo " CONFIRMED-STALE gc.pid lock only — never a live one — then runs one"
echo " bounded 'git gc'. You are running this directly at your own console.)"
GARDEN_ROOT_GUARD_UNLOCK_STALE_GC=1 \
GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS=0 \
  bash scripts/jobs/root-repo-guard.sh
echo
echo "(re-run this step alone anytime with the same two env vars if you want"
echo " to retry just the object-store repair without redoing step 2)"
echo

# ---------------------------------------------------------------------------
echo "== Step 4: verify journal sync =="
if [ -d journal ]; then
  echo "-- fetching origin/journal2 --"
  if git -C journal fetch origin journal2 2>&1; then
    echo "-- hard-resetting journal/ onto origin/journal2 --"
    if git -C journal reset --hard origin/journal2 2>&1; then
      echo "OK: journal/ now matches origin/journal2."
      git -C journal log -1 --format='HEAD: %H %ci %s'
    else
      echo "STILL FAILING: 'git reset --hard' did not complete. See the error"
      echo "above. This usually means the object store still cannot be read"
      echo "cleanly even after step 3 — re-check step 1's disk numbers first"
      echo "(a genuinely full disk defeats gc too), then escalate to your"
      echo "liaison with this script's full output."
    fi
  else
    echo "STILL FAILING: 'git fetch' did not complete. If step 1 showed near-zero"
    echo "free bytes or inodes, free real space first (the step-2 rebuild above"
    echo "should have reclaimed a lot; if it did not, something else on this"
    echo "host is also consuming that filesystem — check for it directly with"
    echo "'du -h --max-depth=1 $GARDEN_ROOT' and its parent)."
  fi
else
  echo "No journal/ worktree found at $HERE/journal — if this host has never"
  echo "completed first-run setup, that's expected; this script's job (getting"
  echo "the object store and state clones healthy) is still worth having done"
  echo "before you continue with normal bring-up."
fi
echo

# ---------------------------------------------------------------------------
echo "== Step 5: what's left, if anything ============================================"
echo "If step 4 reported OK, you're unblocked — next:"
echo "  - bring the garden up normally (see context/operations/starting.md)"
echo "  - once you're posting/claiming again, ask your maintainer to check"
echo "    whether this host's entry in the journal's hosts/ roster needs"
echo "    restoring from an archived state (it may have been marked offline"
echo "    while you were down — that's a maintainer/liaison call, not"
echo "    something to self-restore)."
echo
echo "If step 3 or 4 is STILL failing after this ran clean:"
echo "  - re-run this whole script once more (every step is idempotent, and"
echo "    a partially-freed disk from step 2 can unblock step 3 on a retry)"
echo "  - if it fails the SAME way twice, that's genuine object-store damage"
echo "    (missing objects even after a non-destructive '--refetch') or a"
echo "    LIVE gc.pid lock this script correctly refused to touch — both need"
echo "    a human decision, not another automated attempt. Share this"
echo "    script's full output with your liaison/maintainer for a by-hand look."
echo
echo "== done =="
