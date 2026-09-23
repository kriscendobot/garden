The job is already fully complete: a prior attempt (session lost to reaper requeue) landed commit `f5f59c3307c` on `origin/main2`, which is the current HEAD. All four asks are addressed and every deploy test suite passes. Nothing remains to redo or push.

## Completion report

**State on arrival:** Fresh worktree off `origin/main2`, working tree clean. HEAD == `origin/main2` == `f5f59c3307c` *"fix(rolling-deploy): pin deploys so a moving main2 cannot strand a canary"* — a prior attempt of this job committed and pushed the complete fix before it was reaped. I re-derived this from git history and verified the pushed code and tests rather than redoing the work.

**What the landed fix does (all four asks):**

1. **Advanced-target strand fixed.** `self-deploy.sh`: when the leader's release is an *ancestor* of this host's upgrade-ready tip, the follower deploys the **released sha, pinned** (via `GARDEN_DEPLOY_TARGET`) — not the newer tip, which would put uncovered commits on the canary and publish a `deployed_sha` the conductor cannot recognize (a false stuck/failed canary). A release the host already runs is treated as stale (HOLD). This is the safe choice under canary semantics: the canary runs exactly the sha the leader validated, and the conductor re-releases the newer tip on its next settled roll. `rolling-deploy.sh` also adds **catch-up**: a current leader re-releases a present follower left behind.

2. **Why the leader advanced itself explained (was NOT a rolling-deploy ordering bug).** The leader reached `0558c12a` via a **hand-run `deploy-garden.sh` override** — one minute after `0558c12a` landed, off the conductor cadence, with no roll-completion record. The follower's upgrade-ready (`0558c12a`) never matched its release token (`d1bb5185`), and a now-current leader had nothing to roll, so it held forever. Hardened anyway: `rolling-deploy.sh` now **pins the leader's own deploy to the validated target** (not the moving tip) and records a roll complete **only when the deployed sha reads back as the target** — fixing the related bug where a DEFER exited 0 and `987bb13` was falsely "completed" ten times.

3. **Stuck-canary watchdog added.** `rolling-deploy.sh` raises exactly **one coalesced notice** when a released follower stays undeployed past a 20-minute threshold, and closes it once the canary deploys.

4. **Tests + suites green.** New coverage for the advanced-target case, leader-self-before-canary (pinned deploy + no false roll completion), catch-up, the stuck-canary watchdog, and pinned deploys. Verified locally: `rolling-deploy-test.sh` 67/0, `deploy-garden-test.sh` 156/0, `deploy-release-boundary-test.sh` 18/0, `deploy-tree-swap-test.sh` 18/0, `scheduler-preflight-deploy-lag-test.sh` 14/0 — all pass, zero failures.

**Follow-ups:** None outstanding. The operational strand from 2026-09-23 (follower stuck at `987bb13`) will self-resolve once the leader's next settled roll re-releases the current tip, which the catch-up path now handles.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-rolling-deploy-canary-stranded-on-advanced-target.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 116 tokens (7183830 cached reads)
- Output: 63815 tokens
- Cost: $4.834466599999999
- Wall-clock: 745s
- Model(s): claude-opus-5-5 ×1, claude-opus-4-8 ×1

<!-- garden-usage-end -->
