scripts/jobs/deploy-tree-swap.sh
Phase 2 of `atomic_advance_tree` swaps staged blobs into place in raw-diff order, which leaves the deployed tree a mix of old and new files during the pass. A newly-ADDED helper (status A) can therefore land AFTER an updated caller (status M) that references it, giving a window where the new caller execs a not-yet-present callee. This exactly produced the 2026-07-17T11:38 rc=127 storm: `ci-watcher.sh` (modified) ran against `handlers/ci-rollup-gh.sh` (added in commit 1a9448720c) before the handler was renamed into place — 30+ `No such file or directory` warnings — and the concurrent `gardener/6`, `cleric/8`, and `comment-watcher/kriskowal-garden` rc=127 FATALs are the same shape (an updated entry-point landing before a newly-added sourced helper). Fix: in phase 2, apply all ADDITIONS (files whose destination path did not exist in `<old>`) BEFORE modifications/type-changes, so a brand-new helper always exists before any updated caller that references it is swapped in. Additions-first is purely safe: an added path has no live counterpart, so landing it early can never clobber a script the fleet is exec'ing. Keep deletions last (already correct). The `stage_src`/`stage_dst` arrays already know each path's status at stage time — carry the A-vs-M distinction through so phase 2 can order the renames. This closes the whole class of "updated caller sees an added callee that hasn't landed yet" deploy races without stopping or masking any unit.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: cleric
  claimed_at: 2026-07-17T11:52:47Z
