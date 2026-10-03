# Fix round 1: endojs/endo-but-for-bots PR #1417

I applied all four must-fix items from the panel, and CI is now green on all 33 checks. One leg failed on the first run and passed when re-run (details below).

I pushed two follow-up commits to `llm-confined-application-makers-p1` with `safe-push-pr-head.sh`, moving the head from `0bdf8951cb` to `2871bdb014`.

**Commit `60c90ab0b0`: `fix(platform): make tree maybeRead atomic and refuse raw NUL segments`**
- **Must-fix 1 (`maybeRead` walk):** `maybeRead` now does one lookup of the whole path, the same way `read` does, instead of asking `has` and then `lookup` one segment at a time. A new `isAbsent` walk runs only when that lookup fails. It returns `undefined` in three cases:
  - a segment is missing;
  - the entry was removed between `has` and `lookup`;
  - a segment before the last is a file rather than a directory (detected because it lacks `has`/`lookup` in `__getMethodNames__`).

  When the path is fully present, the lookup's own error is re-thrown.
- **Must-fix 1 (raw NUL):** `decodeSegment` now refuses a NUL byte after decoding, not only the percent-encoded `%00` form.
- **Should-fix items taken:** the `canonical` hook must now return string segments, and the five returned methods have `@returns` JSDoc.
- **Must-fix 4:** the test fixture's `dir` is renamed to `appPath`.
- **New tests:**
  - raw-NUL paths are refused before any lookup;
  - a file in a directory position reads as `undefined`;
  - an entry removed mid-lookup reads as `undefined`;
  - a lookup error on an entry that is present is re-thrown;
  - a non-string segment from the `canonical` hook is refused;
  - the package exports the function by its own path.

  Test titles now use `JSON.stringify` so control characters print readably.

**Commit `2871bdb014`: `fix(platform): export makeTreeReadPowers by its own path`**
- **Must-fix 3:** I removed the plain re-export from `src/fs/index.js` rather than adding a `@deprecated` shim. That barrel is the live `@endo/platform/fs/lite` entry point, so marking the new function deprecated there would have been wrong. Instead, `package.json` now has its own export, `"./fs/tree-read-powers": "./src/fs/tree-read-powers.js"`, following the existing `./fs/search` entry.
- **Must-fix 2:** the changeset now names `@endo/platform/fs/tree-read-powers` and describes the separator/NUL refusal accurately.

**Local checks:** the platform package's `ava` suite passed (390 tests, including 27 in `tree-read-powers`), and `yarn lint:types` passed. `eslint` reported no errors, only existing-style `safe-await-separator` warnings. The repo-root `tsc` showed nothing for the touched files.

**CI:** the first wait ended RED (rc 3) on one leg only. `test (22.x, macos-15)` hit a timeout in `provider-http › HTTP deadline releases late readers and does not leak provider errors`. That test is in an unrelated package and failed on no other leg, so I re-ran just that job once. It passed, and `ci-wait-merge.sh` then returned rc 0 (GREEN, 0 of 33 failed).

**Follow-ups (not done, non-blocking):**
- `designs/agent-confined-application-makers.md` still says `makeTreeReadPowers` lives in `@endo/platform/fs`; it could be updated to the new path.
- Remaining should-fix items:
  - move the `TreeReadPowersOptions` typedef into `types.ts`;
  - `harden` the returned bytes;
  - add a fast-check property test;
  - trim the PR body boilerplate.
- That `provider-http` timeout may be a recurring macOS flake.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2210019 cached reads)
- Output: 16105 tokens
- Cost: $1.4489117999999994
- Wall-clock: 4309s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
