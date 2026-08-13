---
gate: orchestrated
orchestrated_by: garden-tada-shard-orchestration
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:29:35Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
repo: kriskowal/garden (main2, direct push; no PR)

Design the date-sharded `jobs/tada/` layout and the transition that gets us there
without breaking a running fleet. Maintainer's goal (kriskowal, 2026-08-13):
**recently completed work should be easy to find.** Today `jobs/tada/` is one flat
directory of **4,521** entries and growing; finding this week's work means
listing all of it.

Target shape: `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`. Confirm or improve that in
the design; the goal is the constraint, not the exact path.

## What the design must settle

1. **Basename lookup.** `post-job.sh` is idempotent by basename and consults
   `tada/` when no directive identity is given. Sharding breaks a direct path
   probe. Decide: scan shards, maintain an index, or bound the search by date.
   **This is the highest-risk decision in the whole change** — get it wrong and
   either a completed job's basename silently re-mints, or a fresh directive is
   silently swallowed (the #671 "Shepherd." drop shape). State how the chosen
   mechanism fails, and make it fail toward re-minting rather than dropping.
2. **Which date, and where it comes from.** Completion time, derived
   deterministically from data already in the report or the completing commit —
   never `date` at read time, or the same entry resolves to different paths on
   different reads. Say what happens for entries whose date cannot be recovered.
3. **The refactor.** Today ~27 scripts construct `jobs/tada` paths themselves.
   Centralize path construction and lookup into `common.sh` helpers (a path
   builder, an existence check, a find-by-basename, a recent-window lister) so
   the layout lives in ONE place and a future change is not another 27-file
   sweep. This is the "refactor the dispatch machinery" half of the ask and it is
   what makes the rest tractable.
4. **Rolling-deploy safety.** The fleet is leader + followers deploying
   independently. During the window, old-code hosts write flat paths while
   new-code hosts write sharded. The transition must therefore be: readers
   tolerate BOTH everywhere first, then writers switch, then migrate, then drop
   the fallback. Confirm that ordering or propose better, and say how a host
   still running old code behaves at each step.
5. **Migration atomicity.** 4,521 entries must move as ONE CAS push so no reader
   ever observes a half-migrated tree. Say how that interacts with concurrent
   claims and completions, and whether a fleet drain is required.

## Deliverable

A design document under `designs/` plus a written ordering of the implementation
stages, landed on `main2`. Name the consumers that need changing (they are
enumerable with `grep -rln -E 'JOBS_TADA|jobs/tada' scripts/`) and flag the ones
where a subtle break is dangerous rather than noisy — `post-job.sh` idempotency,
`orchestrate.sh` child-completion detection, `follow-up.sh` report scanning,
`unblock.sh`, and `gauntlet.sh`.
