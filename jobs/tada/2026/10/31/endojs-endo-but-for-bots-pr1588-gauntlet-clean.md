I've added two tests, but CI didn't reach a terminal state within the hour, so this stage is still pending. One finished check has already failed on what looks like a known flake in a package this PR doesn't touch.

**Coverage pass on the touched packages** (`packages/fetch`, `packages/confined-fetch`):
- **`@endo/fetch`:** 6 tests pass, 97.7% of lines covered (75.9% of branches). The only uncovered lines (`src/index.js:114-115,128-129`) are defensive guards that check whether the reader has `cancel` / `releaseLock`. Nothing there is orphaned.
- **`@endo/confined-fetch`:** 98.3% of lines covered before this pass. The real gap was `src/transport.js`, at 93%: nothing tested the null-body response or a read failing mid-stream (where the transport cancels and re-throws), nor a call with no options.
- I added two tests to `packages/confined-fetch/test/boundary.test.js`:
  - "a null-body response settles the base cancellation", which calls the transport with no options;
  - "a base stream that fails mid-read settles the base cancellation".
- `transport.js` is now 100% covered by lines. All 11 boundary tests pass, eslint reports no errors (one existing warning) and prettier is clean.
- The few remaining uncovered lines in `confined-fetch` are a logging catch when saving the policy fails (`service.js:116`), a re-throw in `store.js:85-86`, and a conditional spread. I left them alone. The `store.js` re-throw is not dead, but its non-"file not found" errors still end up treated as "unparseable" by `readConfig`/`readBindings`. That is a semantics question for the PR, not dead code to remove.
- No dead code was orphaned by the change.

**Push:** commit `c7c8dde154` ("test(confined-fetch): cover the transport's null-body and mid-read failure settlement") went to `endo-fetch-split-confined-plugin` via `safe-push-pr-head.sh`, moving it on from `6aa23df64c`.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 4 after the 3600s deadline, with 4 of 36 checks still pending. Those are the `test` matrix jobs (22.x/24.x × ubuntu/macos-15), which were still waiting to start.
- **Failed:** `cover (22.x, ubuntu-latest)`. The only failing test is `@endo/sandbox` › `bwrap timeout and repeated cancellation reap process groups` ("process group 13193 survived bounded cleanup", `packages/sandbox/test/bwrap.test.js:266`). This PR doesn't touch `@endo/sandbox`. It matches the known flake in the bwrap tests, whose fix is #1566.
- **What the next attempt should do:** once run 41180705290 completes, rerun just that job with `gh run rerun 41180705290 -R endojs/endo-but-for-bots --failed`, rather than treating it as a red caused by this PR.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2765916 cached reads)
- Output: 11072 tokens
- Cost: $1.4045592
- Wall-clock: 3815s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
