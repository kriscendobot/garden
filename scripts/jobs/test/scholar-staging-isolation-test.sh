#!/bin/bash
# scholar-staging-isolation-test.sh — prove scholar-staging-clone.sh gives every
# scholar-role job an ISOLATED staging tree keyed by its unique job base, so two
# concurrent scholar cycles on the same host can NEVER share one working tree.
#
# This is the regression for the 2026-07-29 destroyed-edits incident: the default
# staging path was one FIXED dir ($GARDEN_STATE/scholar-staging/journal), so two
# scholar jobs alive at once staged in the SAME directory. Each call runs
# sync_clone = `git reset --hard origin/journal2`, so one peer's hard reset silently
# discarded the other's uncommitted section/topic edits (and its `git add` swept the
# loser's WIP into its own commit). scholar-library-cycle-20260729-013504 racing
# scholar-ingest-atproto-ucan-did-specs lost 13 insert-sections-table-row.sh inserts
# behind a green step-8 gate. The helper now keys the DEFAULT path by the job base,
# exactly the way ensure-project-worktree.sh keys per-job project worktrees.
#
# Assertions:
#   1. Two DIFFERENT bases → DISTINCT staging paths, each under
#      $GARDEN_STATE/scholar-staging/<base>/journal.
#   2. Both are real, fresh clones of origin/journal2 (seeded content present).
#   3. A sync_clone (hard reset) in one base does NOT touch the other base's tree —
#      an uncommitted peer file survives (the actual corruption regression).
#   4. Same base (a requeue) → the SAME path.
#   5. --base and GARDEN_JOB_BASE both drive the per-base default; --base wins.
#   6. No dest, no GARDEN_SCHOLAR_STAGING_CLONE, no base → REFUSES (exit 2) rather
#      than fall back to a shared path.
#   7. The explicit dest-dir arg and the GARDEN_SCHOLAR_STAGING_CLONE override both
#      still work (backward compatibility).
#   8. The live-worktree refusal still fires ($GARDEN_ROOT/journal → exit 2).
#   9. Stale sibling per-base staging dirs are pruned; a fresh (active) sibling and
#      the current base are kept.
#
# Hermetic: a throwaway bare journal stands in for origin/journal2 (JOURNAL_REMOTE),
# a throwaway garden root + state dir. No network, no live journal.

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
HELPER="$JOBS/scholar-staging-clone.sh"

# Scrub ambient garden env: this test is often run BY a live gardener whose process
# exports the fleet's own GARDEN_*/JOURNAL_* (GARDEN_JOB_BASE among them), which
# would splice the live journal or a live base underneath the helper. Only the
# throwaway $TR settings below are authoritative.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_|XDG_)' || true) 2>/dev/null || true

PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

# A writable, exec-capable temp base (the container mounts /tmp noexec; git worktree
# ops need exec). $HOME is reliably exec-capable on the fleet.
pick_base() {
  local c
  for c in "$HOME" "${GARDEN_SCRATCH:-}" "${TMPDIR:-}" /tmp; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
BASE_DIR="$(pick_base)" || { echo "  SKIP: no writable temp base"; exit 0; }
TR="$(mktemp -d "$BASE_DIR/scholar-staging-iso.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

BARE="$TR/journal.git"
BRANCH=journal2
GROOT="$TR/garden"
STATE="$TR/state"
git_id=(-c user.name=test -c user.email=test@localhost)

# --- seed a throwaway journal origin (stands in for origin/journal2) ----------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p library/sections
  printf '# library\n' > library/README.md
  printf 'seed section\n' > library/sections/seed.md ) >/dev/null 2>&1
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed journal fixture"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

# $GARDEN_ROOT/journal must exist for the live-worktree refusal comparison; make it
# a bare dir (NOT the real journal — the test never syncs against it).
mkdir -p "$GROOT/journal"

