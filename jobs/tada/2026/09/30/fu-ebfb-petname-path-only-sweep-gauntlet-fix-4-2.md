I added the property tests the fast-checker juror asked for in the fix-4 round to endojs/endo-but-for-bots#1390, and pushed them to `build/pet-name-path-only` as a review-feedback follow-up. Both test files pass locally.

**What changed** (commit `67f494701e`):
- **`packages/daemon/test/pet-name.test.js`**: five new property tests.
  - `namePathFrom` rejects every string with a `TypeError`, including strings with `/`, `@`, `\0` and lone surrogates. The error message suggests the one-segment array only when that array would actually be valid.
  - `namePathFrom` returns any array of valid pet or special names unchanged (the same array object).
  - `namePathFrom` rejects any array that contains one invalid segment (empty, `.`, `..`, a `/` or `\0`, or over 255 characters).
  - `petNamePathFrom` always splits a path so that `prefixPath` plus `petName` rebuilds it exactly.
  - `petNamePathFrom` rejects a special name in the last position, and rejects every string.
- **`packages/agent-tools/test/daemon.test.js`**: two async property tests. `toPetNamePath` isn't exported, so they go through `makeDaemonEvaluate`. They check that any string `resultName`, global name or `petName` is passed on as a single segment and never split, and that any array is passed on unchanged.
- **Dependencies**: `fast-check ^4.10.2` is now a devDependency of `@endo/daemon` and `@endo/agent-tools`. `yarn.lock` is in its own `chore: Update yarn.lock` commit (`5762b151c2`).

**Checks run:**
- Tests: ava passes, 47/47 in `pet-name.test.js` and 5/5 in `daemon.test.js`.
- Lint and formatting: eslint shows no errors, only an old `@ts-nocheck` warning in the daemon test file. Prettier is clean.
- Types: the agent-tools `tsc` passes, and the repo-root `tsc -p tsconfig.json` reported nothing for the two changed files.

**Notes:**
- A peer pushed `970f27de73` (a lal test) while I was working. I rebased onto it and then pushed without a force.
- `yarn install` changed the file mode of `packages/relay-server/src/index.js`. I reverted that before committing.
- The juror's earlier finding 1, property tests for `isValidName`, was not part of this job and is not done. It could be a small follow-up if the maintainer wants it.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `b915238ab3ed9b1a6d47ff599d216681050aa969`; this job presented `5762b151c24963b0d2edb95e63c1a31f26323c7a`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer received a deduplicated stale-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-ebfb-petname-path-only-sweep-gauntlet-fix-4-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1388996 cached reads)
- Output: 10001 tokens
- Cost: $1.0376432
- Wall-clock: 176s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
