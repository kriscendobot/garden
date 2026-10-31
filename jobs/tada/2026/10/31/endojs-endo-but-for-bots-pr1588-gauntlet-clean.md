Clean stage for PR #1588: CI is still pending, so I'm not reporting it done and the driver should re-post this stage.

- **CI before my change:** the four `test` legs (22.x and 24.x, on ubuntu and macOS) were red. The failing package was `@endo/daemon#test`, specifically `provideHttpClient composition: the rate limit is enforced per minute` in `packages/daemon/test/http-client.test.js`. I reproduced it locally.
- **Cause:** the rate limiter in `@endo/http-confine` now counts its one-minute window through the injected `delay` seam. The test only advanced the injected `now` clock, so the third fetch was still rate-limited.
- **Fix:** the test now passes a manual `delay` scheduler and releases the 60-second timers when it advances the clock. Only that test file changed. After the fix the 13 tests in the file pass locally, and the only lint output is warnings on that file.
- **Push:** commit `097a3c0d0d4` ("test(daemon): drive the http-client rate-limit window through the delay seam") went to the PR head `endo-fetch-split-confined-plugin` through `safe-push-pr-head.sh`. The previous head was `6d309585fb`.
- **Coverage pass and dead code:** I did not run a separate coverage pass or look for orphaned dead code. CI failures were the blocker, and the PR's `cover (22.x/24.x)` jobs passed on the earlier head.
- **CI on the new head:** after about 55 minutes, 32 of 36 checks were terminal with none failing. The four `test` legs were still running when the 3300s deadline hit (`ci-wait-merge` rc 4). I haven't confirmed whether the fix turned those legs green. The daemon test suite took about 49 minutes on the earlier run, which is why they run so long.
- **Follow-up:** re-post the clean stage so it can watch those four legs finish. If any is still red, check whether it is the same daemon test or another failure.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 294 tokens (12140442 cached reads)
- Output: 46589 tokens
- Cost: $4.9457236
- Wall-clock: 15147s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
