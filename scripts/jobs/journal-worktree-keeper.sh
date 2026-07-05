#!/bin/bash
# journal-worktree-keeper.sh — keep the shared $GARDEN_ROOT/journal worktree
# reconciled to origin/journal2, advancing a clean tree by fast-forward and
# AUTONOMOUSLY SELF-HEALING a diverged one LOSSLESSLY (never paging for the
# common case).
#
# The journal/ worktree is the human-and-agent-readable checkout of the journal2
# branch (the job board + message bus). The scripted pipeline never advances it:
# every producer/gardener works in its OWN per-instance clone under $GARDEN_STATE
# or $GARDEN_SCRATCH, and common.sh INTENTIONALLY never touches journal/ (a naive
# `reset --hard` there would autostash/clobber a live agent's uncommitted WIP —
# see the stored feedback feedback_journal_reset_clobbers_garden and
# feedback_journal_poll_daemon_race). So the worktree only advances when a human
# or an agent happens to fast-forward it by hand, and otherwise drifts unbounded:
# observed 6000+ commits behind origin/journal2 with 3 stray superseded local-only
# commits from 2026-06-25/26 and a handful of dirty library-staging paths. Every
# agent that lands in journal/ then pays a detect-and-route-around tax, and the lag
# is itself a `reset --hard` foot-gun.
#
# The 2026-07-01 rewrite. The prior keeper's ONLY response to a diverged worktree
# was to page the maintainer inbox and leave the tree untouched. That paged the
# maintainer HOURLY for 11+ hours about the SAME superseded, losslessly-resolvable
# divergence while never fixing it — a watchdog that pages for a self-resolvable
# wedge is itself the defect. The maintainer already established the opposite
# principle for the watchman's dirty-tree wedges (2026-06-27: "the watchmen needs
# to solve these problems autonomously and the maintainers do not need to be in
# the loop" — see wedge-resolve.sh / resolve-wedge.sh). This keeper applies the
# same principle to the journal worktree, with the strong lossless safeguards the
# live-tree hazard demands:
#
#   * bounded fetch of origin/journal2 (the timeout + retry helper from
#     common.sh; git has no IO timeout of its own, so a half-open connection can
#     hang a fetch forever). A failing fetch (offline, DNS) is logged and the
#     worktree is left where it is — never wedged;
#   * a clean, strictly-behind tree advances by `git merge --ff-only`, exactly as
#     before;
#   * a DIVERGED tree (dirty and/or local-ahead) is SELF-HEALED losslessly:
#       1. BACK UP everything first — the local-ahead commits (`git format-patch
#          origin/journal2..HEAD`) and a byte copy of every dirty tracked file and
#          every untracked file — into a host-local backup dir OUTSIDE the
#          worktree ($GARDEN_STATE/journal-worktree-keeper/backups/<host>-<ts>).
#          Nothing is discarded before it is captured; the backup IS the
#          losslessness guarantee, so even genuine WIP survives the reset.
#       2. GATE on no-active-writer: refuse to touch the tree while a live agent is
#          editing it — no process holds the worktree as its cwd AND the dirty/
#          untracked file set is mtime-stable across a short settle window. An
#          active writer aborts the heal (it is transient; the next tick heals).
#       3. If (and only if) the backup captured everything AND no writer is active,
#          `git reset --hard origin/journal2` and remove the backed-up untracked
#          files, returning the worktree to the current tip. Log what was backed up.
#       4. Page the maintainer ONLY for GENUINELY UNPRESERVABLE WIP — a path the
#          backup could not capture (disk/permission failure). That is the rare
#          real case; the lossless case NEVER pages again.
#
# Runs on garden-journal-worktree-keeper.timer (~30m), the same cadence as
# clone-keeper. Quiet on the no-op path (a one-line "already fresh"); a
# fast-forward, a self-heal (with a backup-location line), an aborted heal, and an
# unpreservable-WIP page are all logged.
#
# Stale-gitdir guard (2026-07-03). BEFORE any fetch/reconcile, the keeper verifies
# the worktree's git linkage resolves and, if not, repairs it. A garden root that
# MOVED (e.g. /home/kris/garden2 -> /home/kris) leaves the journal worktree's two
# cross-pointers — $JW/.git's "gitdir:" line and
# $GARDEN_ROOT/.git/worktrees/journal/gitdir — pointing under the old, now-absent
# path, so every `git -C $JW …` dies with "fatal: not a git repository" and any
# service that resolves the journal remote (orchestrate, gardener, gardener-scaler)
# exits 1. `git -C $GARDEN_ROOT worktree repair $JW` rewrites both pointer files to
# correct absolute paths; it is idempotent (a no-op when already healthy) and
# lossless (it touches only the pointer files, never the tree), so this guard needs
# none of the active-writer/backup gating the divergence path uses.
#
# Defensive prune every tick (2026-07-04). A root relocation ALSO leaves a STALE
# sibling worktree REGISTRATION behind — $GARDEN_ROOT/.git/worktrees/<name> whose
# working tree is the vanished garden2/* path (`git worktree list` marks it
# `prunable`). The recurrence bit twice in one day: a worktree whose gitdir CURRENTLY
# RESOLVES but with a lingering stale registration was declared "already healthy" and
# never pruned, so the stale entry survived; a later git op re-resolved the
# cross-pointers onto it and re-broke the linkage within the hour. The keeper now runs
# a live-worktree-preserving prune (common.sh `prune_worktrees_preserving_live`)
# UNCONDITIONALLY at the top of the guard, before the health check — so a stale
# registration can never accumulate to be latched onto, and the prune runs BEFORE
# `worktree repair` (the order that empirically makes the fix stick).
#
# Live per-job worktrees are EXCLUDED from the prune (2026-07-05, endolinbot2). A raw
# `git worktree prune` is NOT safe under a garden-root RELOCATION: an `mv` of the tree
# (garden2 -> the current root) stales every admin entry's recorded path at once, so
# `git worktree list` marks a LIVE gardener-wt-* worktree `prunable` alongside the
# stale journal sibling, and a raw prune deletes the running job's admin entry as
# collateral — corrupting any job that commits from its assigned worktree. So the
# prune is routed through prune_worktrees_preserving_live, which REPAIRS every live
# per-job checkout first (re-linking it so it is no longer prunable) and only then
# prunes the genuinely-dead entries. It is idempotent and cheap. Repair success
# is gated on BOTH `rev-parse --git-dir` AND `config --get remote.origin.url`
# resolving through the worktree — the failure surfaced as the gitdir dying AND the
# downstream "no JOURNAL_REMOTE set and no origin", so a re-link that does not also
# restore origin has not closed the window. On success the keeper logs a REPAIRED:
# line; it falls through to the WARN-and-skip only when $JW is genuinely absent or
# the repair (and the owning-checkout rebuild below) could not restore linkage.
#
# Owning-checkout-DELETED rebuild (2026-07-03). `worktree repair` re-links only when
# a matching admin entry (`$GARDEN_ROOT/.git/worktrees/journal`) still exists. When
# the checkout that OWNED the worktree was REMOVED — the root moved
# (/home/kris -> /home/kris/garden2) and garden2 was later deleted, or the whole
# `$GARDEN_ROOT/.git/worktrees/` dir was wiped — there is no admin entry to repair
# against and `worktree repair` fails outright ("… .git file does not reference a
# repository"). The guard then REBUILDS the worktree losslessly: gate on
# no-active-writer (never rm -rf a dir a live agent holds as cwd — defer to the next
# tick if one is present), prune the stale admin records, back up every file still
# present under $JW into the same host-local backup dir, remove the stale $JW dir,
# and re-`worktree add --force` it off $JOURNAL_BRANCH (origin/$JOURNAL_BRANCH when
# the local branch is absent), then fall through to the normal fetch/reconcile. The
# rebuild is HARD-GUARDED to only ever touch $GARDEN_ROOT/journal and only after a
# completed backup, and it pages the maintainer solely when the tree could not be
# captured or the re-add failed.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
GARDEN_TAG="journal-worktree-keeper"

