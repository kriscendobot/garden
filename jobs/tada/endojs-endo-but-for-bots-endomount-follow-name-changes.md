The work is complete. Summary of what I found and did:

---

## Completion report: `endojs-endo-but-for-bots-endomount-follow-name-changes`

**Outcome: no new PR — the design was already fully implemented and merged. The build job is a duplicate.**

### What I found
The `filesystem-watchers` design (Issue #110) is **already landed on `llm`** via **MERGED PR #277** ("feat(daemon): EndoMount.followNameChanges live entry-name stream", merged 2026-07-01, impl commit `05891375e4`). Every element the job asks for is present in the current `llm` tree:

- **`EndoMount.followNameChanges(...pathSegments)`** — `packages/daemon/src/mount.js:774-845`, the snapshot-then-diff AsyncGenerator emitting `{ add, type }` / `{ remove }` over the watcher stream, with the load-bearing `try/finally` watcher release and per-entry confinement filtering.
- **`MountInterface` guard** — `packages/daemon/src/interfaces.js:600`: `followNameChanges: M.call().rest(PathSegmentsShape).returns(M.remotable())`.
- **`FilePowers.watchDirectory` backing** — `packages/daemon/src/daemon-node-powers.js:476` (native `fs.watch` + 50 ms debounce coalescing + graceful `console.error` fallback to an immediately-closing stream when `fs.watch` is unavailable + idempotent `cancel()`), typed in `types.d.ts:1892`, with an XS stub in `bus-daemon-rust-xs-powers.js`. This exceeds the job's "polling first-cut is acceptable" floor and does not depend on the in-flight `@endo/platform` PR #592.
- **Test Plan cases** — `packages/daemon/test/endo.test.js:5292-5564` cover snapshot/alphabetical, directory-type, live add, live remove, subdirectory isolation, confinement-symlink filtering, scratch-mount parity, and watcher-release/disposal (design cases 1-7). Case 8 (daemon-restart) is the design's explicitly "weaker contract" optional and was not added.

### Verification (real execution)
Ran the focused tests and observed them pass:
- `ava --serial --match='*mount followNameChanges*' test/endo.test.js` → **8 tests passed** (snapshot alphabetical, directory type, live add, live remove, subdirectory-no-siblings, confinement symlink filter, scratch-mount parity, watcher release).
- `ava --match='*followNameChanges*' test/mount.test.js` → **1 test passed** (initial-snapshot).

Getting there required working around two environment issues (not code defects): yarn 4 skips `better-sqlite3`'s native build (ran `prebuild-install` manually), and the deep worktree path pushed the daemon's unix socket past the 108-char limit (re-ran from a short throwaway worktree). Details routed to the liaison.

### What changed
- **Journal only:** updated `plan/designs/endo-but-for-bots/filesystem-watchers.md` from `status: Not Started` → `status: Complete` (`landed_by: endojs/endo-but-for-bots#277`, `updated: 2026-07-09`) and pushed to `journal2`, so the board does not regenerate this duplicate. No change to the project repo; no PR opened.
- Sent a `message` to the liaison with two reusable lessons (stale plan-status → duplicate job; endo daemon test-env gotchas for future `verify` runs).

### Follow-ups
- None required for the feature. Optional: someone may want to add the design's case-8 (daemon-restart re-subscribe) test, which the design itself flags as a weaker, optional contract.
- Temporary verification worktrees (`scratch/e`, `scratch/journal-wt-endomount-follow`) were removed.

Self-improvement: routed to liaison — reconcile `plan/designs` status against merged PRs before posting build jobs, and capture the endo daemon test-env prerequisites (better-sqlite3 prebuild-install, short checkout path for the unix socket) in the endo-but-for-bots project README or local-verify skill.
