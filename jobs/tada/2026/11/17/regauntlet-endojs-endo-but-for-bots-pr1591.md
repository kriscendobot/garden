I restarted the gauntlet for endojs/endo-but-for-bots PR #1591 by recording a fresh run. It's on `origin/journal2` now, and `gauntlet.sh` will drive it from viability through clean, panel and fix-loop to un-draft.

**Why it had halted:** the old run (`endojs-endo-but-for-bots-pr1591-gauntlet`) stopped at 01:14Z today. Its round-1 panel job was doomed by the reaper three times for transient reasons (`requeue-exhausted`), which used up its stage-retry budget.

**State of the PR now:**
- It is still a draft, mergeable, pinned to the frozen base `llm-48d6f3e`.
- The fixes for the panel's containment findings have landed:
  - `6c04788ca` anchors the bwrap exit-sweep process group.
  - `096c17adc` makes the bwrap test stubs work on macOS.
- CI on head `096c17adc` is 17 passed and 18 skipped, with no failures. Our own "Fix round 1" comments on the PR ask for a panel re-review.

**What I did:**
- I recorded the new run as `endojs-endo-but-for-bots-pr1591-gauntlet-20261117`. I couldn't reuse the old name: `post-gauntlet.sh` treats an existing record under that name as already done and posts nothing.
- I confirmed through the GitHub API that the record exists with `state: pending`, `stage: viability`.
- I made no garden code changes and no pushes to the PR. I posted nothing on GitHub beyond the journal record.

**Follow-ups:**
- Two leftover jobs from the old run are still parked in `jobs/plan/` and marked doomed:
  - `endojs-endo-but-for-bots-pr1591-gauntlet-panel-1`: replaced by the new run.
  - `fix-endojs-endo-but-for-bots-pr1591`: its fixes are already in the commits above.

  Neither should be promoted; both can be withdrawn.
- The new run starts by re-running the viability and clean stages before the panel. Both are cheap, but it is a little slower than going straight to the panel.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/regauntlet-endojs-endo-but-for-bots-pr1591.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (595391 cached reads)
- Output: 3217 tokens
- Cost: $0.6366822000000002
- Wall-clock: 168s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
