Fix round 7 for kriscendobot/minion.town PR #241 is pushed, but CI is still pending: the `Claude harness (amd64)` check never started within the one-hour deadline. So this round ends as **still-pending**, not done.

**What changed**
- **`numRuns` failure (blocking):** `numRuns` is fast-check's own option name, so it can't be spelled out. I added the documented `// spell-out-exempt -- \`numRuns\` is the fast-check parameter name.` marker on line 1 of `test/claude-onboarding-freeze.test.ts`. Two other test files already use the same marker for the same reason (`test/accounts.test.ts` and `test/accounts-dynamodb-bonds.test.ts`). After the commit, the spell-out-identifiers probe passes against `origin/main`.
- **Comment advisory at `src/endo/claude/agents.ts:766` (non-blocking):** left unchanged. Most of that comment already existed and was moved; only its last sentence is new. It explains things the code doesn't show: the race with a concurrent `create`, why the rollback claims the key, that the directory child is removed first, and the fallback where the slot stays held and `dismiss(name)` cleans it up. It doesn't just repeat the code.
- **Push:** follow-up commit `e28a4590` ("test(claude): mark fast-check numRuns as an external name (#241)"), pushed with `safe-push-pr-head.sh` (the head moved forward from `1c13a03f`).

**CI**
- `changes`, `test` and `Claude harness (arm64)` pass.
- `Claude harness (amd64)` was still queued at 09:39Z, about an hour after the push.
- The self-hosted `ci-minion-town` runner looks stalled: six runs were queued and none were running, and `changes` waited about 17 minutes to start. That matches the known stall when the runner token hits GitHub's rate limit, which clears on the hourly reset. Nothing here points to a problem with the PR's code.
- My first one-hour wait was stopped by the tool's 10-minute limit, so I re-ran `ci-wait-merge.sh` in five shorter rounds (540–570s each), covering the rest of the hour. Every round returned rc 4 (still pending).

**Follow-up:** the driver should re-post this stage, or move on to panel-8 once the amd64 harness check finishes.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr241-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1232188 cached reads)
- Output: 6454 tokens
- Cost: $0.8508296000000002
- Wall-clock: 4136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
