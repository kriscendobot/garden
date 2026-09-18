---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# date-sharded-tada stage 2 (retry): switch completion writers to sharded paths

This is a retry of `garden-tada-shard-03-write-switch`, which correctly
refused to proceed on 2026-08-xx because this host was not yet deployed with
stage 1 (`a9adf2ea42`, "Helpers + reader tolerance" — see
`designs/date-sharded-tada.md` § Implementation stages, step 1). That commit
has since had ~5 weeks to roll out; verify before proceeding, do not assume:

```sh
git log --oneline -1 -- <path>   # confirm a9adf2ea42 is an ancestor of this
                                  # host's deployed sha (.garden-state/deploy/deployed-sha)
```

If this host (or, ideally, check `fleet/health/*` for ALL fleet hosts —
leader, garden2, oros-studio) is not yet past `a9adf2ea42`, STOP exactly as
the prior attempt did (report the precondition gap, do not proceed) — do not
weaken this safety check just because it blocked once before.

## The actual work (design § Implementation stages, step 2)

Flip the completion WRITERS (not readers — those already switched in stage 1)
to `tada_write_path`: `complete-job.sh`, `ci-watcher.sh`, `orchestrate.sh`,
`gauntlet.sh`. After this lands and deploys, new completions land at
`jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`; the existing flat backlog stays flat
and is still read correctly via stage 1's fallback-tolerant readers — this
step does NOT touch existing entries (that's stage 3, a separate blocked
follow-on job).

Read the design's § 4 "Rolling-deploy safety" section for the full hazard
analysis before touching the writers — this is exactly the section that
saved the prior attempt from corrupting anything.

Verify: the design's own test list (a `tada_find` covering flat/sharded/
undated; the post-job idempotency proof; the orchestrate child-view proof)
plus confirm a real completion from this change actually lands at the
sharded path, not flat.

Report the landed commit sha and confirm deploy status is being tracked
(the next job, migration, is blocked on this one actually being DEPLOYED
fleet-wide, not merely landed on main2 — say so explicitly in your report so
whoever unblocks the migration job checks deploy state, not just merge state).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-18T04:42:35Z
