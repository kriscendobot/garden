#!/bin/bash
# root-repo-guard.sh — assert the DEPLOYED ROOT REPO's invariants every tick and
# repair + alert on drift, so a job that "escapes" into $GARDEN_ROOT/.git can no
# longer leave the fleet running a corrupted root for days undetected.
#
# WHY (incident 2026-07-17 / 2026-07-21). The root checkout ($GARDEN_ROOT) and the
# journal/ worktree SHARE ONE repo ($GARDEN_ROOT/.git). Two independent jobs ran git
# with that shared repo as the enclosing repository and corrupted it:
#
#   1. A native-git TEST FIXTURE created a dir under the root but never `git init`-ed
#      it, so its `checkout -b feature` / `commit` ops ASCENDED to the root repo:
#      HEAD moved off the deployed detached commit onto a fixture `feature` branch.
#      The fleet ran the fixture working tree for FOUR DAYS.
#   2. A PROJECT-WORK job treated the root as its project checkout:
#      `git remote set-url origin ssh://…/endojs/endo-but-for-bots.git`, a fetch that
#      PRUNED the true origin refs (origin/journal2, origin/main2), and a
#      `git branch xs2rust-endor …` — all in the root repo. This broke journal sync
#      HOST-WIDE (the journal worktree froze; inbox-read/message-user FATALed) and
#      poisoned the journal-remote cache. The fleet survived only because each
#      per-gardener state clone pins its OWN correct origin.
#
# The two escape mechanisms this guard backstops (belt to the GIT_CEILING_DIRECTORIES
# suspenders exported in the worker spine, gardener.sh, and the "never run git in
# $GARDEN_ROOT" rule in every worker prompt, worker-common.sh) are:
#   * a MOVED HEAD — off the deployed detached commit onto a branch, or onto a commit
#     that is not a main2 ancestor (a fixture commit); and
#   * a REWRITTEN origin — no longer the canonical garden remote
#     ($GARDEN_PRODUCTION_JOURNAL_REPO, or a migration alias of it).
#
# INVARIANTS asserted, each with a bounded, lossless repair:
#
#   A. remote.origin.url matches the canonical production journal remote
#      (is_production_journal_remote / GARDEN_PRODUCTION_JOURNAL_REMOTE_RE). A wrong
#      origin breaks journal sync for the WHOLE HOST, so this is repaired eagerly —
#      from a source the escape cannot poison: the origin of any per-instance journal
#      clone under $GARDEN_STATE (each worker pins its own). The candidate is
#      RE-VALIDATED against the RE before it is written, so a repair can only ever
#      set the canonical URL, never propagate a second bad value.
#
#   B. HEAD is DETACHED at a main2 ancestor — never on a local branch (the `feature`
#      escape), never at a commit that is not an ancestor of origin/main2 (a fixture
#      commit). Repair re-detaches HEAD onto the recorded deploy point (deployed_sha,
#      the value deploy-garden.sh explicitly records — so the repair RESPECTS
#      deliberate-deploy and does not advance the deploy) when that is itself a main2
#      ancestor, else onto the origin/main2 tip. The pre-repair HEAD is preserved as a
#      `root-guard-backup/<ts>` branch ref first, so nothing is lost. Gated on the
#      fleet NOT draining (a deploy in progress owns the tree) and on origin/main2
#      being resolvable (never reset toward an unknown target).
#
#   C. The OBJECT STORE is healthy and MAINTAINABLE — i.e. `git gc` can still run.
#      Nobody owned this: no script in the garden ever ran gc/repack/prune, and git's
#      own automatic cleanup SILENTLY AND PERMANENTLY DISABLES ITSELF once a gc
#      failure writes `.git/gc.log` ("Automatic cleanup will not be performed until
#      the file is removed"). That failure is self-reinforcing: with auto-gc dead,
#      packs and aborted-repack temp files accumulate unbounded, every git call in the
#      repo — including EVERY journal sync, since journal/ is a worktree of this same
#      repo — pays the multi-pack index scan, and each call prints the gc.log warning
#      banner on stderr, exactly the unexpected-stderr noise the gardener's output
#      classifiers read. Repairs, in the same bounded/lossless style as A and B:
#        1. sweep `objects/pack/tmp_*` garbage older than a safe age. Aborted repacks
#           leave these behind FOREVER — git reports them as "garbage found" and never
#           reclaims them; on the first host audited they were 15 GB against a ~320 MB
#           real store, so this alone is the bulk of the recovery.
#        2. when a stale gc.log is present, or the pack/loose counts pass their
#           ceilings, run a bounded `git gc` — and remove the gc.log(s) ONLY once gc
#           actually SUCCEEDS, so the guard never merely hides the signal. Both the
#           common gc.log and the per-worktree `.git/worktrees/*/gc.log` copies are
#           cleared, since each one independently disables auto-gc for commands run
#           from that worktree.
#        3. if gc fails, prefer NON-DESTRUCTIVE recovery: `git fetch origin --refetch`
#           from the canonical remote (additive only — it can restore objects that
#           history references but the local store can no longer read; it never prunes
#           and never drops a ref), then retry gc once.
#        4. if gc STILL fails, alert ONCE per breakage window (like the stalled-deploy
#           watch) with the missing-object count and a by-hand reconciliation recipe.
#           The guard never repairs destructively on its own: dropping the refs that
#           reach a missing object drops history, so that stays a human decision, and
#           any ref that must move is backed up under `root-guard-backup/<ts>` first
#           (invariant B's discipline).
#      Deferred while the fleet is draining (a deploy owns the tree) and backed off to
#      at most one attempt per GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS, so a store that
#      cannot be repaired does not re-run a multi-minute gc every tick.
#
# Plus a STALLED-DEPLOY watch: when the recorded deployed sha lags origin/main2 for
# longer than GARDEN_DEPLOY_STALL_DAYS, alert ONCE per breakage window (the incident
# also noted deploys silently stalled since 07-17). Cleared automatically when the
# deploy catches up.
#
# Runs on garden-root-repo-guard.timer (~30m) on EVERY host (each host has its own
# root checkout that can be corrupted independently — NOT leader-gated). Quiet on the
# healthy path (a one-line "root repo healthy"); every repair and every alert is
# logged. Always returns 0 so a transient hiccup never marks the tick Failed.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="root-repo-guard"