# run_stage <env-assignments...> -- <helper-args...>  → echoes path; sets RC.
# Everything before `--` is `VAR=value` env for this one call; everything after is
# passed to the helper. JOURNAL_REMOTE/ROOT/STATE are always fixed to the fixture.
run_stage() {
  local env_kv=() a
  while [ "$#" -gt 0 ]; do [ "$1" = "--" ] && { shift; break; }; env_kv+=("$1"); shift; done
  set +e
  OUT="$(env JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH" \
             GARDEN=testhost GARDEN_ROOT="$GROOT" GARDEN_STATE="$STATE" \
             GARDEN_SCRATCH="$TR/scratch" \
             "${env_kv[@]}" \
             bash "$HELPER" "$@" 2>>"$TR/stderr.log")"
  RC=$?
  set -e
}

# === 1+2: two different bases → distinct, real, fresh clones ===================
run_stage -- --base scholar-cycle-A
PA="$OUT"; RCA="$RC"
run_stage -- --base scholar-ingest-B
PB="$OUT"; RCB="$RC"

[ "$RCA" -eq 0 ] && [ "$RCB" -eq 0 ] && ok "helper emits a path for each base (rc=0)" \
  || bad "helper did not exit 0 (RCA=$RCA RCB=$RCB); stderr: $(tail -3 "$TR/stderr.log")"
[ -n "$PA" ] && [ -n "$PB" ] && [ "$PA" != "$PB" ] \
  && ok "two different bases → DISTINCT staging paths" \
  || bad "COLLISION or empty: PA='$PA' PB='$PB' (the 2026-07-29 shared-tree bug)"
[ "$PA" = "$STATE/scholar-staging/scholar-cycle-A/journal" ] \
  && ok "base A path is the per-base default \$GARDEN_STATE/scholar-staging/<base>/journal" \
  || bad "base A path is not the per-base default: '$PA'"
[ -d "$PA/.git" ] && [ -f "$PA/library/sections/seed.md" ] \
  && [ -d "$PB/.git" ] && [ -f "$PB/library/sections/seed.md" ] \
  && ok "both staging trees are real clones with the seeded journal content" \
  || bad "a staging tree is not a populated clone (PA=$PA PB=$PB)"

# === 3: sync_clone in one base does NOT touch the other (isolation) ============
# Simulate base B's in-progress, uncommitted work; then re-provision base A (which
# runs ensure_clone + sync_clone = a hard reset on A's tree). B must be untouched.
echo "PEER-IN-PROGRESS-$$" > "$PB/library/sections/peer-wip.md"
echo "committed edit by A" > "$PA/library/sections/seed.md"
run_stage -- --base scholar-cycle-A
[ "$RC" -eq 0 ] && [ "$PA" = "$OUT" ] \
  && ok "re-provisioning base A hard-resets A's own tree (same path, rc=0)" \
  || bad "re-provisioning base A misbehaved (rc=$RC out='$OUT')"
[ -f "$PB/library/sections/peer-wip.md" ] \
  && grep -q "PEER-IN-PROGRESS-$$" "$PB/library/sections/peer-wip.md" \
  && ok "base B's uncommitted peer work SURVIVES base A's sync (no cross-tree reset)" \
  || bad "base A's sync destroyed base B's uncommitted work (the corruption regression)"
# and A's own tree WAS hard-reset back to the seed (fresh each cycle)
grep -q "seed section" "$PA/library/sections/seed.md" \
  && ok "base A's tree was hard-reset to the origin tip (staging is regenerable)" \
  || bad "base A's tree was not reset to origin (sync_clone did not run)"

# === 4: same base (a requeue) → the SAME path =================================
run_stage -- --base scholar-cycle-A
[ "$OUT" = "$PA" ] && ok "same base re-derives the SAME per-base path (requeue-stable)" \
  || bad "same base resolved to a different path ('$OUT' != '$PA')"