# The shared journal worktree. Overridable for tests; defaults to the real one.
: "${GARDEN_JOURNAL_WORKTREE:=$GARDEN_ROOT/journal}"
JW="$GARDEN_JOURNAL_WORKTREE"

# Self-heal knobs (all overridable for tests):
#   GARDEN_JW_BACKUP_DIR   root for lossless backups, OUTSIDE the worktree.
#   GARDEN_JW_SETTLE_SECS  mtime-stability window for the active-writer probe.
#   GARDEN_JW_SELF_HEAL    set to 0 to fall back to the old page-and-leave posture.
#   GARDEN_JW_WRITER_PROBE optional external command; exit 0 => "active writer"
#                          (lets a test force the active-writer branch
#                          deterministically). Default: the built-in probe below.
: "${GARDEN_JW_BACKUP_DIR:=$GARDEN_STATE/journal-worktree-keeper/backups}"
: "${GARDEN_JW_SETTLE_SECS:=3}"
: "${GARDEN_JW_SELF_HEAL:=1}"

# --- active-writer probe -----------------------------------------------------
# True (returns 0) when a live agent is editing the worktree, so the heal must
# abort. Two independent signals, either of which means "hands off":
#   (a) some process holds the worktree (or a path under it) as its cwd — scan
#       /proc/*/cwd symlinks;
#   (b) the dirty/untracked file set is NOT mtime-stable across a short settle
#       window (an editor is mid-write).
# An external GARDEN_JW_WRITER_PROBE overrides both (a test can force either
# verdict); its exit status is taken verbatim (0 => active writer).
jw_active_writer() {  # jw_active_writer <jw-abs> <path-list-file>
  local jw="$1" list="$2"
  if [ -n "${GARDEN_JW_WRITER_PROBE:-}" ]; then
    "$GARDEN_JW_WRITER_PROBE" "$jw" && return 0 || return 1
  fi
  # (a) any process cwd inside the worktree? readlink each /proc/*/cwd; a match
  # on $jw itself or a subpath means a live writer is parked there.
  local link pid
  for link in /proc/[0-9]*/cwd; do
    pid="${link#/proc/}"; pid="${pid%/cwd}"
    [ "$pid" = "$$" ] && continue
    local tgt; tgt="$(readlink "$link" 2>/dev/null || true)"
    [ -n "$tgt" ] || continue
    case "$tgt/" in
      "$jw"/*) log "active writer: pid $pid has cwd $tgt inside the worktree"; return 0 ;;
    esac
  done
  # (b) mtime-stability of the dirty/untracked set across the settle window.
  local sig1 sig2
  sig1="$(jw_mtime_sig "$jw" "$list")"
  sleep "$GARDEN_JW_SETTLE_SECS"
  sig2="$(jw_mtime_sig "$jw" "$list")"
  if [ "$sig1" != "$sig2" ]; then
    log "active writer: dirty-file mtimes changed across the ${GARDEN_JW_SETTLE_SECS}s settle window"
    return 0
  fi
  return 1
}

# A stable signature of the dirty/untracked file set: one "path|mtime|size" line
# per path (missing paths collapse to "path|-|-", so a create/delete mid-window
# also perturbs the signature).
jw_mtime_sig() {  # jw_mtime_sig <jw-abs> <path-list-file>
  local jw="$1" list="$2" p meta
  while IFS= read -r p; do
    [ -n "$p" ] || continue
    if [ -e "$jw/$p" ]; then
      meta="$(stat -c '%Y|%s' "$jw/$p" 2>/dev/null || echo '-|-')"
    else
      meta='-|-'
    fi
    printf '%s|%s\n' "$p" "$meta"
  done < "$list"
}

# --- lossless self-heal of a diverged worktree -------------------------------
# Back up every local-ahead commit and every dirty/untracked path, verify the
# capture, gate on no-active-writer, then reset --hard + remove the backed-up
# untracked files. Pages the maintainer ONLY when the backup could not capture
# something (genuinely unpreservable WIP). Returns 0 in every case (a heal, an
# aborted heal, or an unpreservable page) so a tick is never marked Failed.
heal_diverged_worktree() {  # heal_diverged_worktree <jw> <ahead> <behind> <dirty-count>
  local jw="$1" ahead="$2" behind="$3" dirty_count="$4"

  # Enumerate the two path classes we must preserve.
  local tmp; tmp="$(mktemp -d "${TMPDIR:-/tmp}/jw-heal.XXXXXX")"
  local tracked_list="$tmp/tracked" untracked_list="$tmp/untracked" all_list="$tmp/all"
  git -C "$jw" diff --name-only HEAD    > "$tracked_list"  2>/dev/null || : > "$tracked_list"
  git -C "$jw" ls-files --others --exclude-standard > "$untracked_list" 2>/dev/null || : > "$untracked_list"
  cat "$tracked_list" "$untracked_list" > "$all_list"

  local jw_abs; jw_abs="$(cd "$jw" && pwd)"
  local ts backup
  ts="$(date -u +%Y%m%dT%H%M%SZ 2>/dev/null || echo unknown)"
  backup="$GARDEN_JW_BACKUP_DIR/${GARDEN}-${ts}"

  # ---- 1. BACK UP everything, verifying each capture. ----------------------
  # A single capture failure marks the WIP unpreservable: we page and DO NOT
  # reset (the rare real case). Everything else is recoverable from $backup.
  local unpreservable=""
  if ! mkdir -p "$backup/files" "$backup/patches" 2>/dev/null; then
    unpreservable="cannot create backup dir $backup"
  fi

  if [ -z "$unpreservable" ] && [ "$ahead" -gt 0 ]; then
    # Capture the local-ahead commits as patches + a readable log. format-patch
    # writing zero files (despite ahead>0) is itself a capture failure.
    if git -C "$jw" format-patch -o "$backup/patches" "origin/$JOURNAL_BRANCH..HEAD" >/dev/null 2>&1; then
      git -C "$jw" log --oneline "origin/$JOURNAL_BRANCH..HEAD" > "$backup/local-ahead.log" 2>/dev/null || true
      [ -n "$(ls -A "$backup/patches" 2>/dev/null)" ] || unpreservable="format-patch produced no patch for $ahead local-ahead commit(s)"
    else
      unpreservable="format-patch of origin/$JOURNAL_BRANCH..HEAD failed"
    fi
  fi

  # Byte-copy every dirty tracked file and every untracked file, preserving path.
  if [ -z "$unpreservable" ]; then
    local p
    while IFS= read -r p; do
      [ -n "$p" ] || continue
      [ -e "$jw/$p" ] || continue          # a staged deletion has no working file
      if ! ( mkdir -p "$backup/files/$(dirname "$p")" && cp -a "$jw/$p" "$backup/files/$p" ) 2>/dev/null; then
        unpreservable="could not back up $p"; break
      fi
    done < "$all_list"
  fi

  # A manifest so a human can see exactly what was captured.
  git -C "$jw" status --porcelain > "$backup/status.txt" 2>/dev/null || true

  if [ -n "$unpreservable" ]; then
    local msg
    msg="journal worktree $jw is DIVERGED and could NOT be self-healed losslessly: $unpreservable. Left UNTOUCHED (no reset). ${ahead} local-ahead commit(s), ${behind} behind, ${dirty_count} dirty path(s). Reconcile by hand: 'git -C $jw status'. Partial backup (if any) at $backup. (host=$GARDEN)"
    log "UNPRESERVABLE: $msg"
    alert_maintainer "journal-worktree-unpreservable-$GARDEN" "$msg"
    rm -rf "$tmp"
    return 0
  fi

  # ---- 2. GATE on no-active-writer (the final guard before the reset). -----
  if jw_active_writer "$jw_abs" "$all_list"; then
    log "SKIP: active writer in $jw; aborting self-heal this tick (transient — will heal next tick). Backup captured at $backup"
    rm -rf "$tmp"
    return 0
  fi

  # ---- 3. Everything captured, no writer: reset + clear untracked. ---------
  if ! git -C "$jw" reset --hard "origin/$JOURNAL_BRANCH" >/dev/null 2>&1; then
    local msg="journal worktree $jw self-heal reset --hard to origin/$JOURNAL_BRANCH FAILED; left as-is. Backup at $backup. (host=$GARDEN)"
    log "RESETFAIL: $msg"
    alert_maintainer "journal-worktree-resetfail-$GARDEN" "$msg"
    rm -rf "$tmp"
    return 0
  fi
  # Remove exactly the untracked files we backed up (targeted, never a blanket
  # `git clean` that could take a non-colliding file we chose not to preserve).
  local u
  while IFS= read -r u; do
    [ -n "$u" ] || continue
    git -C "$jw" clean -fdq -- "$u" >/dev/null 2>&1 || rm -f "$jw/$u" 2>/dev/null || true
  done < "$untracked_list"

  local tracked_n untracked_n
  tracked_n="$(grep -c . "$tracked_list" 2>/dev/null || echo 0)"
  untracked_n="$(grep -c . "$untracked_list" 2>/dev/null || echo 0)"
  log "SELF-HEALED: $jw reset to origin/$JOURNAL_BRANCH (was ${ahead} ahead, ${behind} behind, ${tracked_n} dirty tracked, ${untracked_n} untracked). Lossless backup at $backup (patches/ + files/ + status.txt). Maintainer NOT paged."
  rm -rf "$tmp"
  return 0
}

# --- stale-gitdir repair -----------------------------------------------------
# Detect and repair a stale/dangling gitdir link on the worktree BEFORE any other
# git command runs against it. Healthy = `git -C $JW rev-parse --git-dir` resolves
# AND the resolved gitdir exists on disk. When it does not (the garden root moved
# out from under the worktree's cross-pointers), a prune-BEFORE-repair pass
# (`git -C $GARDEN_ROOT worktree prune` then `worktree repair $JW`) rewrites both
# $JW/.git and $GARDEN_ROOT/.git/worktrees/journal/gitdir to correct absolute paths.
#
# The prune-first repair itself now lives in common.sh as the SHARED
# `repair_journal_worktree_gitdir` helper, so the read-side watchers (issue-inbox,
# comment, mention), which have no rebuild/backup machinery, can call the exact same
# hardened repair from their tick preamble rather than aborting a whole tick on a
# dangling gitdir. This keeper is the ONLY caller that layers the destructive
# rebuild-from-origin fallback (jw_rebuild_dangling_worktree) on top: it is the sole
# role with the lossless-backup + active-writer gating that a rm-rf-and-re-add
# demands. A genuinely missing worktree ($JW absent) returns 1 from the shared helper
# and falls into the rebuild path (whose own hard guard leaves a non-canonical path
# untouched).
jw_repair_gitdir() {  # jw_repair_gitdir <jw>
  local jw="$1"
  # A GENUINELY ABSENT worktree dir goes straight to the rebuild: the old
  # `[ -d "$jw" ] || return 0` short-circuit declared a deleted journal/ checkout
  # "healthy", so the rebuild machinery below was unreachable and the keeper
  # WARN-skipped ("missing or unlinked … skipping") every tick forever — exactly
  # the case jw_rebuild_dangling_worktree's own guards were written to handle
  # (its active-writer probe explicitly skips when the dir is missing, and its
  # hard guard confines the rebuild to the canonical $GARDEN_ROOT/journal path).
  if [ ! -d "$jw" ]; then
    jw_rebuild_dangling_worktree "$jw"
    return
  fi
  # STEP 1 — the shared, non-destructive prune-first repair (common.sh). Returns 0
  # when the gitdir re-links (stale sibling registrations pruned first); 1 when even
  # that could not restore the linkage because the owning admin entry is gone.
  repair_journal_worktree_gitdir "$jw" && return 0
  # STEP 2 — the OWNING CHECKOUT is gone, so there is no admin entry for
  # `worktree repair` to re-link against. Rebuild the worktree from origin.
  jw_rebuild_dangling_worktree "$jw"
}

# --- origin self-heal --------------------------------------------------------
# Re-add a MISSING remote.origin.url on the worktree from the canonical journal
# remote. This closes the transient window where a one-worktree config gap — $JW
# loses remote.origin.url — otherwise sends every git op that resolves the journal
# remote down the "no origin" fatal path, the 2026-07-03 15:50-15:51Z cascade that
# FATAL-stormed every gardener/monitor/ci-watcher on claim at once. The keeper
# already self-heals the worktree's BRANCH (fast-forward / diverged reset); this
# heals its REMOTE the same way. Only acts when the worktree repo opens fine
# (gitdir resolves — a pure config gap, NOT a dangling gitdir, which is
# jw_repair_gitdir's job) and origin is actually absent on $jw.
#
# The URL comes from journal_remote (common.sh), the SAME canonical resolver every
# other consumer uses, whose fallback order is: an explicit $JOURNAL_REMOTE ->
# the worktree's own origin -> the persisted per-host cache ($JOURNAL_REMOTE_CACHE,
# the companion job's last-good value, which survives a reset/deploy) -> the owning
# $GARDEN_ROOT's origin. Reaching only into $GARDEN_ROOT (the prior implementation)
# missed both an explicit $JOURNAL_REMOTE override AND the cache, so it could not
# recover in the window where the root origin was momentarily gone too but the cache
# still held the last-good URL. journal_remote may die() when nothing resolves at
# all; the command substitution + `|| true` confine that exit to the subshell (and
# 2>/dev/null suppresses its FATAL log), so a genuinely unresolvable remote leaves
# the repair to the caller's own gate rather than killing the keeper.
# Idempotent + best-effort.
jw_ensure_origin() {  # jw_ensure_origin <jw>
  local jw="$1" url
  # Only a valid, openable repo missing ONLY its origin is our case: a broken
  # gitdir is jw_repair_gitdir's, and a present origin is a no-op.
  git -C "$jw" rev-parse --git-dir >/dev/null 2>&1 || return 0
  git -C "$jw" config --get remote.origin.url >/dev/null 2>&1 && return 0
  # Canonical resolution: $JOURNAL_REMOTE -> worktree origin -> persisted cache ->
  # $GARDEN_ROOT origin (see journal_remote). Confine a possible die() to the subshell.
  url="$(journal_remote 2>/dev/null || true)"
  [ -n "$url" ] || return 0
  # `remote add` when the remote is wholly absent; fall back to setting the url
  # directly when an origin section exists without a url.
  if git -C "$jw" remote add origin "$url" >/dev/null 2>&1 \
     || git -C "$jw" config remote.origin.url "$url" >/dev/null 2>&1; then
    log "REPAIRED: re-added missing remote.origin.url on $jw from the canonical journal remote ($url)"
  fi
  return 0
}

# --- rebuild a dangling worktree whose owning checkout was deleted ------------
# The `worktree repair` fallback: when the admin entry is gone, re-establish the
# worktree from origin LOSSLESSLY. Prune stale admin records, back up every file
# still present under $jw, remove the stale dir, and re-`worktree add --force` off
# $JOURNAL_BRANCH. Always returns 0 (the caller re-checks `rev-parse --git-dir`);
# pages the maintainer only when the tree could not be captured or the re-add
# failed. HARD-GUARDED to only ever act on the canonical $GARDEN_ROOT/journal path,
# and only ever removes $jw after a completed backup — it can touch nothing else.
jw_rebuild_dangling_worktree() {  # jw_rebuild_dangling_worktree <jw>
  local jw="$1"

  # HARD GUARD: only the canonical journal worktree, whose owning repo
  # ($GARDEN_ROOT) must itself be a valid repo with an origin remote (we re-add the
  # worktree from it). Any mismatch: refuse, leave the tree untouched.
  if [ "$jw" != "$GARDEN_ROOT/journal" ]; then
    log "WARN: gitdir on $jw is broken; refusing to rebuild a path that is not \$GARDEN_ROOT/journal"
    return 0
  fi
  if ! git -C "$GARDEN_ROOT" rev-parse --git-dir >/dev/null 2>&1 \
     || ! git -C "$GARDEN_ROOT" config --get remote.origin.url >/dev/null 2>&1; then
    log "WARN: cannot rebuild $jw — \$GARDEN_ROOT ($GARDEN_ROOT) is not a repo with an origin remote"
    return 0
  fi

  # ACTIVE-WRITER GATE: never rm -rf a dir a live agent is parked in. Reuse the
  # divergence path's probe; a dangling worktree can't enumerate a dirty set, so
  # feed it an EMPTY path list — that neutralizes probe signal (b) (mtime settle,
  # trivially stable) and leaves signal (a) (a process holding $jw as cwd), the
  # only meaningful writer signal here. A MISSING $jw dir has no writer (skip the
  # probe entirely). An active writer aborts THIS tick losslessly; the dangling
  # gitdir already makes the tree unusable, so the next tick rebuilds once the
  # writer leaves — no page, no data loss.
  if [ -d "$jw" ]; then
    local jw_abs empty_list
    jw_abs="$(cd "$jw" && pwd)"
    empty_list="$(mktemp "${TMPDIR:-/tmp}/jw-rebuild-writers.XXXXXX")"
    if jw_active_writer "$jw_abs" "$empty_list"; then
      rm -f "$empty_list"
      log "SKIP: active writer in $jw; deferring dangling-gitdir rebuild this tick (transient — will rebuild next tick)"
      return 0
    fi
    rm -f "$empty_list"
  fi

  local dangling=""
  [ -f "$jw/.git" ] && dangling="$(sed -n 's/^gitdir: *//p' "$jw/.git" 2>/dev/null | head -1)"
  log "journal worktree gitdir on $jw is dangling${dangling:+ ($dangling gone)} and unrepairable; rebuilding from origin/$JOURNAL_BRANCH"
  # Live-worktree-preserving prune (common.sh): a garden-root relocation stales the
  # journal sibling AND every live gardener-wt-* entry at once, so a raw prune here
  # would delete a running job's admin entry as collateral (the endolinbot2 defect).
  prune_worktrees_preserving_live "$GARDEN_ROOT"

  # LOSSLESS backup of every file still present under $jw. git is inoperable here,
  # so byte-copy the tree directly (jw_backup_raw_tree). Same host-local, outside-
  # the-worktree convention as the diverged-tree self-heal. If it cannot be
  # captured, the WIP is unpreservable: leave the tree UNTOUCHED and page.
  local ts backup
  ts="$(date -u +%Y%m%dT%H%M%SZ 2>/dev/null || echo unknown)"
  backup="$GARDEN_JW_BACKUP_DIR/${GARDEN}-${ts}"
  if ! jw_backup_raw_tree "$jw" "$backup"; then
    local msg="journal worktree $jw has a DANGLING gitdir${dangling:+ ($dangling gone)} and its files could NOT be backed up before rebuild; left UNTOUCHED (no removal). Reconcile by hand. (host=$GARDEN)"
    log "UNPRESERVABLE: $msg"
    alert_maintainer "journal-worktree-gitdir-unpreservable-$GARDEN" "$msg"
    return 0
  fi

  # Remove the stale worktree dir (identity hard-guarded above, backup complete),
  # then re-establish it.
  if ! rm -rf "$jw" 2>/dev/null; then
    local msg="journal worktree $jw has a dangling gitdir and its stale dir could NOT be removed for rebuild; left as-is. Lossless backup at $backup. (host=$GARDEN)"
    log "GITDIR-RMFAIL: $msg"
    alert_maintainer "journal-worktree-gitdir-rmfail-$GARDEN" "$msg"
    return 0
  fi

  # Re-establish on $JOURNAL_BRANCH: prefer the existing local branch; if absent,
  # fetch origin and create the branch from origin/$JOURNAL_BRANCH.
  local added=1
  if git -C "$GARDEN_ROOT" rev-parse --verify --quiet "refs/heads/$JOURNAL_BRANCH" >/dev/null 2>&1; then
    git -C "$GARDEN_ROOT" worktree add --force "$jw" "$JOURNAL_BRANCH" >/dev/null 2>&1 && added=0
  fi
  if [ "$added" -ne 0 ]; then
    git -C "$GARDEN_ROOT" fetch -q origin "$JOURNAL_BRANCH" >/dev/null 2>&1 || true
    git -C "$GARDEN_ROOT" worktree add --force -B "$JOURNAL_BRANCH" "$jw" "origin/$JOURNAL_BRANCH" >/dev/null 2>&1 && added=0
  fi

  if [ "$added" -ne 0 ] || ! git -C "$jw" rev-parse --git-dir >/dev/null 2>&1; then
    local msg="journal worktree $jw had a DANGLING gitdir; prune + re-add from origin/$JOURNAL_BRANCH FAILED. Files backed up at $backup. Reconcile by hand: 'git -C $GARDEN_ROOT worktree add --force $jw $JOURNAL_BRANCH'. (host=$GARDEN)"
    log "GITDIR-REPAIR-FAIL: $msg"
    alert_maintainer "journal-worktree-gitdir-repairfail-$GARDEN" "$msg"
    return 0
  fi

  log "rebuilt journal worktree $jw on $JOURNAL_BRANCH from origin (was a dangling gitdir${dangling:+ -> $dangling}); lossless backup of the prior tree at $backup"
  return 0
}

