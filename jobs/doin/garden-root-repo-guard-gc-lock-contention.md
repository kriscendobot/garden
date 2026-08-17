---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Self-improvement, the garden itself (main2, pushed directly per CLAUDE.md
Conventions).

DEFECT: `root-repo-guard` conflates `git gc` LOCK CONTENTION with a DAMAGED
object store. It then escalates to an expensive full refetch and emits a
maintainer notice prescribing a hand-repair procedure that does not apply.

WORKED EVIDENCE, host endolin-garden2-5bcdff64, 2026-08-17:

  05:52:02  root repo healthy: ... object store maintainable
  06:22:02  OBJSTORE-MAINTENANCE: needs maintenance (52 packs (ceiling 50)); running a bounded 'git gc'
  06:22:02  OBJSTORE-GC-FAILED: 'git gc' failed (rc=128): fatal: gc is already running ... pid 470893
  06:22:02  OBJSTORE-RECOVERY: re-fetching full history from the canonical origin ('fetch --refetch', additive only)
  06:22:25  OBJSTORE-UNREPAIRABLE: ... object store is UNMAINTAINABLE ... pid 577356 ...
            State: 52 packs, 28 loose objects, 0 stale gc.log(s).
            "0 object(s) reachable from refs are missing locally (e.g.  )"

By 06:46 the same repo measured, via `git count-objects -v`: count 0 (loose),
garbage 0, prune-packable 0, packs 4, in-pack 619341. No `gc.pid` and no `gc.log`
anywhere under `.git`. So a gc completed successfully within ~24 minutes of the
"unmaintainable" verdict, repacking 52 packs into 4. The store was never damaged.

THREE THINGS TO FIX.

1. ZERO MISSING OBJECTS IS NOT UNMAINTAINABLE. The notice states its own
   refutation: "0 object(s) reachable from refs are missing locally", with an
   EMPTY example list. The UNREPAIRABLE verdict should require at least one
   actually-missing object. With a missing count of zero, a failed gc means the
   lock was held, not that the store is broken.

2. LOCK CONTENTION DESERVES BACKOFF, NOT REFETCH. `fatal: gc is already running
   on machine '<host>' pid <n>` is a distinct, recognizable condition. Detect it
   and back off to the next tick (optionally verifying whether that pid is alive,
   which distinguishes a genuinely stale lock from a live concurrent gc). Do NOT
   escalate to `fetch --refetch`: on this repo that is a ~173MB full-history
   re-fetch spent on a non-problem. Note the guard cited TWO DIFFERENT pids 23
   seconds apart (470893 then 577356), which indicates concurrent gc attempts
   racing rather than one stale lock. Worth understanding what else runs gc here,
   since the fix should not merely paper over a real contention source.

3. DO NOT PRESCRIBE AN INAPPLICABLE REPAIR. The notice tells the maintainer to
   run `rev-list --objects --missing=print --all | grep "^?"`, find the refs
   reaching the missing objects, back each up, then re-point or drop the ref.
   With zero missing objects that procedure has no input and no effect, and it
   asks a human to consider dropping refs that "are real history". A notice that
   recommends touching real history on the strength of a lock collision is worse
   than silence. Gate that guidance on a non-zero missing count.

Keep the guard's genuine value intact: it correctly detected the pack ceiling and
correctly tried to gc. Only the failure classification and escalation are wrong.

Deliverable: a contained fix on main2 with a regression test covering both the
contention path (gc fails, zero missing objects, expect backoff and NO refetch and
NO maintainer notice) and the genuine-damage path (objects actually missing,
expect the existing escalation). Related in-flight self-improvement work, read
first to avoid overlap: `garden-reroute-respect-role-tier-floor`,
`garden-requeue-rediscover-prior-work`, `garden-orchestration-halt-record-accuracy`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T11:51:16Z
