#!/bin/bash
# deploy-tree-swap.sh — advance the deployed checkout's working tree ATOMICALLY.
#
# SOURCE this; do not execute it. It provides one function,
# atomic_advance_tree, used by the deliberate deploy (deploy-garden.sh) in place
# of an in-place `git merge --ff-only`.
#
# WHY THIS EXISTS — the rc=127 storm (confirmed 2026-07-03 00:54; earlier as the
# deploy-sync rc-127 loop of 2026-06-27). Every long-lived `garden-*` unit execs
# its script straight from the checkout by absolute path
# (`/bin/bash @GARDEN_ROOT@/scripts/jobs/<x>.sh`). A plain `git merge --ff-only`
# rewrites the working tree file-by-file, and git updates a modified file by
# UNLINKING the old inode and CREATing a fresh one it then fills — a window in
# which an opener sees ENOENT or a half-written script. Any unit that execs during
# that window — a timer-driven oneshot firing (issue-inbox, watchman,
# mirror-closer, repo-watcher), the gardener-scaler re-`enable --now`ing an exited
# gardener, or a long-running service crash-restarting — opens a partial/absent
# script and dies rc=127, marked Failed, dropping that tick's work.
#
# THE FIX — swap each changed file with rename(2), which is ATOMIC within a
# filesystem: a concurrent open()/exec sees EITHER the whole old inode OR the whole
# new inode, never a partial one and never ENOENT. We stage every new blob into a
# temp file ALONGSIDE its destination (same directory ⇒ same filesystem ⇒ rename is
# atomic), then swap them all in. No unit is stopped and no timer is masked, so no
# singleton tick is dropped — a tick that fires mid-swap simply execs a complete
# (old-or-new) script. The whole-directory rename the design doc floats is not
# available here: $GARDEN_ROOT is the bot's bind-mounted home and cannot itself be
# renamed, so we advance atomically at per-file granularity instead.
#
# Expects common.sh already sourced by the caller (for `log`).

# atomic_advance_tree <repo> <old_sha> <up_sha>
#
# Advance <repo>'s working tree and git metadata from <old_sha> to <up_sha> (a
# verified fast-forward — the caller checks ancestry and cleanliness first) without
# ever exposing a partial file. Returns:
#   0  advanced cleanly (working tree == up_sha, HEAD/index == up_sha, tree clean)
#   1  aborted BEFORE touching any live file (safe: the tree is untouched)
#   2  failed PART-WAY through the swap (some files new, some old) — dangerous;
#      the caller must surface it, and the next deploy's dirty/divergence check
#      will refuse to advance over the half-state until it is resolved by hand.
#
# Strategy: two phases. Phase 1 extracts every added/modified/type-changed blob to
# a sibling temp file — the slow, failure-prone work — touching NO live path, so a
# phase-1 failure leaves the tree exactly as it was (rc 1). Phase 2 is only fast
# rename/unlink syscalls; a failure there is the rare rc-2 half-state.
atomic_advance_tree() {
  local repo="${1:?repo}" old="${2:?old_sha}" up="${3:?up_sha}"
  local meta path newmode newsha status dir tmp target
  local -a stage_src=() stage_dst=() del_paths=()

  _ats_cleanup_temps() {
    local f
    for f in "${stage_src[@]}"; do rm -f "$f"; done
  }

  # --- Phase 1: stage every incoming blob as a sibling temp file (no live path
  # is touched). Parse `git diff --raw --no-renames -z`: each record is
  # `<meta>\0<path>\0`, meta = ":mode1 mode2 sha1 sha2 STATUS". --no-renames keeps
  # the status set to A/M/D/T (no R/C to special-case).
  while IFS= read -r -d '' meta && IFS= read -r -d '' path; do
    # meta (colon-stripped) = "<mode1> <mode2> <sha1> <sha2> <STATUS>"; we need
    # the incoming mode/sha and the status (`_` discards the old-side fields).
    read -r _ newmode _ newsha status <<<"${meta#:}"
    case "$status" in
      D)
        del_paths+=("$path")
        ;;
      A|M|T)
        dir="$repo/$(dirname "$path")"
        mkdir -p "$dir" || { log "tree-swap: mkdir '$dir' failed"; _ats_cleanup_temps; return 1; }
        # A temp name unique across the whole run (global index), colocated with the
        # destination so the later rename is same-filesystem and thus atomic.
        tmp="$dir/.deploy-swap.$$.${#stage_dst[@]}"
        case "$newmode" in
          120000)
            # Symlink: the blob content IS the link target. Create the link at the
            # temp name (atomic swap-in happens in phase 2).
            target="$(git -C "$repo" cat-file blob "$newsha" 2>/dev/null)" \
              || { log "tree-swap: cat-file (symlink) '$path' failed"; _ats_cleanup_temps; return 1; }
            ln -sfn "$target" "$tmp" \
              || { log "tree-swap: symlink stage '$path' failed"; _ats_cleanup_temps; return 1; }
            ;;
          160000)
            # Gitlink (submodule): nothing lives in the working tree to place. The
            # index is fixed by the `git reset --mixed` at the end. Skip.
            continue
            ;;
          *)
            if ! git -C "$repo" cat-file blob "$newsha" > "$tmp" 2>/dev/null; then
              log "tree-swap: cat-file blob '$path' ($newsha) failed"
              rm -f "$tmp"; _ats_cleanup_temps; return 1
            fi
            case "$newmode" in
              100755) chmod 755 "$tmp" ;;
              *)      chmod 644 "$tmp" ;;
            esac
            ;;
        esac
        stage_src+=("$tmp"); stage_dst+=("$repo/$path")
        ;;
      *)
        # With --no-renames only A/M/D/T should appear; anything else is unexpected
        # — bail BEFORE touching a live file rather than guess.
        log "tree-swap: unexpected diff status '$status' for '$path'; aborting the atomic advance"
        _ats_cleanup_temps
        return 1
        ;;
    esac
  done < <(git -C "$repo" diff --raw --no-renames -z "$old" "$up")

  # --- Phase 2: swap every staged blob into place with an atomic rename, then
  # apply deletions. These are fast syscalls; a failure here is the rare rc-2
  # half-state (some paths advanced, some not), which the next deploy's dirty
  # check refuses to advance over.
  local i
  for i in "${!stage_dst[@]}"; do
    if ! mv -f "${stage_src[$i]}" "${stage_dst[$i]}"; then
      log "tree-swap: FATAL rename '${stage_src[$i]}' -> '${stage_dst[$i]}' failed mid-swap; tree is HALF-ADVANCED"
      return 2
    fi
  done
  # Deletions last. A removed path corresponds to a retired unit that the deploy's
  # reconcile step (install-units enable-services) disables; unlink is inherently
  # non-atomic but only affects a path that is going away, never a script the live
  # fleet keeps exec'ing.
  for path in "${del_paths[@]}"; do
    rm -f "$repo/$path"
  done

  # --- Advance the git metadata WITHOUT touching the working tree we just
  # populated. `git reset --mixed` moves HEAD and resets the index to <up> but
  # leaves every working-tree file exactly as placed, so `git status` is clean.
  if ! git -C "$repo" reset --mixed --quiet "$up"; then
    log "tree-swap: 'git reset --mixed $up' failed after the working tree was advanced; metadata is STALE"
    return 2
  fi
  return 0
}
