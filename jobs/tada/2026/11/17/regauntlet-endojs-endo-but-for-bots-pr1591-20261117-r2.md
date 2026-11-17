I restarted the gauntlet for endojs/endo-but-for-bots PR #1591 under a new run name, `endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2`. The record is on `origin/journal2`, and I confirmed it reads back from GitHub with `state: pending` and `stage: viability`. `gauntlet.sh` will now drive it: viability → clean → panel → fix-loop → un-draft.

**Why it halted:** the previous run (`…-gauntlet-20261117`) stopped at 08:47Z. Its panel round 2 job was doomed by the reaper with `requeue-exhausted` (classified transient). That failure, plus the two allowed retries, used up its stage-retry budget (`max_stage_retries=2`).

**PR state:** still a draft, open, mergeable, on the frozen base `llm-48d6f3e`. The head is `31aeb19c`, with no failing checks.

**What I did:**
- **New name:** `post-gauntlet.sh` treats an existing record under the old name as already done, so I used the `-r2` suffix.
- **Retry budget:** I raised it to `--max-stage-retries 3`. A full panel has never finished on this PR:
  - In the earlier run (before the 20261117 one), every panel attempt was doomed `requeue-exhausted`.
  - In the 20261117 run, panel round 1 stopped at the deterministic style pre-pass, the fix round passed, and panel round 2 was doomed.
- I made no garden code changes and pushed nothing to the PR.

**Follow-ups:**
- If the panel stage dies `requeue-exhausted` again, it is probably a recurring problem rather than a passing blip: likely the panel's run time against the claim lease, or worker death on host `endolin-garden-ece02cb4`. It should be investigated before another restart.
- Four jobs from the earlier runs are still parked in `jobs/plan/`, all marked doomed and replaced by the new run. They should be withdrawn, not promoted:
  - `endojs-endo-but-for-bots-pr1591-gauntlet-panel-1`
  - `endojs-endo-but-for-bots-pr1591-gauntlet-20261117-panel-2`
  - `fix-endojs-endo-but-for-bots-pr1591`
  - `fix-endojs-endo-but-for-bots-pr1591-anchor-sweep-regression-evidence`
- The new run starts again at viability and clean before reaching the panel. Both are cheap.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/regauntlet-endojs-endo-but-for-bots-pr1591-20261117-r2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 20 tokens (570373 cached reads)
- Output: 3330 tokens
- Cost: $0.6158586
- Wall-clock: 148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
