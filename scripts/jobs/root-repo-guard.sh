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
#        3. if gc fails, CLASSIFY before escalating (fix, 2026-08-17 — a failed gc used
#           to conflate lock contention with a damaged store, then burn a ~173MB
#           --refetch and page a hand-repair recipe that did not apply):
#             * LOCK CONTENTION (`gc is already running ... pid <n>`) is not damage —
#               a live concurrent gc (any journal sync / worktree op can fire a
#               background `git gc --auto` on this shared store) or a stale lock. Back
#               off to the next tick; NO --refetch, NO alert.
#             * ZERO MISSING OBJECTS — a gc that fails for any other reason while every
#               referenced object is present locally — is likewise not damage. Back off
#               quietly; NO --refetch, NO alert.
#           Only a NON-ZERO missing-object count is genuine damage; then prefer
#           NON-DESTRUCTIVE recovery: `git fetch origin --refetch` from the canonical
#           remote (additive only — restores objects history references but the local
#           store can no longer read; never prunes, never drops a ref), then retry gc.
#        4. if gc STILL fails AND objects are still missing, alert ONCE per breakage
#           window (like the stalled-deploy watch) with the missing-object count and a
#           by-hand reconciliation recipe — never on a zero missing count.
#           The guard never repairs destructively on its own: dropping the refs that
#           reach a missing object drops history, so that stays a human decision, and
#           any ref that must move is backed up under `root-guard-backup/<ts>` first
#           (invariant B's discipline).
#      Deferred while the fleet is draining (a deploy owns the tree) and backed off to
#      at most one attempt per GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS, so a store that
#      cannot be repaired does not re-run a multi-minute gc every tick.
#
#   D. The HOST FILESYSTEM has inode headroom. `df -i` is classified independently
#      from byte capacity: a filesystem can have plenty of bytes free while refusing
#      every filesystem/git write with ENOSPC because its inode table is exhausted.
#      Below GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT (default 5%), alert the
#      maintainer with the filesystem-wide measurement and clear the notice after
#      recovery. This guard deliberately does NOT delete anything: deciding whether a
#      worktree is stale requires job-board + worktree-registration review, and a
#      timer must never infer that from a directory name or age alone.
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
export GARDEN_TAG="root-repo-guard"

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

# --- invariant D knobs (host filesystem inode headroom) ---------------------
# Check the filesystem that backs the bind-mounted deployed root. Tests may replace
# df with a fixture command; production uses the system df.
: "${GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT:=5}"
: "${GARDEN_ROOT_GUARD_INODE_PATH:=$GARDEN_ROOT}"
: "${GARDEN_ROOT_GUARD_DF_CMD:=df}"
INODE_ALERT_KEY="root-repo-low-inodes-$GARDEN"

# --- authorized gc-lock escalation (the sysop `maintain` op) ------------------
# By DEFAULT the guard never breaks a `gc.pid` lock: a lock that MIGHT belong to a live
# gc is a destructive ambiguity it refuses to resolve unattended (that refusal is the
# whole point of the trigger case, designs/sysop-repo-maintenance.md). When the sysop's
# attested `maintain` op runs the guard via root-maintenance.sh it sets this flag to 1,
# authorizing ONE new behavior: remove a CONFIRMED-STALE gc.pid (holder dead or a
# recycled non-git pid — gc_lock_holder_alive says so) and then run an ordinary gc. It
# still never passes `git gc --force`, never clobbers a live gc, and never drops refs or
# history — a store with genuinely missing objects still alerts a human (invariant C).
: "${GARDEN_ROOT_GUARD_UNLOCK_STALE_GC:=0}"
# When set, the escalation outcome is recorded here (one word) so root-maintenance.sh
# can map it to a terminal sysop ack: noop-healthy | gc-ok | unlocked-gc-ok |
# refused-live-gc | gc-failed.
: "${GARDEN_ROOT_GUARD_ESCALATION_RESULT:=}"
esc_result() {  # esc_result <word>
  [ -n "$GARDEN_ROOT_GUARD_ESCALATION_RESULT" ] || return 0
  printf '%s\n' "$1" > "$GARDEN_ROOT_GUARD_ESCALATION_RESULT" 2>/dev/null || true
}

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

# Recognize the gc LOCK-CONTENTION error — git's `fatal: gc is already running on
# machine '<host>' pid <n> (use --force if not)` — as DISTINCT from a damaged store.
# git prints exactly this (and exits nonzero) when objects/gc.pid is already held,
# whether by a live concurrent gc (any journal sync or per-job worktree op can fire a
# background `git gc --auto` on this SHARED object store) or by a stale lock a dead gc
# left behind. Either way the store itself is intact, so a gc that fails this way must
# NOT be escalated to a --refetch or a maintainer alert.
gc_error_is_lock_contention() {
  case "$1" in *"gc is already running"*) return 0 ;; *) return 1 ;; esac
}
# Extract the holder pid from that error message ("" if none present).
gc_error_lock_pid() {
  printf '%s' "$1" | sed -n 's/.*[Pp]id \([0-9][0-9]*\).*/\1/p' | head -1
}

