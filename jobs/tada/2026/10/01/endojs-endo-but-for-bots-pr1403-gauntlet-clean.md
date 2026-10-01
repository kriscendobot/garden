Clean stage for endojs/endo-but-for-bots#1403 (`@endo/inference`) is done. I added three tests, pushed them to the PR head, and CI is green on the new head: 33 of 33 checks, none failing.

**What I did**
- **Starting state:** the PR was a draft and CI was already green at head `34a4a0bc83`. I ran the coverage pass anyway, because no coverage work had been pushed yet.
- **Coverage before:** 41 tests passed, with 99.82% statements and 97.46% branches. Three gaps:
  - `classify.js:25`: the error raised when `retryAfterMs` is not a function.
  - `limits.js:39`: the check that stops `stop()` from running twice. `stop` is a public method, so this is a live guard, not dead code.
  - `usage-recorder.js:62`: `describe()` passing through to the wrapped backend.
- **Tests added** (commit `66a1be9b22`, `test(inference): …`):
  - `classify.test.js`: "a refill reader must be a function". The wrong-type value is cast to `any` so `tsc` accepts the test file.
  - `limits.test.js`: "stop is idempotent and stays quiet after an abort".
  - `usage-recorder.test.js`: "describe passes through to the wrapped backend".
- **Coverage after:** 44 tests passed, with 100% statements, branches and lines. Functions are at 95.23%; the only function never called is the default no-op `reportSinkError = () => {}`.
- **Checks:** eslint has no errors; its 7 warnings are all in lines that were already there. Prettier and the package `tsc` are clean.
- **Dead code:** I found no code the change left unused, so nothing was removed.
- **Push and CI:** I pushed with `safe-push-pr-head.sh` in advance mode, moving the head from `34a4a0bc83` to `66a1be9b22`. `ci-wait-merge.sh --no-merge` exited 0.

**Follow-ups:** none. The PR stays a draft for the next gauntlet stages.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1403-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1519947 cached reads)
- Output: 7524 tokens
- Cost: $0.9472214000000002
- Wall-clock: 2704s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