# --- lossless raw-tree backup (git inoperable) -------------------------------
# Byte-copy every top-level entry present under $jw EXCEPT the broken .git gitlink,
# preserving each subtree, into <backup>/files. Used by the owning-checkout-deleted
# rebuild, where git cannot open the repo so the diverged-tree backup (format-patch
# + ls-files) is impossible. `find -print0` includes dotfiles and tolerates odd
# names; no glob/shopt state is touched. Returns non-zero if any present entry
# could not be captured — the tree is then unpreservable and must NOT be destroyed.
jw_backup_raw_tree() {  # jw_backup_raw_tree <jw> <backup-dir>
  local jw="$1" backup="$2" entry rc=0
  mkdir -p "$backup/files" 2>/dev/null || return 1
  ls -la "$jw" > "$backup/listing.txt" 2>/dev/null || true   # a human-readable manifest
  while IFS= read -r -d '' entry; do
    [ "$(basename "$entry")" = ".git" ] && continue
    cp -a "$entry" "$backup/files/" 2>/dev/null || { rc=1; break; }
  done < <(find "$jw" -mindepth 1 -maxdepth 1 -print0 2>/dev/null)
  return "$rc"
}

# Fetch + reconcile the journal worktree. Every failure path logs and returns 0
# so a transient hiccup never marks the tick Failed; a clean tree fast-forwards,
# a diverged tree self-heals losslessly.
keep_journal_worktree() {
  # Repair a stale/dangling gitdir link first, so the keeper's own git commands
  # below don't themselves fail on the broken cross-pointers.
  jw_repair_gitdir "$JW"

  # Self-heal a missing remote.origin.url the same way we self-heal the branch:
  # a worktree whose repo opens fine but whose origin momentarily vanished would
  # otherwise skip below AND fatal every git op that resolves the journal remote
  # (the fleet-wide "no origin" cascade). Re-add it from $GARDEN_ROOT's origin.
  jw_ensure_origin "$JW"

  # If jw_repair_gitdir could not restore the linkage (a genuinely missing
  # worktree, or a repair that did not stick), skip this tick rather than let the
  # keeper's own git commands below die on the broken pointers. Require BOTH the
  # gitdir and origin to resolve through the worktree — a re-link that leaves origin
  # unreadable still trips the downstream "no origin" fatal, so it is not "repaired".
  if ! git -C "$JW" rev-parse --git-dir >/dev/null 2>&1 \
     || ! git -C "$JW" config --get remote.origin.url >/dev/null 2>&1; then
    log "WARN: journal worktree missing or unlinked at $JW (gitdir/origin unresolved after repair); skipping"
    return 0
  fi

  # Bounded, timeout-wrapped, retrying fetch of origin/$JOURNAL_BRANCH (the
  # common.sh helper). A non-zero return is a connectivity hiccup: leave the
  # worktree untouched and let the next tick catch up.
  if ! journal_fetch "$JW"; then
    log "fetch of origin/$JOURNAL_BRANCH failed (offline?); leaving $JW untouched"
    return 0
  fi

  local remote head
  remote="$(git -C "$JW" rev-parse --verify --quiet "refs/remotes/origin/$JOURNAL_BRANCH" || true)"
  head="$(git -C "$JW" rev-parse --verify --quiet HEAD || true)"
  if [ -z "$remote" ] || [ -z "$head" ]; then
    log "WARN: could not resolve HEAD or origin/$JOURNAL_BRANCH in $JW; skipping"
    return 0
  fi

  # Classify the tree: dirty (uncommitted tracked/untracked) and/or local-ahead.
  local dirty ahead behind dirty_count
  dirty="$(git -C "$JW" status --porcelain 2>/dev/null || true)"
  ahead="$(git -C "$JW" rev-list --count "origin/$JOURNAL_BRANCH..HEAD" 2>/dev/null || echo 0)"
  behind="$(git -C "$JW" rev-list --count "HEAD..origin/$JOURNAL_BRANCH" 2>/dev/null || echo 0)"
  dirty_count="$(printf '%s\n' "$dirty" | grep -c . || true)"

  # Clean AND non-ahead: either already fresh, or a safe fast-forward.
  if [ -z "$dirty" ] && [ "${ahead:-0}" -eq 0 ]; then
    if [ "$head" = "$remote" ]; then
      log "$JW: already fresh at $head"
      return 0
    fi
    # Strictly behind: a real fast-forward is safe. Use --ff-only so an unexpected
    # non-ancestor state (a race that snuck a local commit in after the gate) can
    # only refuse, never create a merge commit.
    if git -C "$JW" merge --ff-only "origin/$JOURNAL_BRANCH" >/dev/null 2>&1; then
      log "$JW: fast-forwarded $head -> $remote (${behind} commit(s))"
    else
      local msg
      msg="journal worktree $JW could not fast-forward to origin/$JOURNAL_BRANCH despite a clean, non-ahead tree; left UNTOUCHED. Inspect 'git -C $JW status'. (host=$GARDEN)"
      log "STALE: $msg"
      alert_maintainer "journal-worktree-fffail-$GARDEN" "$msg"
    fi
    return 0
  fi

  # DIVERGED: dirty and/or local-ahead. Self-heal it losslessly (back up, gate on
  # no-active-writer, reset). This REPLACES the old page-and-leave-untouched
  # posture that paged the maintainer hourly for the same superseded divergence.
  # The heal pages only for genuinely unpreservable WIP.
  if [ "${GARDEN_JW_SELF_HEAL}" = 1 ]; then
    log "DIVERGED: $JW is ${ahead:-0} local-ahead, ${behind} behind, ${dirty_count} dirty path(s); attempting lossless self-heal"
    heal_diverged_worktree "$JW" "${ahead:-0}" "${behind:-0}" "${dirty_count:-0}"
    return 0
  fi

  # Legacy opt-out (GARDEN_JW_SELF_HEAL=0): the old conservative page-and-leave.
  local msg
  msg="journal worktree $JW has DIVERGED from origin/$JOURNAL_BRANCH and was left UNTOUCHED (self-heal disabled): ${ahead:-0} local-ahead commit(s), ${behind} behind, ${dirty_count} dirty path(s). Reconcile by hand: 'git -C $JW status'. (host=$GARDEN)"
  log "DIVERGED: $msg"
  alert_maintainer "journal-worktree-divergence-$GARDEN" "$msg"
  return 0
}

keep_journal_worktree
