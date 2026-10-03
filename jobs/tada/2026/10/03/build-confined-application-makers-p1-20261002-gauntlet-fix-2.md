# Gauntlet fix round 2: endojs/endo-but-for-bots#1417

I applied all nine must-fix items from the panel's round-2 verdict, pushed, and CI on the new head `608cafdbcf` is green: 33 of 33 checks passed. The new tests pass locally (35/35), eslint shows no errors and `tsc` is clean.

**This push rewrote history.** Must-fix item 5 needed it, so I used `safe-push-pr-head.sh --mode rewrite` and the head moved from `2871bdb014` to `608cafdbcf`. I folded the commit that adds the exports entry (`2871bdb014`) into the commit whose test imports that path (now `736d3004e9`). Run alone, every commit in the range passes the test file (18 → 20 → 20 → 27 → 35 → 35 → 35).

**What changed on the PR head:**
- **`29741d9067` (`fix(platform)`)**, covering items 1–4 and 8:
  - **Directories:** `maybeRead` now returns `undefined` for a directory, matching Node. `read` refuses one with an "is not a file" error.
  - **Outside the root:** for a location outside the root, `maybeRead` returns `undefined` and `canonical` returns it unchanged. This stops a missing optional dependency from failing the whole capture. `read` still refuses such locations.
  - **Package names:** by default `canonical` returns the location unchanged. Locations built from segments are encoded the way Node's `pathToFileURL` does it, so names like `@scope/p+q` keep their spelling.
  - **Hook result:** `canonical` now copies the hook's result once into a frozen array before checking and using it. A custom `.map` or a getter can no longer slip a different path past the check.
  - **Should-fix items folded in:** the root must be normalized, and `fileURLToPath` keeps a trailing slash and decodes an encoded root.
  - **Tests:** fast-check property tests check that every lookup only ever sees validated path segments, and that the path encoding agrees with Node's. There are also new example tests for each fix.
- **`686ac02b43` (`chore: Update yarn.lock`):** adds `@fast-check/ava` as a dev dependency.
- **`608cafdbcf` (`docs(platform)`):** adds the new `@endo/platform/fs/tree-read-powers` entry point to the README, and the design doc now names that path (item 7 plus a should-fix).
- **PR description (item 6):** rewritten to match the current head, with the redundant sections removed.
- **Summary comment (item 9):** posted, mapping each must-fix item to its commit, with verification status: https://github.com/endojs/endo-but-for-bots/pull/1417#issuecomment-5969891058

**Not done** (both were comment-only items):
- When the check that tells a missing entry from other errors fails, its error still replaces the original lookup error rather than carrying it as the cause.
- The follow-up `fix(platform)` commits still need folding into the feature commits at retcon or conductor time.

I did not re-run the panel; the driver posts panel round 3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p1-20261002-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2231671 cached reads)
- Output: 22874 tokens
- Cost: $1.5769902000000002
- Wall-clock: 2233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
