---
handed-off: kriscendobot-garden-pr81-postdeploy-pty-5119818493-report-r2
deliverable-complete: false
---
The pty test hasn't run yet. This attempt posted it and handed the rest of the work to a successor job, so no new PR #81 comment has been posted.

**Checks done**
- PR #81 is merged as `4767705b28d522b591eddbd3b47976273c5e1853`.
- On this host (`endolin-garden2-5bcdff64`) the deployed SHA is `d5fb51b1440`. `git merge-base --is-ancestor` passes (run only in this job's worktree), so the merge is deployed here.
- The leader `endolin-garden-ece02cb4` is at `36def9fd9e8`, which also contains the merge.
- `oros-studio-garden-ce242c49` is still at `e036bb8e065`, which does not contain the merge. A test claimed there would silently run headless.

**What I posted**
- **Test job `pty-lane-assay-rev5119818493-r2`**: posted with `post-job.sh` with the required frontmatter (`provider: anthropic`, `lane: pty`, `role: assayer`, `handler-timeout: 7200`). It covers every requested step: the lane proof, reading the deployed implementation, running `pty-context-test.sh` with its pass count, a live `pty-context-read.sh` read, the host and deployed SHA, and the failure/completion signals.
  - `post-job.sh` rewrote `tier: minion` to `tier: mentor` (with `fallback-tier: minion`) when it stored the job.
  - I first pinned it to the leader, but the leader's only monk was busy on a long ironhorse job and the test sat in `todo/` for over 9 minutes. I re-pinned it to `requires: host=endolin-garden2-5bcdff64` with a direct push to `journal2` (`e9180779`).
  - This host has one monk and this job was holding it, so the test can only run once this job ends.
- **Successor `kriscendobot-garden-pr81-postdeploy-pty-5119818493-report-r2`**: posted pinned to oros, which has 4 monks and only needs to poll and comment. It will:
  - watch r2 until it reaches `jobs/tada/`, for up to about 150 minutes;
  - read its report and post exactly one comment on PR #81 through a body file, whatever the outcome;
  - emit the orchestration-failure signal if the test doesn't pass.
- Both jobs are confirmed in `todo/` on origin with the pins above.

**Things you should know**
- **The earlier PR comment is out of date.** Comment 5881384178 (00:37Z) reported the round-1 test (`pty-lane-assay-rev5119818493-r1`) as failed. That job later finished around 02:40Z on a resumed second session and reported PASSED: a fresh reader result (exit 0, 5% used) and 16 passed / 0 failed. Nobody has corrected the comment yet; the successor is told to include the correction.
- **`GARDEN_PTY_LANE` doesn't exist.** The deployed lane never sets it. The test job therefore accepts `GARDEN_PTY_REPORT_FILE` (set only by the lane's `run.sh`) plus a fresh context reading as proof it ran interactively.
- **A duplicate retry job is still waiting.** `todo/kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260928T215136Z` belongs to an earlier retry chain. If a worker claims it, it will post another test job and comment. It's in `todo/` rather than `plan/`, so `withdraw-plan.sh` can't remove it; you may want to pull it by hand.
- This host is also listed in `deploy/roll`, and this job was holding up its deploy; ending it frees both.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-pr81-postdeploy-pty-5119818493-20260929T173327Z.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2112109 cached reads)
- Output: 14740 tokens
- Cost: $1.3216058
- Wall-clock: 823s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
