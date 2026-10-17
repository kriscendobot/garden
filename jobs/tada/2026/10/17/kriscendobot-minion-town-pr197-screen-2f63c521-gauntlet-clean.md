# Gauntlet CLEAN: kriscendobot/minion.town #197 — CI still pending

**Result: CI is still pending.** The coverage pass found nothing to add or remove, so nothing was pushed. But CI at the PR head `962b72c` hasn't started, so this stage can't be marked done.

**Coverage and dead code:**
- I made an isolated checkout of `feat/clip-live-frame` and ran `test/shell-clip.test.ts` with v8 coverage on `deploy/aws/www/shell.js`: 94/94 tests pass. Coverage of the whole file is 64% of statements and 92% of branches; much of the rest is DOM wiring.
- I checked the uncovered statements against the lines this PR adds. Every gap is inside the guarded DOM `bootstrap()` wiring (`showLive`, `showDocument`, `setCaption`, the caption lookups). The repo's unit tests skip that code by design. The real-engine browser gate (`test/browser/clip-frame-gate.ts`) runs it, and a source-text unit test already pins the order of operations in `showLive`.
- The pure functions the PR adds are all covered: `isCanonicalClipId`, `frameConfiguration`, `inertFrameConfiguration` and `createLiveFrameWatch`.
- Earlier commits on the head (`8cd365a`, `962b72c`) had already added the remaining test and dropped a redundant guard.
- Every new symbol has callers, so I found no dead code.
- `npm run typecheck` is clean.
- The coverage tool was installed with `--no-save`; the checkout has no changes.

**CI:**
- The two required runs at `962b72c` ("test (typecheck + vitest)" and "clip frame browser gate") were created at 19:38Z and were still `queued` at 22:29Z, about 2h50m later.
- No run is in progress anywhere in the repo, and 9 runs are queued. Both workflows use the self-hosted `["self-hosted","ci-minion-town"]` runner, which looks offline or wedged.
- This host's PAT gets a 403 when listing runners, so I couldn't confirm the runner state.
- On this host `ci-wait-merge.sh` was stopped by the session's background time limit before it returned a result. I watched CI through the Actions runs API instead (the PAT can't read the PR's check status).
- No run has failed, so this is not a red-CI failure.

**Follow-ups:**
- The driver should re-post this stage on a fresh budget.
- Someone with AWS or runner access needs to check the `ci-minion-town` runner (skill `minion-town-ci-runner-switch`). Until it is back, every minion.town gauntlet will stall the same way.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 150 tokens (4442623 cached reads)
- Output: 28280 tokens
- Cost: $2.8920606000000006
- Wall-clock: 9414s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