# Overridable for tests; defaults to the real deployed root.
: "${GARDEN_ROOT_GUARD_REPO:=$GARDEN_ROOT}"
ROOT="$GARDEN_ROOT_GUARD_REPO"

# Stalled-deploy threshold + its per-host state (first-observed-behind stamp and a
# once-per-window alerted flag), all under GARDEN_STATE so a reset/deploy resets them.
: "${GARDEN_DEPLOY_STALL_DAYS:=3}"
GUARD_STATE="$GARDEN_STATE/root-repo-guard"
BEHIND_SINCE="$GUARD_STATE/behind-since"
STALL_ALERTED="$GUARD_STATE/stall-alerted"

# --- invariant C knobs (object-store health) ---------------------------------
# Temp pack files younger than this are left alone — one in flight is owned by a live
# writer. 6h is ~50x the longest pack write the fleet can produce (bounded_fetch is
# capped at GARDEN_FETCH_TIMEOUT, a gc here at GARDEN_ROOT_GUARD_GC_TIMEOUT), and the
# gate doubles as the ceiling on steady-state garbage, which on a broken store
# regenerates at ~10 GB/day.
: "${GARDEN_ROOT_GUARD_TMP_AGE_HOURS:=6}"
# Ceilings past which the store is "needs maintenance" even with no gc.log. A healthy
# gc'd repo sits at 1–2 packs; git's own auto-gc threshold is 50 packs / 6700 loose.
: "${GARDEN_ROOT_GUARD_MAX_PACKS:=50}"
: "${GARDEN_ROOT_GUARD_MAX_LOOSE:=10000}"
# Back-off between maintenance attempts, so an unrepairable store does not re-run a
# multi-minute gc on every ~30m tick.
: "${GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS:=6}"
# Per-step wall-clock budgets. Their worst-case sum (gc + refetch + gc + scan) must
# stay under the unit's TimeoutStartSec.
: "${GARDEN_ROOT_GUARD_GC_TIMEOUT:=420}"
: "${GARDEN_ROOT_GUARD_REFETCH_TIMEOUT:=420}"
: "${GARDEN_ROOT_GUARD_MISSING_SCAN_TIMEOUT:=180}"
MAINT_LAST="$GUARD_STATE/maint-last"
OBJSTORE_ALERTED="$GUARD_STATE/objstore-alerted"