# === 5: GARDEN_JOB_BASE drives the default; --base overrides it ===============
run_stage GARDEN_JOB_BASE=env-base-C --
[ "$OUT" = "$STATE/scholar-staging/env-base-C/journal" ] \
  && ok "GARDEN_JOB_BASE drives the per-base default when no --base is given" \
  || bad "GARDEN_JOB_BASE did not drive the default ('$OUT')"
run_stage GARDEN_JOB_BASE=env-base-C -- --base flag-base-D
[ "$OUT" = "$STATE/scholar-staging/flag-base-D/journal" ] \
  && ok "--base overrides GARDEN_JOB_BASE" \
  || bad "--base did not override GARDEN_JOB_BASE ('$OUT')"

# === 6: no base anywhere → REFUSES (exit 2), never a shared fallback ==========
run_stage --
[ "$RC" -eq 2 ] && ok "no dest + no override + no base → REFUSES (exit 2)" \
  || bad "expected exit 2 with no base, got rc=$RC out='$OUT'"

# === 7: explicit dest-dir and GARDEN_SCHOLAR_STAGING_CLONE still work =========
DEST="$TR/explicit-dest"
run_stage -- "$DEST"
[ "$RC" -eq 0 ] && [ "$OUT" = "$DEST" ] && [ -d "$DEST/.git" ] \
  && ok "explicit dest-dir arg still resolves and clones there" \
  || bad "explicit dest-dir broke (rc=$RC out='$OUT')"
ENVDEST="$TR/env-override-dest"
run_stage GARDEN_SCHOLAR_STAGING_CLONE="$ENVDEST" --
[ "$RC" -eq 0 ] && [ "$OUT" = "$ENVDEST" ] && [ -d "$ENVDEST/.git" ] \
  && ok "GARDEN_SCHOLAR_STAGING_CLONE override still resolves and clones there" \
  || bad "GARDEN_SCHOLAR_STAGING_CLONE override broke (rc=$RC out='$OUT')"

# === 8: live-worktree refusal still fires ====================================
run_stage -- "$GROOT/journal"
[ "$RC" -eq 2 ] && ok "refuses to stage in the live \$GARDEN_ROOT/journal worktree (exit 2)" \
  || bad "live-worktree refusal did not fire (rc=$RC out='$OUT')"

# === 9: stale sibling staging dirs are pruned; active + current are kept ======
STAGE_ROOT="$STATE/scholar-staging"
# A stale sibling: a dir whose whole subtree is aged well past the TTL window.
mkdir -p "$STAGE_ROOT/stale-old-job/journal"
echo x > "$STAGE_ROOT/stale-old-job/journal/leftover.md"
touch -d "3 days ago" "$STAGE_ROOT/stale-old-job/journal/leftover.md" \
                      "$STAGE_ROOT/stale-old-job/journal" "$STAGE_ROOT/stale-old-job" 2>/dev/null
# An active sibling (fresh mtime) must be protected from pruning.
mkdir -p "$STAGE_ROOT/active-peer-job/journal"
echo y > "$STAGE_ROOT/active-peer-job/journal/live.md"
run_stage GARDEN_SCHOLAR_STAGING_TTL_HOURS=24 -- --base scholar-cycle-A
[ ! -d "$STAGE_ROOT/stale-old-job" ] \
  && ok "a stale (quiescent > TTL) sibling staging dir is pruned" \
  || bad "the stale sibling staging dir was NOT pruned (unbounded growth)"
[ -d "$STAGE_ROOT/active-peer-job" ] \
  && ok "an active (recent-mtime) sibling staging dir is NOT pruned" \
  || bad "an ACTIVE peer's staging dir was wrongly pruned"
[ -d "$STAGE_ROOT/scholar-cycle-A/journal" ] \
  && ok "the current base's staging dir is kept" \
  || bad "pruning removed the current base's own staging dir"

# --- summary -----------------------------------------------------------------
echo "----------------------------------------------------------------"
echo "scholar-staging-isolation: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
