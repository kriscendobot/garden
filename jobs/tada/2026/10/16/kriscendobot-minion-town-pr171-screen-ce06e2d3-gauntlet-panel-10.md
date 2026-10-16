Panel round 10 on kriscendobot/minion.town PR #171 came back **must-fix**. The verdict is posted as a review at https://github.com/kriscendobot/minion.town/pull/171#pullrequestreview-5541518897.

**What I did**
- Checked out the PR head `feat/claude-arc-prod-validation` at `22ca484` in an isolated worktree, `scratch/project-wt-kriscen-7482eb816a6d-cd1820b4`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 171 origin/main-30a4c62`. It exited 0 with disposition `must-fix`. All 34 seats returned ok, with no seat errors.
  - My first launch died with an empty log, most likely killed by my own cleanup `pkill`. I reran it with the exit code captured; that rerun is the result reported here.
- Seat tally:
  - **Request changes (4):** decomplector, breaker, integrator, pruner. Integrator called its findings should-fix only.
  - **Approve:** 11 seats.
  - **Comment only:** 19 seats.
- **Must-fix findings:**
  - **breaker #1:** `deploy-app.sh` runs `chown -R minion-mcp:minion-mcp` on the staging tree before it makes the observer and layout files root-owned. In that window a `minion-mcp` process can swap the observer, which root then runs. The fix is to stage `bin/` and `share/minion-town/` root-owned from the start.
  - **decomplector #1:** the observer's `claude --version` run only happens when the binary's digest already matches, so it adds nothing. It is also the reason for the SSM parameter, the argument validation and the sudo/`env -i` step. The fix is to remove it, or say in the PR body what drift it catches that the digest misses.
- Two pre-pass checks also fired:
  - The PR body is too wordy.
  - The same mechanism (`--version` / `claude-harness.mjs`) drew must-fix findings again; rounds 8 and 9 raised it too.

**How the review was posted**
- It is a COMMENT review, not request-changes. GitHub refuses request-changes on the bot's own PR, which matches rounds 7–9.
- The body starts with the `<!-- garden-panel-verdict -->` marker and states `disposition: must-fix`.
- I cut 15 seat sections to fit GitHub's review size limit. They are listed at the end of the review. I checked each one, and none had a must-fix finding.
- The gh wrapper refused my first post because seat text had bare `#N` references alongside a link to another repo. I put those references in backticks and posted again.

No project or garden code changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr171-screen-ce06e2d3-gauntlet-panel-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1590817 cached reads)
- Output: 7534 tokens
- Cost: $1.0458674
- Wall-clock: 488s

<!-- garden-usage-end -->