now_epoch() { date -u +%s 2>/dev/null || echo 0; }
ts_utc()    { date -u +%Y%m%dT%H%M%SZ 2>/dev/null || echo unknown; }

# --- INVARIANT A: origin URL -------------------------------------------------
# Return 0 if origin is (now) canonical, 1 if it is drifted and could not be
# repaired. Repairs from a per-instance clone's origin (escape-proof), re-validated
# against the production RE before writing.
guard_origin() {
  local url
  url="$(git -C "$ROOT" config --get remote.origin.url 2>/dev/null || true)"
  if is_production_journal_remote "$url"; then
    return 0
  fi

  # DRIFT. Find a trusted canonical URL from a source the escape cannot have
  # rewritten: any per-instance journal clone under $GARDEN_STATE pins its own
  # origin. Fall back to the persisted cache only if it is itself still canonical.
  local good=""
  good="$(_journal_remote_from_state_clones 2>/dev/null || true)"
  if ! is_production_journal_remote "$good"; then
    local cached; cached="$(cat "$JOURNAL_REMOTE_CACHE" 2>/dev/null || true)"
    is_production_journal_remote "$cached" && good="$cached" || good=""
  fi

  if [ -z "$good" ]; then
    local msg="root repo $ROOT has a NON-CANONICAL origin (\"${url:-<unset>}\", not github.com/$GARDEN_PRODUCTION_JOURNAL_REPO) and NO trusted canonical URL could be found to repair it (no per-instance clone or cache carries one). This breaks journal sync host-wide. Reconcile by hand: 'git -C $ROOT remote set-url origin $GARDEN_PRODUCTION_JOURNAL_URL'. (host=$GARDEN)"
    log "ORIGIN-DRIFT-UNREPAIRABLE: $msg"
    alert_maintainer "root-repo-origin-unrepairable-$GARDEN" "$msg"
    return 1
  fi

  # Repair: set-url when a remote section exists, else add it. Re-validate what we
  # actually wrote — never leave a half-repaired non-canonical value in place.
  git -C "$ROOT" remote set-url origin "$good" >/dev/null 2>&1 \
    || git -C "$ROOT" remote add origin "$good" >/dev/null 2>&1 \
    || git -C "$ROOT" config remote.origin.url "$good" >/dev/null 2>&1 || true
  url="$(git -C "$ROOT" config --get remote.origin.url 2>/dev/null || true)"
  if is_production_journal_remote "$url"; then
    _cache_journal_remote "$url"
    local msg="root repo $ROOT origin had DRIFTED to a non-canonical remote and was repaired to the canonical journal remote ($url). A job likely ran 'git remote set-url' with \$GARDEN_ROOT as its enclosing repo (incident 2026-07-21). (host=$GARDEN)"
    log "ORIGIN-REPAIRED: $msg"
    alert_maintainer "root-repo-origin-repaired-$GARDEN" "$msg"
    return 0
  fi
  local msg="root repo $ROOT origin drift repair FAILED to stick (still \"${url:-<unset>}\"). Reconcile by hand. (host=$GARDEN)"
  log "ORIGIN-REPAIR-FAILED: $msg"
  alert_maintainer "root-repo-origin-repairfail-$GARDEN" "$msg"
  return 1
}

