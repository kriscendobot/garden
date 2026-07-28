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

  # Stalled-deploy watch (informational; never blocks the healthy path).
  guard_deploy_lag "$up"

  if [ "$origin_ok" -eq 1 ] && [ "$head_ok" -eq 1 ]; then
    log "root repo healthy: origin canonical, HEAD detached at a $GARDEN_MAIN_BRANCH ancestor"
  fi
  return 0
}

guard_root_repo
