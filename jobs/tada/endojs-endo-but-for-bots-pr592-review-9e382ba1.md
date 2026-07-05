Done. Completion report follows.

## Completion report — `endojs-endo-but-for-bots-pr592-review-9e382ba1`

**Directive:** kriskowal's `CHANGES_REQUESTED` review on PR #592 (review 4631951294). Review body was empty; it carried one inline comment on `packages/platform/src/fs-node/watch-directory.js`: *"We need a test covering this… separate instances so that they have to communicate through the underlying platform's notification system. That test should be conditionally marked `failing` for the `test:xs` case since Rust's cap-std is incomplete."* That inline comment was the entire unit of work; I resolved it.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer resolution) → proceeded. (Two peer gardeners are working *other* review IDs on the same PR; I did not touch their worktrees.)

**What I did** (isolated project worktree, PR head `factor-watchdirectory-to-endo-platform`):
- Added two `EndoMount.followNameChanges` tests to `packages/daemon/test/mount.test.js` (+119 lines, plus a small bounded `raceNextChange` helper):
  1. **Live delivery across separate instances** — two independent `EndoMount` instances over one real directory; a write by one is observed by the other *only* through node `fs.watch` (what `@endo/platform`'s `makeWatchDirectory` wraps). This fills a genuine gap: the pre-existing sibling test covers only the initial snapshot, which never fires the watcher.
  2. **XS cap-std counterpart, pinned `test.failing`** — same scenario on the Rust/XS file powers, where `watchDirectory` is the immediately-closed graceful-degradation stub, so the separate write never arrives. The marker documents the known cap-std gap and self-clears (forcing its own removal) once cap-std grows a real watch.
- Chose powers-parameterized marking (node vs. `makeXsFilePowers()` directly) over `ENDO_BIN`-gating, because these mount tests construct powers directly and don't vary by supervisor — a runner-gated `test.failing` would erroneously error under `test:rust`. Mirrors the existing `mount-platform-fs-conformance` idiom. I flagged this reasoning to the reviewer and offered to switch to the runner-gated form if preferred.

**Verification:** confirmed in-environment that node `fs.watch` delivers a separate writer's directory change (the live test's premise); `node --check` clean on the modified file. The full daemon suite wasn't run locally (needs workspace install + built Rust `endor` for the XS path) — CI is the authority. The `test.failing` premise is already asserted by the existing passing `XS watchDirectory degrades to an immediately-closed stream` conformance test.

**Pushed & communicated:** commit `ce2cf14bc` → PR head (clean push). Inline reply on the thread (`#discussion_r3525596912`) + top-level summary comment (`#issuecomment-4887520381`).

**Follow-ups:** none blocking. PR remains DRAFT (its lifecycle is a separate step). If the maintainer prefers runner-gated `test.failing`, that's a one-line change I offered to make.
