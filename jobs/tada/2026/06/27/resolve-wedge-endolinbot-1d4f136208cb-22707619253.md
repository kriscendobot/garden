The wedge is resolved. The tree is clean of the blocking tracked changes, and `HEAD` is now a clean ancestor of `origin/main2`, so the deploy-sync/watchman fast-forward will proceed on its next tick. The script reported `stashed=0 preserved=0`, so there is no preserved WIP and no landing judgment call to make.

---

## Completion report

**Job:** `resolve-wedge-endolinbot-1d4f136208cb-22707619253` — clean the wedged shared `main2` tree on host `endolinbot`.

**What I did:** Ran `/home/kris/scripts/jobs/resolve-wedge.sh main2` against the shared `/home/kris` checkout, then verified the fast-forward is unblocked.

**What changed (all lossless, only blocking paths touched):**
- `scripts/jobs/common.sh` — redundant tracked edit byte-identical to `origin/main2`; restored via `git checkout HEAD`.
- `scripts/jobs/gardener.sh` — same; restored.
- `scripts/jobs/test/signal-kill-classifier-test.sh` — untracked copy of already-landed file; removed.
- `scripts/jobs/test/signal-kill-handler-stub.sh` — same; removed.

Resolution tally: `dropped=2 removed=2 stashed=0 preserved=0`. **No genuine WIP was stashed or preserved**, so there was no judgment call about landing work.

**Verification:** `git status` now shows no tracked dirt; `HEAD (91498ba)` is confirmed an ancestor of `origin/main2 (1d4f136)` → clean fast-forward possible. The watchman/deploy-sync will advance the tree on its next tick.

**Follow-ups:** Three untracked local artifacts remain and are **not** blocking the fast-forward (the script classified them as non-redundant, untouched): `agoric-sdk/`, `bundle-ymax0.json`, `wt-507/`. They are pre-existing local scratch (note: `agoric-sdk/` is off-limits per scope, so I left it untouched). No action needed for the wedge; left in place as genuine local state.
