The clean stage of PR #197 (kriscendobot/minion.town) is still pending. I pushed one small cleanup, but CI never started on the self-hosted runner within the 3600 s window, so I'm not marking clean as done.

**Starting state:** the PR was open and not a draft, with head `8cd365a`. This host's PAT can't read the PR's check status, so I polled the GitHub Actions runs API instead. Both CI runs on that head ("test (typecheck + vitest)" and "clip frame browser gate") had been queued since 17:07Z.

**Coverage pass:** I installed the coverage tool temporarily (`npm i --no-save @vitest/coverage-v8@2.1.9`, nothing added to `package.json`), measured `deploy/aws/www/shell.js` under `test/shell-clip.test.ts`, and checked which lines the PR added that the tests don't reach.
- **Uncovered:** all the uncovered added statements are in `bootstrap()`, the browser-only setup code. A Node unit test can't reach it; the PR's Playwright browser test covers it in Chromium, Firefox and WebKit.
- **Dead code removed:** the only other uncovered added branch was the `if (watched === null) return;` check in `createLiveFrameWatch().loaded`, and it can never change anything. Every path that clears `watched` also clears `timer`, so the timer check after it already does nothing in that case. I removed it in commit `962b72c` and pushed it with `safe-push-pr-head.sh` (`8cd365a` → `962b72c`).
- **Tests:** `npm run typecheck` is clean and the shell tests pass. One test fails in the full `npm test` run: `test/git-remote/capability.test.ts > projectPartition > propagates a git failure rather than reporting the ref absent`. It fails the same way without my change, so it isn't caused by this PR.

**CI:** `ci-wait-merge.sh --no-merge` with a 3600 s deadline returned rc 4: both runs on `962b72c` stayed queued for the whole hour and never started. The `ci-minion-town` runner has a backlog of queued runs from other branches, and runs were briefly completing at about 19:38Z. After that nothing was in progress, so the runner may be stalled or offline. This host's PAT can't list runners to confirm.

**Follow-up:** the next attempt at this stage should wait on CI for `962b72c`. If runs are still not starting, someone with runner access should check the `ci-minion-town` runner (see skill `minion-town-ci-runner-switch`); the CI timeout itself is not a code failure.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 120 tokens (3665106 cached reads)
- Output: 21754 tokens
- Cost: $2.1894612000000007
- Wall-clock: 7638s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
