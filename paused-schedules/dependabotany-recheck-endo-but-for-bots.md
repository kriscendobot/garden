cadence: daily
last_dispatched: 2026-08-01T01:35:01Z
job_basename_prefix: dependabotany-recheck-endo-but-for-bots
---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# botanist daily recheck sweep: endojs/endo-but-for-bots dependabotany ledger

Wear roles/botanist/AGENT.md. This is the **backstop** heartbeat over the
`endo-but-for-bots` dependabotany ledger, not the primary recheck: each
embargoed PR also carries a precise self-deleting one-shot placed at its own
maturity floor (`dependabotany-recheck-endo-but-for-bots-pr<N>`). This sweep
exists only so a PR whose one-shot was lost cannot rot.

Recover the current ledger with:

```sh
grep -rl '^project: endo-but-for-bots$' journal/entries/ | xargs grep -il '^# *dependabotany'
```

The `-i` is load-bearing: entries written with a lowercase `# dependabotany …`
heading are invisible to the case-sensitive form (2026-07-29: 25 of 27 entries
recovered; the two dropped rows were terminal, but an EMBARGO row hidden the
same way is exactly the rot this backstop exists to prevent).

Read the ledger entries newest-first to reconstruct the open embargoed set
(a terminal verdict on a later recheck removes that PR's row). For every open
row whose `EMBARGO-YYYY-MM-DD` maturity date has arrived, re-run the botany
workflow against the PR's live head and execute the now-due verdict:
MERGE-NOW conducts onto the base branch through the conductor spine
(`scripts/jobs/gardening/ci-wait-merge.sh`, maintainer-approval gate intact),
REJECT closes with the structured verdict comment. `endojs/endo-but-for-bots`
is bot-owned, so the disposition is executed, not merely recommended.

Before acting on any row, check whether the PR reached a terminal state on its
own (merged, or closed by dependabot as superseded); if so, record the terminal
state in the ledger and take no further action. Check the live head SHA against
the one the row recorded too: a dependabot force-push regenerates the lockfile
and resets the maturity floor, while a fixer's commit on the same branch does
not.

Append a `# Dependabotany ledger` message entry recording the sweep result,
tagged `project: endo-but-for-bots`. When the ledger holds no open embargoed
endo-but-for-bots rows, this schedule may be deleted; a future embargo verdict
re-creates it idempotently per `roles/botanist/AGENT.md` § Autonomous
disposition.
