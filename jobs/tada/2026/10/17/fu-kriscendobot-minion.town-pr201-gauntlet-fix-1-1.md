I fixed the new Docker CI step on PR #201 (https://github.com/kriscendobot/minion.town/pull/201), and it now passes on the self-hosted runner. All 18 browser checks passed and none failed.

**The problem.** The job's earlier CI run sat in the queue, so I read the step and found a failure before it could run:
- **Node version:** the Playwright `v1.64.1-noble` image ships Node 24. The pinned Endo daemon depends on `better-sqlite3`, a native module that `yarn install` builds on the runner under the job's Node 22. Node 24 won't load a module built for Node 22, so the demo would have crashed as soon as it started the daemon.
- **Runner user ID:** running the container as the runner's user (`--user "$(id -u):$(id -g)"` with `HOME=/tmp`) looked fine, and it ran without trouble.

**The fix.** Commit `30c73db` on `feat/new-clip-inventory`, in `.github/workflows/test.yml`:
- The step mounts the job's own Node 22 into the container read-only and puts it first on `PATH`, so the demo, `npx tsx` and the daemon all run on the same Node that built the module.
- It prints `node --version` before the install, so the log shows which Node ran.
- The step's comment explains why.

Locally, the workflow still parses and `test/endo-pin-drift.test.ts` passes (7/7).

**Verification.** I cancelled the queued run on the old commit (39034097296) so it wouldn't hold the single runner. In the new run, 39039053930, the `test` job passed on runner `ci-minion-town-0fdb85b6-20261017T145242Z`:
- Step 18, "Test New Clip in a real browser", printed `v22.23.3` and passed in about 2m20s.
- Every earlier step also passed, including the three live-daemon tests.

**Follow-up.** When I stopped, that run's two Claude harness image builds hadn't finished: amd64 was running and arm64 was still queued. They don't touch this step, but the PR's overall status depends on them. The runner handles one job at a time and the queue is long, so expect delays.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `3e82b6b64f60c68b0e6a74dc5e7c460108a43520`; this job presented `30c73db460d51ed638a7a43a9151025d24881ddc`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-kriscendobot-minion.town-pr201-gauntlet-fix-1-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 14 tokens (578064 cached reads)
- Output: 2481 tokens
- Cost: $1.2425743999999999 (1 engagement(s) unpriced)
- Wall-clock: 2436s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
