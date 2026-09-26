Completed. Report follows.

---

## Completion report — PR #442 review by kriskowal (`pullrequestreview-4605966130`)

**Scope of the review:** `CHANGES_REQUESTED` with an empty top-level body and exactly **one** inline comment (the whole review = that one ask). No other items.

**The ask** (on `packages/daemon-cas/test/content-store.test.js`, `makeFilePowers`): *"Please investigate using `@endo/platform` for these powers. These are likely duplicative and not the subject of this test, nor necessary to mock."*

**Investigation:** `@endo/platform` owned the `ContentStoreFilePowers` / `ContentStoreCryptoPowers` **contracts** (`fs/lite/types`) but shipped **no concrete Node implementation** of them. The only implementation lived in `@endo/daemon`'s `daemon-node-powers.js`, which the test cannot import — the daemon depends on `@endo/daemon-cas`, not the reverse. So the test's ~100-line `makeFilePowers`/`makeCryptoPowers` mock was a duplicate of daemon code, and the correct home for a reusable factory is the shared floor (`@endo/platform`).

**Change (pushed to `feat/daemon-cas-extraction`, 2 commits):**
- New `packages/platform/src/fs-node/content-store-powers.js` exporting `makeContentStoreFilePowers` + `makeContentStoreCryptoPowers` (canonical `node:fs`/`node:crypto` implementations, the same subset `daemon-node-powers.js` builds), re-exported from `@endo/platform/fs/node`.
- `content-store.test.js` now injects those, deleting the bespoke mock (net −92 lines across the diff).
- `@endo/daemon-cas` drops its now-unused `@endo/exo-stream` / `@endo/stream-node` devDeps; `yarn.lock` updated in a separate `chore:` commit; changeset notes the new `@endo/platform` minor export.

**Verification (in a full install):** all 9 `@endo/daemon-cas` ava tests pass against the real powers; `eslint` clean on every changed file; `tsc` reports **nothing** on the changed files (the remaining cross-package `lib`-version diagnostics in `base64`/`eventual-send`/etc. are pre-existing sandbox/TS-lib noise, unrelated to this change and present on the base). The daemon call site is untouched. `better-sqlite3`'s native build fails in this sandbox (blocked bin shims) but is irrelevant to these packages.

**Communication:** posted an inline reply on the review thread (`#discussion_r3503506661`) and a top-level summary comment (`#issuecomment-4850593340`) with the finding, the change, and the SHA.

**Follow-ups / notes:** The daemon's own `daemon-node-powers.js` could later consume this same platform factory to dedupe its side too, but that's outside this test-focused comment and would widen the PR — left for the maintainer to direct. Project worktree torn down.
