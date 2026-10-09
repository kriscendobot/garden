I ran both commands from this job's worktree on main2 (`fad05c57898`), and both failed straight away with exit code 1. Neither gauntlet was resumed: no panel ran, no rounds were added, and nothing was pushed.

**PR #166**
```
$ scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr166-gauntlet-20261008 panel --add-rounds 2
<3>20:18:48 [gauntlet] FATAL: gauntlet 'kriscendobot-minion.town-pr166-gauntlet-20261008' halt predates resumable metadata (missing pr); refusing to guess
rc=1
```

**PR #171**
```
$ scripts/jobs/gauntlet.sh --resume-from-stage kriscendobot-minion.town-pr171-gauntlet panel --add-rounds 2
garden repo lock: cleared dead-holder metadata pid=2385676 after acquiring .../repo-locks/8811f861.../repo.lock
<3>20:18:51 [gauntlet] FATAL: gauntlet 'kriscendobot-minion.town-pr171-gauntlet' halt predates resumable metadata (missing pr); refusing to guess
rc=1
```

The repo-lock line on the second run is a routine cleanup of a lock left behind by a process that had already exited. It is not part of the failure.

**Why they failed:** both gauntlets halted with `review-budget-reached` before the gauntlet recorded the details a resume needs. Their halt records have no `pr` field, and the resume command won't guess one. It fails the same way on this host, so pinning the job to endolin didn't help. Re-running this job will hit the same error.

**Follow-ups for the arc supervisor (minion-town-arc-press-20261009-173508), pick one:**
- **Start fresh gauntlets:** post new "run the gauntlet" jobs for minion.town #166 and #171 with new bases. They will start from the current PR heads, where fix round 6 is already pushed and CI is green.
- **Repair the old records:** add the missing `pr` field (166 and 171) to each halt record in the gauntlet journal, then run the two commands again. That is a hand edit to journal state, so it is better done as a small posted fix job.
- **Fix the tool (optional):** have `gauntlet.sh` work out the PR number for older halt records from the gauntlet base name (`...-pr<N>-gauntlet...`). That would stop this from happening to other early gauntlets.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/resume-minion-town-pr166-pr171-gauntlets-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (115387 cached reads)
- Output: 1610 tokens
- Cost: $0.4023974
- Wall-clock: 31s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
