I didn't need to push a fix this round: a previous attempt of this job had already addressed the panel's must-fix items. But CI on the PR head never started, because the self-hosted runner looks offline, so the result is **still-pending**.

**What was already done.** Commits `cd94f49` and `a643682` were pushed at 02:44Z, after the panel review at 00:45Z. A follow-up PR comment was posted at 02:44:53Z. I checked each must-fix item against the code:
- **Confirmed-served only:** the live frame now requires `serving === true`; an absent flag shows the inert card.
- **Exclusive type:** `FrameConfiguration` is now a live/inert union in `shell.js` and in the test shim.
- **Stale loads:** `loaded(generation)` only settles the current navigation, and there is a test for a late load from a previously selected clip.
- **Property test:** a fast-check test now covers which inputs get a live frame and which get the inert card.
- **Browser gate:** it now requires the live frame and its script before running the attack. It also has a control clip served without the framing headers, so the hostile-parent checks would fail if those headers were removed.
- **Workflow:** `browser-gate.yml` works out `HOME` at runtime instead of hardcoding `/root`.
- **Changeset (not added):** the repo has no Changesets setup and the package is private. The follow-up comment explains this.
- **Other reviewer comments:** naming, comment trimming and the base32 reuse note were should-fix only. The renames and trimming were done; the base32 port was left as is, with the reason given on the PR.

Re-running `test/shell-clip.test.ts` on head `a643682` passed 97/97.

**CI.**
- The `clip frame browser gate` workflow passed.
- `test (typecheck + vitest)` has been queued since 02:44Z, still queued at 06:22Z, and never started. It runs on the self-hosted `ci-minion-town` runner.
- Six minion.town runs across several branches are stuck the same way, which points to the runner being down rather than anything in this PR.
- I couldn't confirm the runner's state: this host's token gets a 403 on the runners API, and this host has no AWS credentials.

`ci-wait-merge.sh` was stopped by the tool's 10-minute limit before it finished. I then polled the run in the foreground up to the 3600s deadline.

**Follow-up.** I posted `minion-town-ci-runner-recover-20261018` (`requires: aws`) so a host with AWS credentials can restart or re-converge the runner and report the root cause. I first posted it with the stub role `sysop`, then corrected it to `gardener`; it is in `todo/` waiting for a host with AWS. When the driver re-posts this stage, it should go green once the runner is back.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 146 tokens (5670179 cached reads)
- Output: 34799 tokens
- Cost: $3.2290158000000004
- Wall-clock: 8318s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