# Bounded scan for objects that refs reach but the local store cannot read. A non-empty
# result is the ONLY signal of genuine object-store DAMAGE — a failed gc with zero
# missing objects is a lock/transient condition, not a broken store.
scan_missing_objects() {
  timeout "$GARDEN_ROOT_GUARD_MISSING_SCAN_TIMEOUT" \
    git -C "$ROOT" rev-list --objects --missing=print --all 2>/dev/null | grep '^?' || true
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
  # Under an authorized escalation (the `maintain` op), a present gc.pid lock is itself
  # a reason to act — a stale lock blocks every future gc even when packs/loose are
  # still under their ceilings, and the operator explicitly asked to clear it now.
  local gc_pid_file="$gd/gc.pid"
  if [ "$GARDEN_ROOT_GUARD_UNLOCK_STALE_GC" -eq 1 ] && [ -f "$gc_pid_file" ]; then
    reason="${reason:+$reason; }a gc.pid lock is present (authorized maintain escalation)"
  fi
  if [ -z "$reason" ]; then
    # Healthy — close any open breakage window so a later failure alerts again.
    rm -f "$OBJSTORE_ALERTED" 2>/dev/null || true
    esc_result noop-healthy
    return 0
  fi

  # Never fight a deploy: deploy-garden.sh owns the tree under the draining marker.
  if fleet_draining; then
    log "OBJSTORE-DEFERRED: root repo $ROOT needs object-store maintenance ($reason) but the fleet is DRAINING (deploy in progress owns the tree); deferring to a later tick"
    esc_result gc-failed   # a maintain escalation reports deferred-under-drain as non-terminal failure; retriable once the drain lifts
    return 1
  fi

  # Back off: at most one gc attempt per interval, so an unrepairable store does not
  # burn a multi-minute gc on every tick. The authorized `maintain` escalation SKIPS the
  # back-off — the operator deliberately asked for maintenance now.
  if [ "$GARDEN_ROOT_GUARD_UNLOCK_STALE_GC" -ne 1 ]; then
    local now last
    now="$(now_epoch)"
    last="$(cat "$MAINT_LAST" 2>/dev/null || echo 0)"; [[ "$last" =~ ^[0-9]+$ ]] || last=0
    if [ $(( now - last )) -lt $(( GARDEN_ROOT_GUARD_MAINT_INTERVAL_HOURS * 3600 )) ]; then
      return 1
    fi
    printf '%s\n' "$now" > "$MAINT_LAST" 2>/dev/null || true
  fi

  # AUTHORIZED ESCALATION: break a CONFIRMED-STALE gc.pid so the gc below can acquire the
  # lock. A lock held by a LIVE git gc is never touched — we refuse rather than clobber a
  # running gc (and never pass `git gc --force`, which would ignore liveness).
  local unlocked=0
  if [ "$GARDEN_ROOT_GUARD_UNLOCK_STALE_GC" -eq 1 ] && [ -f "$gc_pid_file" ]; then
    local lpid lhost
    read -r lpid lhost _ < "$gc_pid_file" 2>/dev/null || true
    if gc_lock_holder_alive "$lpid"; then
      log "OBJSTORE-GC-LOCK-LIVE: refusing to break gc.pid on $ROOT — pid ${lpid:-?} (host ${lhost:-?}) is a LIVE git gc; not forcing. If it is genuinely wedged, kill it by hand and re-issue the maintain op."
      esc_result refused-live-gc
      return 1
    fi
    rm -f "$gc_pid_file" 2>/dev/null || true
    unlocked=1
    log "OBJSTORE-GC-UNLOCKED: removed a STALE gc.pid on $ROOT (recorded pid ${lpid:-?} host ${lhost:-?} is not a live gc — dead/killed/recycled). Authorized maintain escalation; running an ordinary bounded gc next."
  fi

  log "OBJSTORE-MAINTENANCE: root repo $ROOT needs maintenance ($reason); running a bounded 'git gc'"
  local out rc=0
  out="$(attempt_root_gc)" || rc=$?
  if [ "$rc" -eq 0 ]; then
    clear_gc_logs "$gd"
    log "OBJSTORE-REPAIRED: git gc succeeded on $ROOT (was: $reason); stale gc.log(s) cleared, so git's automatic cleanup is enabled again"
    rm -f "$OBJSTORE_ALERTED" 2>/dev/null || true
    esc_result "$( [ "$unlocked" -eq 1 ] && echo unlocked-gc-ok || echo gc-ok )"
    return 0
  fi

  local first_err
  first_err="$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-300)"
  log "OBJSTORE-GC-FAILED: 'git gc' on $ROOT failed (rc=$rc): ${first_err:-<no output>}"

  # LOCK CONTENTION IS NOT DAMAGE (fix, 2026-08-17). `fatal: gc is already running on
  # machine '<host>' pid <n>` means objects/gc.pid is already held — by a live
  # concurrent gc (a background `git gc --auto` any journal sync or per-job worktree op
  # can fire on this shared store) or by a stale lock a dead gc left behind. The store
  # itself is intact, so escalating a full-history `--refetch` (~173MB on the real
  # root) and paging the maintainer with a history-touching repair recipe would both be
  # spent on a non-problem. Back off to the next tick: a live gc finishes, or a
  # confirmed-stale lock is cleared by the sysop `maintain` op. Report the holder's
  # liveness for the log (it distinguishes a genuine concurrent gc from a stale lock,
  # and two different pids across ticks — as observed on 2026-08-17 — indicate racing
  # concurrent gc's, not a wedged one).
  if gc_error_is_lock_contention "$out"; then
    local lpid liveness
    lpid="$(gc_error_lock_pid "$out")"
    if [ -z "$lpid" ]; then
      liveness="holder pid unknown"
    elif gc_lock_holder_alive "$lpid"; then
      liveness="pid $lpid is a LIVE git gc (a real concurrent gc; expected to clear on its own)"
    else
      liveness="pid $lpid is NOT a live gc (a stale lock; the sysop 'maintain' op can clear it, else the next tick finds it gone)"
    fi
    log "OBJSTORE-GC-CONTENDED: 'git gc' on $ROOT could not take the gc lock — $liveness. The object store is intact, so backing off to the next tick: NO --refetch and NO maintainer alert."
    esc_result gc-contended
    return 1
  fi

  # Not a lock error. Is the store ACTUALLY damaged? Only objects that refs reach but
  # the local store cannot read constitute damage. ZERO missing objects means the store
  # is NOT damaged (the gc failed for another reason — an unrecognized lock, a
  # transient, a config quirk), and the reported defect is precisely escalating a
  # --refetch and a ref-dropping repair recipe on that. Gate BOTH on a non-zero count.
  local missing n_missing sample
  missing="$(scan_missing_objects)"
  n_missing="$(printf '%s\n' "$missing" | grep -c . 2>/dev/null || true)"
  [[ "$n_missing" =~ ^[0-9]+$ ]] || n_missing=0

  if [ "$n_missing" -eq 0 ]; then
    log "OBJSTORE-GC-FAILED-INTACT: 'git gc' on $ROOT failed (${first_err:-unknown error}) but 0 objects reachable from refs are missing locally — the store is NOT damaged. Backing off to the next tick: no --refetch and no maintainer alert (a failed gc with nothing missing is a lock/transient condition, not a broken store)."
    esc_result gc-intact
    return 1
  fi

  # GENUINE DAMAGE (>=1 missing object). NON-DESTRUCTIVE recovery first. --refetch
  # re-downloads the full history from the canonical remote without negotiation, so
  # objects the local store can no longer read are restored from origin. It only ever
  # ADDS objects — no prune, no ref moved.
  if [ "$origin_ok" -eq 1 ]; then
    log "OBJSTORE-RECOVERY: re-fetching full history from the canonical origin ('fetch --refetch', additive only) to restore $n_missing unreadable object(s)"
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
      esc_result "$( [ "$unlocked" -eq 1 ] && echo unlocked-gc-ok || echo gc-ok )"
      return 0
    fi
    first_err="$(printf '%s' "$out" | tr '\n' ' ' | cut -c1-300)"
    # The --refetch is additive, so it may have restored some/all objects even if gc
    # still fails. Re-scan and alert only on what is STILL missing.
    missing="$(scan_missing_objects)"
    n_missing="$(printf '%s\n' "$missing" | grep -c . 2>/dev/null || true)"
    [[ "$n_missing" =~ ^[0-9]+$ ]] || n_missing=0
  fi

  # If the --refetch restored every referenced object but gc still fails, the store is
  # no longer damaged — do not page a human with an inapplicable recipe. Back off.
  if [ "$n_missing" -eq 0 ]; then
    log "OBJSTORE-GC-FAILED-INTACT: 'git gc' on $ROOT still fails (${first_err:-unknown error}) but the --refetch restored every referenced object (0 now missing) — not a damaged store. Backing off; no maintainer alert."
    esc_result gc-intact
    return 1
  fi

  # Still genuinely damaged (>=1 object missing even after --refetch). Alert ONCE per
  # breakage window. We do NOT repair destructively: the objects git cannot read are
  # reachable from real refs, so dropping those refs drops history — a human decision,
  # not a timer's. The recipe below is gated on this non-zero missing count, so it is
  # never emitted with an empty missing list (fix, 2026-08-17).
  sample="$(printf '%s\n' "$missing" | head -3 | tr '\n' ' ')"
  if [ ! -f "$OBJSTORE_ALERTED" ]; then
    local msg="root repo $ROOT object store is UNMAINTAINABLE: 'git gc' fails (${first_err:-unknown error}) and a non-destructive 'fetch --refetch' from the canonical origin did not restore it. ${n_missing} object(s) reachable from refs are missing locally${sample:+ (e.g. $sample)}. State: ${packs} packs, ${loose} loose objects, ${gclogs} stale gc.log(s). While gc cannot run, git's automatic cleanup stays disabled, packs accumulate unbounded, and EVERY git call in this repo — including every journal sync, since journal/ is a worktree of it — pays the cost and prints the gc.log banner on stderr. This guard will NOT repair destructively on its own, because the refs that reach the missing objects are real history. Reconcile by hand: list them with 'git -C $ROOT rev-list --objects --missing=print --all | grep \"^?\"', find the refs that reach them, back each one up first ('git -C $ROOT branch root-guard-backup/\$(date -u +%Y%m%dT%H%M%SZ)-<name> <ref>'), then re-point or drop the ref and re-run 'git -C $ROOT gc'. (host=$GARDEN)"
    log "OBJSTORE-UNREPAIRABLE: $msg"
    alert_maintainer "root-repo-objstore-$GARDEN" "$msg"
    : > "$OBJSTORE_ALERTED" 2>/dev/null || true
  fi
  esc_result gc-failed
  return 1
}

