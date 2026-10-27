Fix round 2 for endojs/endo-but-for-bots#1349 is done. The one failing finding is fixed and pushed, and CI is green (16 of 16 checks) after one rerun of a failing macOS test job.

**What I changed** (branch `build/hardened-text-codecs-shim`, commit `4c315e84c0`)
- **Failing finding fixed (`no-inline-import-jsdoc`):** in `packages/ses/src-xs/lockdown-shim.js` I added a top-of-file `/** @import {makeCompartmentConstructor} from '../src/compartment.js' */` tag. The `@type` now reads `ReturnType<typeof makeCompartmentConstructor> | undefined` instead of the inline `import(...)`. A local `tsc` run on `packages/ses/tsconfig.json` passed with no errors.
- **Comment-length warning on `browser-test/tests/text-codecs.spec.js:19` (non-blocking):** I kept the comment. It explains why the test simulates the restricted properties and why that does nothing on Chromium before version 138 (endojs/endo#3369), which the nearby code doesn't make obvious.
- I pushed with `safe-push-pr-head.sh`; the branch moved forward from `2d325f6ff1` to `4c315e84c0`.

**CI**
- The first wait ended red (rc 3) on one job, `test (22.x, macos-15)`. The only failing test was the daemon's `endo › lifecycle`, with `write EPIPE` coming from the CapTP connection. My change only touches a type comment, so it can't cause that; it looks like a flaky test on the macOS runner.
- I reran just the failed job once (`gh run rerun 40497821968 --failed`). The second wait returned rc 0: 16 of 16 checks passed, none failed.

**Follow-ups:** the macOS daemon `lifecycle` EPIPE failure is a possible recurring flake and may be worth tracking if it shows up on other PRs. The panel-3 re-review is the gauntlet driver's next step.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20261027-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1182716 cached reads)
- Output: 4920 tokens
- Cost: $0.8116552
- Wall-clock: 990s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
