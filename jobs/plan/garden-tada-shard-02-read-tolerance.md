---
gate: orchestrated
orchestrated_by: garden-tada-shard-orchestration
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:29:41Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 7200
repo: kriskowal/garden (main2, direct push; no PR)

Stage 2 of the `jobs/tada/` date-sharding chain. Implement the design landed by
`garden-tada-shard-01-design`; read it first and follow it.

**This stage changes READERS ONLY. No writer may start producing sharded paths
here.** After this stage deploys, every consumer must work correctly whether an
entry sits at `jobs/tada/<base>.md` or `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`.
That tolerance is the safety precondition for everything after it, because the
fleet deploys host by host.

1. **Centralize path handling in `common.sh`** per the design: a path builder, an
   existence check, a find-by-basename, and a recent-window lister. Every
   consumer goes through these rather than constructing paths itself.
2. **Convert all consumers** to the helpers. They are enumerable with
   `grep -rln -E 'JOBS_TADA|jobs/tada' scripts/`; there were ~27 non-test files
   plus ~54 test files at the time this was scoped.
3. Pay special attention where a subtle break is silent rather than loud:
   `post-job.sh` idempotency, `orchestrate.sh` child-completion detection (a bad
   lookup reads as "child vanished" and halts a campaign — that exact false-halt
   cost a 21-child campaign a full launch on 2026-08-13), `follow-up.sh`,
   `unblock.sh`, `gauntlet.sh`.

## Tests

Every helper covered for both layouts. Add cases proving `post-job.sh` still
dedups a completed basename, and that `orchestrate.sh` still sees a child that
completed into either layout. Run the existing suites; they must stay green with
the tree still entirely flat.

## Bound

Do not migrate anything and do not switch any writer. Landing this stage must be
a behavioral no-op on today's flat tree.
