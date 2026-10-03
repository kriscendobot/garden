# Gauntlet fix round 4: endojs/endo-but-for-bots PR #1417

I fixed both must-fix items and all but one should-fix item from the round-4 panel, and pushed the changes to the PR head. CI is green: `ci-wait-merge` returned rc 0, with 33 checks and none failing.

**Pushed:** head went from `4444a44691` to `e354acc765`, through `safe-push-pr-head.sh`, as three follow-up commits:
- `ed051d9a8b` `fix(platform): normalize spellings and refuse trailing-slash reads in tree read powers`
- `c350ef0fca` `chore: Update yarn.lock` (kept separate)
- `e354acc765` `docs(platform): describe tree read powers over a read-only tree`

**Must-fix:**
1. **`@returns` added.** `makeTreeReadPowers` now returns a `TreeReadPowers` type: compartment-mapper's `MaybeReadPowers<string>`, with `fileURLToPath` and `pathToFileURL` made required. The type comes from a type-only `@import` of `@endo/compartment-mapper`, which is now a new devDependency of `@endo/platform`, so `tsc` checks the result against that contract.
2. **The `tree` parameter is a `ReadableTree` only.** The module header, the design doc, the README and the changeset now all tell a caller with a `Mount` to pass `mount.readOnly()` or `await mount.snapshot()`.

**Should-fix applied:**
- **One spelling per location.** The default `canonical` now re-encodes locations, so `file:///app/m%61in.js` becomes `file:///app/main.js` whether or not a hook is set. The property test now also feeds it respelled locations.
- **Trailing slash.** `read` refuses a location ending in `/`, and `maybeRead` returns `undefined` for it.
- **`fileURLToPath` takes a `URL`** as well as a string.
- **One file-or-directory check.** A single `isFile` function is used in all three places that need it.
- **Node differences documented.** A comment now says where `maybeRead` differs from Node on `ENOTDIR`. The encoding comment now names Node's escaping instead of the WHATWG one, and a new test pins the expected encodings.
- **Windows.** The tests that compare against Node's own POSIX-path URL functions are skipped on Windows.

**Optional items also taken:** a test that `maybeRead` on a present file makes one `lookup` and no `has`; the `canonical` hook type now takes `readonly string[]`; a comment explaining why the module is a separate entry point; and rewrapped design-doc lines over 100 columns that this PR touched.

**Not done:** the request to squash the four `fix(platform):` commits into the feature commits. That rewrites history, which conflicts with the rule that fix rounds push follow-up commits, so it should happen in the cleanup before un-draft (keeping `chore: Update yarn.lock` separate).

**Fix summary comment:** posted as https://github.com/endojs/endo-but-for-bots/pull/1417#issuecomment-5972125932. It maps each round-4 item to its commit and records that the round-3 items were closed by `4444a44691`.

**Local checks:** `yarn tsc` is clean, and all 407 tests pass in `packages/platform`. Prettier is clean, and eslint reports no problems in the source file.

**CI:** the `cover (22.x, ubuntu-latest)` job failed once, in a random property test in `@endo/patterns` (`copySet › setIsSuperset`). This PR doesn't touch that package. I reran just the failed job and it passed.

**Follow-up:** do the commit squash before un-draft.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4274551 cached reads)
- Output: 26368 tokens
- Cost: $2.2238782
- Wall-clock: 2829s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
