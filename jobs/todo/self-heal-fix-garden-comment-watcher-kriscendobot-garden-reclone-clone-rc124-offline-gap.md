---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`reclone_clone()` in `scripts/jobs/common.sh` (~line 4302-4316) treats a clone failure as fatal unless `_fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"` matches known transport-error text. Failure signature observed: `clone of git@github.com:kriscendobot/garden.git (journal2) into .../comment-watcher/verify timed out (>45s)`, `failed after 1 attempt(s) (last rc=124)` with no trailing `: <stderr>` (i.e. `GARDEN_CLONE_STDERR` was empty — `timeout`'s SIGTERM killed `git clone` before it wrote anything), so the offline-text check never fires and the function falls through to `die`, exiting rc=1 and taking down the whole `garden-comment-watcher@kriscendobot-garden` service on an ordinary network stall.

Three sibling call sites in the same file (common.sh:6820, 6838, 6874) already guard the equivalent decision with `[ "$rc" -eq 124 ] || [ "$rc" -eq 137 ] || _fetch_stderr_is_offline "$GARDEN_FETCH_STDERR"` before falling back to a hard failure — `reclone_clone` is the one caller of `bounded_clone`'s offline-classification pattern that omits the rc check.

Fix: capture `bounded_clone`'s exit code in `reclone_clone` (it's currently discarded — the function only inspects `$GARDEN_CLONE_STDERR`) and extend the offline-classification condition to also treat rc 124/137 as offline, matching the established pattern:

```sh
reclone_clone() {
  local dir="$1" remote="$2" clone_rc
  rm -rf "$dir"
  if GARDEN_CLONE_RETRIES=1 bounded_clone "$remote" "$dir" --single-branch --branch "$JOURNAL_BRANCH"; then
    return 0
  fi
  clone_rc=$?
  if [ "$clone_rc" -eq 124 ] || [ "$clone_rc" -eq 137 ] || _fetch_stderr_is_offline "$GARDEN_CLONE_STDERR"; then
    log "offline; skipping tick (rc=$GARDEN_OFFLINE_RC): clone of $remote ($JOURNAL_BRANCH) into $dir"
    exit "$GARDEN_OFFLINE_RC"
  fi
  die "clone of $remote ($JOURNAL_BRANCH) into $dir failed${GARDEN_CLONE_STDERR:+: $GARDEN_CLONE_STDERR}"
}
```

Verify no other caller of `reclone_clone` relies on it dying on a bare timeout, and check `scripts/jobs/self-heal-run.sh`'s belt-and-suspenders grep (referenced near common.sh:4474) doesn't need a parallel update for this path.
