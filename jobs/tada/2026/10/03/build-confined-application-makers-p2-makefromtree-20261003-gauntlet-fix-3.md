# Gauntlet FIX round 3: endojs/endo-but-for-bots#1419

I applied both round-3 must-fix items and most of the should-fix items, and pushed them as four follow-up commits on top of `241afb9f7c`. The PR head is now `24d7deb53b7`. CI is **GREEN**: `ci-wait-merge` returned rc 0, with 33 checks and 0 failed.

## Must-fix items
- **Bare catch in layout detection (saboteur).** In `tree-layout.js`, the try now wraps `lookup` alone and `text()` runs outside it, so a marker that exists but can't be read propagates its error. A directory named `compartment-map.json` is one example. When no layout matches, the error message now includes the lookup failures it swallowed and keeps the first one as its `cause`, so a non-tree value reports its real error. A new unit test covers both cases.
  - My first attempt probed with `has()`. That turned CI red on `endo-fs-exec` (`tree-view` → `make-from-tree`) because that tree-view offers only `lookup`. Commit `24d7deb53b` fixes this with the lookup-only approach above, and both of those tests now pass locally and in CI.
  - I could not narrow the catch to "not found" errors only. Snapshot trees report a missing name with a `TypeError`, so the error type doesn't separate absence from other failures.
- **PR title (integrator).** It is now "feat(daemon): makeFromTree runs node_modules trees (layout, entry)".

## Should-fix items
- **Mount canonical hook.** Only ENOENT and ENOTDIR from `realPath` are treated as "missing"; any other failure, such as a symlink loop, is rethrown. A new test covers both paths. The mount record now stores a `physicalPathOf` function instead of creating a throwaway `MountEntry`, and the raw `new Error` calls are now `makeError`.
- **`runningAs` timing.** `manager.js` now records `runningAs` only after the worker resolves; the run step moved into a separate `runTreeAs` function. The `treeLayoutRunningAs` map type is narrowed.
- **Trims (pruner).** I cut the design-rationale prose from the `treeLayoutRunningAs`, `makeFromTree` and `makeMountCanonical` comments, and condensed the PR body's Description bullets.
- **Deferred evidence (integrator).** The PR body now lists, as follow-up under #1339, the design's Phase 2 checks this PR doesn't deliver: XS-worker parity and pnpm workspace-link refusal.

## Not done
- **`(#1339)` in commit `68e9dac0b9`'s subject.** Fixing it means rewriting history, which this round's follow-up-commit rule doesn't allow.
- **Remaining purist items.** Dropping the `'package'` layout, a single source of truth for the layout list, a shared compartment-location walk, and narrowing `treeKind` are all left for a later round.
- **Persisted-formula fallback test.** The assessor's should-fix, a test that a formula saved without `layout` still runs as `'archive'`, is not written.

## Local verification
Run under Node 24 at `/usr/local/n/versions/node/24.21.0`; this worktree's `better-sqlite3` won't load under the default Node 22.
- `tsc` is clean, and eslint shows 0 errors (warnings only).
- `tree-layout` 13/13, `capture-node-modules` 15/15, and the `endo.test.js` makeFromTree tests all pass.
- The `endo-fs-exec` daemon tests pass 2/2 after pointing them at a shorter tmp path, because the default socket path is too long on this host. That edit was not committed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 158 tokens (8070611 cached reads)
- Output: 30391 tokens
- Cost: $3.311790200000001
- Wall-clock: 3199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