# --- INVARIANT B: HEAD detached at a main2 ancestor --------------------------
# <up> is origin/main2's resolved sha ("" when unresolvable). Repairs a drifted HEAD
# by re-detaching onto the recorded deploy point (or origin/main2), backing the prior
# HEAD up to a branch ref first. Skips (never fights) while the fleet is draining.
guard_head() {
  local up="$1"
  local head_ref head_sha on_branch=0 ancestor=0
  head_ref="$(git -C "$ROOT" symbolic-ref -q HEAD 2>/dev/null || true)"   # nonempty ⇒ on a branch
  head_sha="$(git -C "$ROOT" rev-parse --verify --quiet HEAD 2>/dev/null || true)"
  [ -n "$head_ref" ] && on_branch=1
  if [ -n "$up" ] && [ -n "$head_sha" ] \
     && git -C "$ROOT" merge-base --is-ancestor "$head_sha" "$up" 2>/dev/null; then
    ancestor=1
  fi

  # Healthy: detached AND a main2 ancestor.
  if [ "$on_branch" -eq 0 ] && [ "$ancestor" -eq 1 ]; then
    return 0
  fi

  # DRIFT. Without a resolvable origin/main2 we cannot safely pick a repair target;
  # alert and leave untouched (the origin repair or a later online tick will supply
  # <up>).
  if [ -z "$up" ]; then
    local msg="root repo $ROOT HEAD looks DRIFTED (${head_ref:+on branch ${head_ref#refs/heads/}}${head_ref:+, }head ${head_sha:-<none>}) but origin/$GARDEN_MAIN_BRANCH is unresolvable (offline or origin unrepaired); left UNTOUCHED this tick. (host=$GARDEN)"
    log "HEAD-DRIFT-DEFERRED: $msg"
    alert_maintainer "root-repo-head-deferred-$GARDEN" "$msg"
    return 1
  fi

  # Never fight a deploy: deploy-garden.sh advances the root tree under the draining
  # marker. If draining, defer — the next tick heals once the deploy lifts the drain.
  if fleet_draining; then
    log "HEAD-DRIFT-DEFERRED: root repo $ROOT HEAD drift detected but the fleet is DRAINING (deploy in progress owns the tree); deferring to a later tick"
    return 1
  fi

  # Choose the safe re-detach target: the recorded deploy point if it is itself a
  # main2 ancestor (respects deliberate-deploy — restore to what was deployed, do not
  # advance), else the origin/main2 tip.
  local cand safe
  cand="$(deployed_sha 2>/dev/null || true)"
  cand="$(git -C "$ROOT" rev-parse --verify --quiet "${cand:-}^{commit}" 2>/dev/null || true)"
  if [ -n "$cand" ] && git -C "$ROOT" merge-base --is-ancestor "$cand" "$up" 2>/dev/null; then
    safe="$cand"
  else
    safe="$up"
  fi

  # Preserve the pre-repair HEAD as a durable backup ref before we move it.
  local backup_ref; backup_ref="root-guard-backup/$(ts_utc)"
  git -C "$ROOT" branch -f "$backup_ref" "$head_sha" >/dev/null 2>&1 || true

  # Re-detach + restore the deployed tree. --force discards the corrupt tracked tree
  # (the fixture files); untracked debris is left for a separate cleanup. The root is
  # a DEPLOYED checkout that should carry no WIP, and any prior state is captured in
  # $backup_ref above, so this is lossless.
  if git -C "$ROOT" checkout --detach --force "$safe" >/dev/null 2>&1; then
    local was="${head_ref:+branch ${head_ref#refs/heads/}}"; was="${was:-detached $head_sha}"
    local msg="root repo $ROOT HEAD had DRIFTED ($was) off the deployed detached commit — the signature of a job that ran git with \$GARDEN_ROOT as its enclosing repo (incident 2026-07-17). Re-detached HEAD onto $safe (the recorded deploy point / origin/$GARDEN_MAIN_BRANCH). Prior HEAD preserved as branch $backup_ref. (host=$GARDEN)"
    log "HEAD-REPAIRED: $msg"
    alert_maintainer "root-repo-head-repaired-$GARDEN" "$msg"
    return 0
  fi
  local msg="root repo $ROOT HEAD drift detected but the re-detach to $safe FAILED; left as-is. Prior HEAD at branch $backup_ref. Reconcile by hand: 'git -C $ROOT checkout --detach --force $safe'. (host=$GARDEN)"
  log "HEAD-REPAIR-FAILED: $msg"
  alert_maintainer "root-repo-head-repairfail-$GARDEN" "$msg"
  return 1
}