# --- INVARIANT D: host filesystem inode headroom ----------------------------
# This is detection + classification only. An inode-pressure repair cannot be made
# safe from `df`: cleanup first has to prove a worktree belongs to a completed job,
# is not an active/resumable checkout, and is removed through its owning git repo.
# Keep that destructive decision outside an unattended every-host timer.
guard_inode_headroom() {
  local path="$GARDEN_ROOT_GUARD_INODE_PATH" line fs total _used free _usep mount pct

  line="$("$GARDEN_ROOT_GUARD_DF_CMD" -Pi -- "$path" 2>/dev/null \
    | awk 'NR > 1 { line=$0 } END { print line }' || true)"
  read -r fs total _used free _usep mount _ <<< "$line"
  if [[ ! "${total:-}" =~ ^[0-9]+$ ]] || [ "${total:-0}" -eq 0 ] \
     || [[ ! "${free:-}" =~ ^[0-9]+$ ]]; then
    log "INODE-CHECK-UNKNOWN: could not classify inode headroom for $path from 'df -Pi' output; leaving alert state unchanged"
    return 1
  fi

  pct="$(awk -v f="$free" -v t="$total" 'BEGIN { printf "%.2f", (f * 100) / t }')"
  if awk -v p="$pct" -v minimum="$GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT" \
       'BEGIN { exit !(p < minimum) }'; then
    local msg="host filesystem inode headroom is CRITICAL: filesystem $fs mounted at ${mount:-<unknown>} (the filesystem backing $path) has $free/$total free inodes (${pct}%), below the ${GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT}% threshold. This is filesystem-wide inode exhaustion, distinct from byte-capacity exhaustion: filesystem and git writes can fail with 'No space left on device' even while bytes remain. No automatic deletion was attempted because cleanup must first prove each candidate worktree's job is in jobs/tada and remove it through the owning worktree mechanism. Review completed per-job worktrees and their node_modules, then reclaim a bounded batch and re-check 'df -i $path'. (host=$GARDEN)"
    log "INODE-HEADROOM-LOW: $msg"
    alert_maintainer "$INODE_ALERT_KEY" "$msg"
    return 1
  fi

  alert_maintainer_clear "$INODE_ALERT_KEY" \
    "host filesystem inode headroom recovered to ${pct}% ($free/$total free on $fs, threshold ${GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT}%; host=$GARDEN)."
  return 0
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
  # D is a host-filesystem invariant, not a git-repo invariant. Run it first so a
  # damaged/missing root checkout cannot suppress the warning that explains why git
  # writes are failing in the first place.
  local inode_ok=0
  guard_inode_headroom && inode_ok=1

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

  if [ "$origin_ok" -eq 1 ] && [ "$head_ok" -eq 1 ] && [ "$obj_ok" -eq 1 ] \
     && [ "$inode_ok" -eq 1 ]; then
    log "root repo healthy: origin canonical, HEAD detached at a $GARDEN_MAIN_BRANCH ancestor, object store maintainable, host inode headroom above ${GARDEN_ROOT_GUARD_MIN_FREE_INODE_PERCENT}%"
  fi
  return 0
}

guard_root_repo
