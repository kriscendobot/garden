Fix round 6 for kriscendobot/minion.town PR #178 is finished. I checked again just now: the PR head is still my commit `2a6064d` and all 3 CI checks pass. The previous session did the work but put its two closing lines in the wrong order, so this report puts the stage-result marker before the completion signal.

**Must-fix applied:** the panel's one must-fix (integrator 1) was that the PR description no longer matched the code. I rewrote it to describe what the branch does now:
- Pushes to one partition run one at a time.
- A refusal at the POST comes back as a plain HTTP 413/429/507, and a refusal at the ref advertisement as an `ERR` packet.
- The partition cap is soft, so one push can overshoot it.
- A new "Behavior change and rollback" section covers rollout and rollback.

I kept the `garden-job` marker in the description.

**Doc changes (should-fix from the integrator and pruner),** in one commit, `2a6064d`, pushed with `safe-push-pr-head.sh`:
- The env table in `designs/git-remote-capability-increment-1.md` now lists the four cap variables and is the only full table.
- `DEPLOYMENT.md` keeps only what an operator needs. I took out the history and the rollout/rollback recipe; the recipe now lives in the PR description.
- Deferred item 3 in the design note now credits the caps to increment 2 of the arc and drops the "full partition stays full with no GC" caveat.

The commit changes documentation only, no code.

**CI:** `ci-wait-merge` exited 0 with all 3 checks green. I did not re-run the panel; the gauntlet driver posts panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr178-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1172382 cached reads)
- Output: 8214 tokens
- Cost: $1.8722370000000004
- Wall-clock: 879s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