# --- INVARIANT C: object store healthy and maintainable ----------------------
# The root repo's git dir is SHARED — the journal/ worktree and every per-job
# gardener-wt-* worktree hang off it — so its admin files live in the COMMON git dir,
# not in any one worktree's. Resolve that once; every step below works from it.
root_common_gitdir() {
  local d
  d="$(git -C "$ROOT" rev-parse --git-common-dir 2>/dev/null || true)"
  [ -z "$d" ] && return 1
  case "$d" in /*) ;; *) d="$ROOT/$d" ;; esac
  ( cd "$d" 2>/dev/null && pwd ) || printf '%s\n' "$d"
}

# C.1 — sweep orphaned temp pack files. EVERY pack write lands in objects/pack/tmp_*
# first — a repack's output, and every incoming fetch's index-pack — and is renamed
# into place only on success. Any write that dies (a repack that hit a missing object,
# a fetch that bounded_fetch's timeout killed mid-transfer) strands its tmp_* there
# FOREVER: git reports them as "garbage found" on every invocation and has no code
# path that removes them. Cheap (one `find` over one directory) and run every tick
# regardless of whether the store otherwise needs maintenance, because it is pure
# reclamation. Age-gated so a live writer's temp file is never pulled out from under
# it.
sweep_pack_garbage() {
  local packdir="$1/objects/pack"
  [ -d "$packdir" ] || return 0
  local mins=$(( GARDEN_ROOT_GUARD_TMP_AGE_HOURS * 60 ))
  local sizes n bytes
  sizes="$(find "$packdir" -maxdepth 1 -type f -name 'tmp_*' -mmin "+$mins" -printf '%s\n' 2>/dev/null || true)"
  n="$(printf '%s\n' "$sizes" | grep -c . 2>/dev/null || true)"; [[ "$n" =~ ^[0-9]+$ ]] || n=0
  [ "$n" -eq 0 ] && return 0
  bytes="$(printf '%s\n' "$sizes" | awk '{s+=$1} END{printf "%d", s+0}' 2>/dev/null || echo 0)"
  find "$packdir" -maxdepth 1 -type f -name 'tmp_*' -mmin "+$mins" -delete 2>/dev/null || true
  log "OBJSTORE-SWEPT: removed $n orphaned temp pack file(s) (~$(( bytes / 1048576 )) MiB) from $packdir — stranded by pack writes (repacks, incoming fetches) that died, which git reports as garbage but never reclaims"
}

# Clear the stale gc.log(s) — the common one AND each worktree's own copy, since any
# one of them keeps git's automatic cleanup disabled for commands run from there.
# ONLY ever called after a gc has actually succeeded.
clear_gc_logs() {
  local gd="$1"
  rm -f "$gd/gc.log" 2>/dev/null || true
  [ -d "$gd/worktrees" ] && find "$gd/worktrees" -maxdepth 2 -type f -name gc.log -delete 2>/dev/null || true
  return 0
}

count_gc_logs() {
  local gd="$1" n=0
  [ -f "$gd/gc.log" ] && n=1
  if [ -d "$gd/worktrees" ]; then
    local w; w="$(find "$gd/worktrees" -maxdepth 2 -type f -name gc.log 2>/dev/null | grep -c . || true)"
    [[ "$w" =~ ^[0-9]+$ ]] && n=$(( n + w ))
  fi
  printf '%s\n' "$n"
}

# A bounded, worktree-safe gc. `gc.worktreePruneExpire=never` is deliberate: gc would
# otherwise prune worktree admin entries, and a blanket worktree prune is exactly the
# hazard journal-worktree-keeper.sh documents (under a garden-root RELOCATION the
# gitdir back-pointers are stale, so a prune deletes LIVE entries). Deregistering a
# worktree is the keeper's job, never a side effect of maintenance. Echoes git's own
# diagnostics so a failure can be reported verbatim.
attempt_root_gc() {
  timeout --kill-after=30 "$GARDEN_ROOT_GUARD_GC_TIMEOUT" \
    git -C "$ROOT" -c gc.worktreePruneExpire=never gc --quiet 2>&1
}

# <origin_ok> gates the --refetch recovery: never fetch from a remote invariant A
# could not certify as canonical.
guard_object_store() {
  local origin_ok="$1"
  local gd
  if ! gd="$(root_common_gitdir)"; then
    log "WARN: could not resolve the root repo's common git dir; skipping the object-store check"
    return 0
  fi
  mkdir -p "$GUARD_STATE" 2>/dev/null || true

  sweep_pack_garbage "$gd"

  # Does the store need maintenance at all? Quiet no-op when it does not.
  local gclogs packs loose reason=""
  gclogs="$(count_gc_logs "$gd")"
  packs="$(find "$gd/objects/pack" -maxdepth 1 -type f -name '*.pack' 2>/dev/null | grep -c . || true)"
  [[ "$packs" =~ ^[0-9]+$ ]] || packs=0
  loose="$(git -C "$ROOT" count-objects 2>/dev/null | awk '{print $1}' || true)"
  [[ "$loose" =~ ^[0-9]+$ ]] || loose=0

  [ "$gclogs" -gt 0 ] && reason="a stale gc.log is present (${gclogs} copy/copies), which keeps git's automatic cleanup PERMANENTLY disabled"
  if [ "$packs" -gt "$GARDEN_ROOT_GUARD_MAX_PACKS" ]; then
    reason="${reason:+$reason; }$packs packs (ceiling $GARDEN_ROOT_GUARD_MAX_PACKS)"
  fi
  if [ "$loose" -gt "$GARDEN_ROOT_GUARD_MAX_LOOSE" ]; then
    reason="${reason:+$reason; }$loose loose objects (ceiling $GARDEN_ROOT_GUARD_MAX_LOOSE)"
  fi
  if [ -z "$reason" ]; then
    # Healthy — close any open breakage window so a later failure alerts again.
    rm -f "$OBJSTORE_ALERTED" 2>/dev/null || true
    return 0
  fi

  # Never fight a deploy: deploy-garden.sh owns the tree under the draining marker.
  if fleet_draining; then
    log "OBJSTORE-DEFERRED: root repo $ROOT needs object-store maintenance ($reason) but the fleet is DRAINING (deploy in progress owns the tree); deferring to a later tick"
    return 1
  fi

  # Back off: at most one gc attempt per interval, so an unrepairable store does not
  # burn a multi-minute gc on every tick.
  local now last
  now="$(now_epoch)"
  last="$(cat "$MAINT_LAST" 2>/dev/null || echo 0)"; [[ "$last" =~ ^[0-9]+$ ]] || last=0
  if [ $(( now - last )) -lt $(( GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS * 3600 )) ]; then
    return 1
  fi
  printf '%s\n' "$now" > "$MAINT_LAST" 2>/dev/null || true

  log "OBJSTORE-MAINTENANCE: root repo $ROOT needs maintenance ($reason); running a bounded 'git gc'"
  local out rc=0
  out="$(attempt_root_gc)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    clear_gc_logs "$gd"
    log "OBJSTORE-REPAIRED: git gc succeeded on $ROOT (was: $reason); stale gc.log(s) cleared, so git's automatic cleanup is enabled again"
    rm -f "$OBJSTORE_ALERTED" 2>/dev/null || true
    return 0
  fi

  local first_err
  first_err="$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-300)"
  log "OBJSTORE-GC-FAILED: 'git gc' on $ROOT failed (rc=$rc): ${first_err:-<no output>}"

  # NON-DESTRUCTIVE recovery first. --refetch re-downloads the full history from the
  # canonical remote without negotiation, so objects the local store can no longer
  # read are restored from origin. It only ever ADDS objects — no prune, no ref moved.
  if [ "$origin_ok" -eq 1 ]; then
    log "OBJSTORE-RECOVERY: re-fetching full history from the canonical origin ('fetch --refetch', additive only) to restore unreadable objects"
    local _ft="$GARDEN_FETCH_TIMEOUT" _fr="$GARDEN_FETCH_RETRIES"
    GARDEN_FETCH_TIMEOUT="$GARDEN_ROOT_GUARD_REFETCH_TIMEOUT"; GARDEN_FETCH_RETRIES=1
    bounded_fetch "$ROOT" origin --refetch \
      || log "OBJSTORE-RECOVERY: the --refetch did not complete (offline, or larger than its budget); retrying gc anyway"
    GARDEN_FETCH_TIMEOUT="$_ft"; GARDEN_FETCH_RETRIES="$_fr"

    rc=0; out="$(attempt_root_gc)" || rc=$?
    if [ "$rc" -eq 0 ]; then
      clear_gc_logs "$gd"
      log "OBJSTORE-REPAIRED: git gc succeeded on $ROOT after a --refetch recovery (was: $reason); stale gc.log(s) cleared"
      rm -f "$OBJSTORE_ALERTED" 2>/dev/null || true
      return 0
    fi
    first_err="$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-300)"
  fi

  # Still broken. Diagnose (bounded) and alert ONCE per breakage window. We do NOT
  # repair destructively: the objects git cannot read are reachable from real refs, so
  # dropping those refs drops history — a human decision, not a timer's.
  local missing n_missing sample
  missing="$(timeout "$GARDEN_ROOT_GUARD_MISSING_SCAN_TIMEOUT" \
    git -C "$ROOT" rev-list --objects --missing=print --all 2>/dev/null | grep '^?' || true)"
  n_missing="$(printf '%s\n' "$missing" | grep -c . 2>/dev/null || true)"
  [[ "$n_missing" =~ ^[0-9]+$ ]] || n_missing=0
  sample="$(printf '%s\n' "$missing" | head -3 | tr '\n' ' ')"

  if [ ! -f "$OBJSTORE_ALERTED" ]; then
    local msg="root repo $ROOT object store is UNMAINTAINABLE: 'git gc' fails (${first_err:-unknown error}) and a non-destructive 'fetch --refetch' from the canonical origin did not restore it. ${n_missing} object(s) reachable from refs are missing locally${sample:+ (e.g. $sample)}. State: ${packs} packs, ${loose} loose objects, ${gclogs} stale gc.log(s). While gc cannot run, git's automatic cleanup stays disabled, packs accumulate unbounded, and EVERY git call in this repo — including every journal sync, since journal/ is a worktree of it — pays the cost and prints the gc.log banner on stderr. This guard will NOT repair destructively on its own, because the refs that reach the missing objects are real history. Reconcile by hand: list them with 'git -C $ROOT rev-list --objects --missing=print --all | grep \"^?\"', find the refs that reach them, back each one up first ('git -C $ROOT branch root-guard-backup/\$(date -u +%Y%m%dT%H%M%SZ)-<name> <ref>'), then re-point or drop the ref and re-run 'git -C $ROOT gc'. (host=$GARDEN)"
    log "OBJSTORE-UNREPAIRABLE: $msg"
    alert_maintainer "root-repo-objstore-$GARDEN" "$msg"
    : > "$OBJSTORE_ALERTED" 2>/dev/null || true
  fi
  return 1
}

# --- stalled-deploy watch ----------------------------------------------------
# When the recorded deployed sha is an ancestor of origin/main2 (a normal lag) for
# longer than the threshold, alert ONCE per window. Cleared when caught up.
guard_deploy_lag() {
  local up="$1"
  mkdir -p "$GUARD_STATE" 2>/dev/null || true
  local dep
  dep="$(deployed_sha 2>/dev/null || true)"
  dep="$(git -C "$ROOT" rev-parse --verify --quiet "${dep:-}^{commit}" 2>/dev/null || true)"

  # Not behind (caught up, or we cannot tell): clear the window and return.
  if [ -z "$up" ] || [ -z "$dep" ] || [ "$dep" = "$up" ] \
     || ! git -C "$ROOT" merge-base --is-ancestor "$dep" "$up" 2>/dev/null; then
    rm -f "$BEHIND_SINCE" "$STALL_ALERTED" 2>/dev/null || true
    return 0
  fi

  # Behind. Stamp the first observation, then alert once past the threshold.
  local now since age_days
  now="$(now_epoch)"
  if [ -f "$BEHIND_SINCE" ]; then
    since="$(cat "$BEHIND_SINCE" 2>/dev/null || echo "$now")"
  else
    since="$now"; printf '%s\n' "$now" > "$BEHIND_SINCE" 2>/dev/null || true
  fi
  age_days=$(( (now - since) / 86400 ))
  if [ "$age_days" -ge "$GARDEN_DEPLOY_STALL_DAYS" ] && [ ! -f "$STALL_ALERTED" ]; then
    local behind_n
    behind_n="$(git -C "$ROOT" rev-list --count "$dep..$up" 2>/dev/null || echo '?')"
    local msg="root repo $ROOT deploy has been STALLED for ~${age_days}d: deployed sha $dep is ${behind_n} commit(s) behind origin/$GARDEN_MAIN_BRANCH ($up) and has not advanced. Deploys are deliberate/drained (deploy-garden.sh) — investigate why none has landed. (host=$GARDEN)"
    log "DEPLOY-STALLED: $msg"
    alert_maintainer "root-repo-deploy-stalled-$GARDEN" "$msg"
    printf '%s\n' "$now" > "$STALL_ALERTED" 2>/dev/null || true
  fi
  return 0
}

guard_root_repo() {
  if ! git -C "$ROOT" rev-parse --git-dir >/dev/null 2>&1; then
    log "WARN: root repo at $ROOT is not a git repository; skipping"
    return 0
  fi

  # A — origin URL (repair first; the ancestry checks below need a good origin to
  # fetch origin/main2 from).
  local origin_ok=0
  guard_origin && origin_ok=1

  # Refresh origin/main2 (bounded) so the HEAD-ancestry + deploy-lag checks compare
  # against the current tip. Only when origin is canonical (never fetch a bad remote).
  if [ "$origin_ok" -eq 1 ]; then
    bounded_fetch "$ROOT" origin "$GARDEN_MAIN_BRANCH" \
      || log "fetch of origin/$GARDEN_MAIN_BRANCH failed (offline?); using the last-known ref"
  fi
  local up
  up="$(git -C "$ROOT" rev-parse --verify --quiet "refs/remotes/origin/$GARDEN_MAIN_BRANCH" 2>/dev/null || true)"

  # B — HEAD detached at a main2 ancestor.
  local head_ok=0
  guard_head "$up" && head_ok=1

  # C — object store healthy and maintainable (gc can still run). Last of the three:
  # it is the slowest, and a drifted HEAD or origin is the more urgent repair.
  local obj_ok=0
  guard_object_store "$origin_ok" && obj_ok=1

  # Stalled-deploy watch (informational; never blocks the healthy path).
  guard_deploy_lag "$up"

  if [ "$origin_ok" -eq 1 ] && [ "$head_ok" -eq 1 ] && [ "$obj_ok" -eq 1 ]; then
    log "root repo healthy: origin canonical, HEAD detached at a $GARDEN_MAIN_BRANCH ancestor, object store maintainable"
  fi
  return 0
}

guard_root_repo
