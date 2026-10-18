**CI was still pending at the deadline for the clean stage of kriscendobot/minion.town#204, so this stage did not finish clean.** The driver should re-post it on a fresh budget.

- **PR:** "ci: run Claude-harness image builds only when harness inputs change". It's an open draft at head `9b952c48`, on branch `ci/harness-path-gate`.
- **Coverage pass:** nothing to do. The PR only changes `.github/workflows/test.yml` (it adds a `changes` job that decides whether the harness image matrix runs) and `DEPLOYMENT.md`. No source package is touched, so there's no coverage work and no orphaned code.
- **Pushes:** none.
- **CI:** I watched it for about an hour.
  - `test` passed: it sat queued for about 25 minutes, then ran from about 00:53 to 01:03 UTC.
  - `changes` was still queued at 01:33 UTC. The final `ci-wait-merge.sh --no-merge` check returned rc=4 (still pending).
  - My first background run of `ci-wait-merge` was stopped by the tool's background time limit, so I polled in the foreground and re-ran the script with a short deadline for the final verdict.
- **Why it's stuck:** the single self-hosted runner has a backlog of 8 queued workflow runs, some from as far back as 2026-10-17T17:26Z, and at one point none were in progress. It works through them one at a time. Since this PR edits `test.yml`, the gate counts it as a harness change, so the two harness image builds (up to 20 minutes each) will run after `changes`. The next attempt should expect a long wait.

**Follow-up:** if the queue doesn't drain, check the ci.minion.town runner. Past stalls like this have come from GitHub rate-limiting the runner's shared token. The core API quota wasn't exhausted when I checked (1026 of 5000 calls left), so it may be something else.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr204-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (708099 cached reads)
- Output: 3895 tokens
- Cost: $0.6197198
- Wall-clock: 3636s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
