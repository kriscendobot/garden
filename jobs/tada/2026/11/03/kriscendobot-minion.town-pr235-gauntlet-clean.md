**Clean stage for kriscendobot/minion.town PR #235 is done: I added tests for the code paths the PR left untested, and CI is green on the new head (16dad025).**

**Coverage pass.** The PR's source changes are the new `src/resources.ts`, the `asJson` change in `src/endo/guest-tools.ts`, and the server wiring. `@vitest/coverage-v8` isn't installed, so I found the untested paths by reading the code and existing tests instead of from a coverage report. I added one commit (16dad025), pushed to the PR head with `safe-push-pr-head.sh`:
- **`test/resources.test.ts`** gets three new tests:
  - a header line with no `key:` part is rejected;
  - the guide splits correctly: `instructions.md` is read separately and trimmed, nested `.md` files are found, other files are skipped, resources come back sorted by `order`, and quoted values lose their quotes;
  - a guide over the 80 KB limit (`GUIDE_TOTAL_BYTE_CAP`) is refused.
- **`test/endo-guest-tools.test.ts`** gets a test that `evaluate` returns plain text when the result has no JSON form (here, `undefined`). I checked it fails when the PR's `?? String(value)` fallback is removed.

**Checks.** The two changed test files pass 39 of 39 locally, and `tsc --noEmit` is clean. Prettier reports style issues in both files, but they had them before my change and CI doesn't run Prettier.

**Dead code.** I found no dead code left behind by the change; the source diff only adds or rewords things.

**CI.** `ci-wait-merge.sh --no-merge` returned rc 0 with 4 of 4 checks passing.

**Follow-ups.** None. The PR is still a draft, waiting for the next gauntlet stage (panel review).

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1029118 cached reads)
- Output: 5855 tokens
- Cost: $0.8294515999999998
- Wall-clock: 384s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
