Phase 1 is done: `makeTreeReadPowers` is in `@endo/platform/fs` with segment-confinement tests, and it's open as draft PR https://github.com/endojs/endo-but-for-bots/pull/1417. All 18 new tests pass locally; I didn't run the rest of the platform test suite or wait for CI.

**PR:**
- Head branch `llm-confined-application-makers-p1`, commit `536318b59b`.
- Base is a new frozen snapshot branch `llm-e4fcd7b`, pinned at current `llm` (which already has #1340 merged), so nothing was stacked.

**What was added in `packages/platform`:**
- **`src/fs/tree-read-powers.js`:** `makeTreeReadPowers(tree, { root = 'file:///app/', canonical? })` returns `read`, `maybeRead`, `canonical`, `fileURLToPath` and `pathToFileURL`.
  - **Confinement:** every location is checked before the tree is touched. It refuses `..`, `.`, empty segments, encoded separators (`%2F`, `%5C`, `%00`), backslashes, query or fragment parts, and anything outside the root.
  - **`maybeRead`:** it checks one path segment at a time, so a missing file or a missing folder on the way returns `undefined`.
  - **`canonical`:** it returns the location unchanged unless a `canonical(segments)` hook is supplied. Whatever the hook returns must pass the same segment check.
- **`src/fs/index.js`:** exports the new function. The Node entry (`@endo/platform/fs/node`) re-exports everything from this file, so it gets it too.
- **`test/tree-read-powers.test.js`:** 18 tests against a real temporary directory. They cover reads (including percent-encoded names), a custom root, missing entries, the hook and its confinement, and path conversion. Twelve of them try to escape the tree, and each one is refused before the tree receives any `lookup` or `has` call.
- **Changeset:** `.changeset/platform-tree-read-powers.md` (minor bump for `@endo/platform`).

ESLint gives no warnings on the source file. The test file has 5 warnings about the first `await` being nested.

**Follow-ups:**
- PR #1417 needs its gauntlet (cleanup, panel review, fix loop, un-draft), which the build-completion step should set up automatically.
- Phase 2 can stack on `llm-confined-application-makers-p1` if #1417 hasn't merged by then. It covers daemon capture, the daemon's `canonical` hook for mounts using `getEntryPhysicalPath`, and `makeFromTree` gaining `layout` and `entry`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1585773 cached reads)
- Output: 13816 tokens
- Cost: $1.1448985999999997
- Wall-clock: 199s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
