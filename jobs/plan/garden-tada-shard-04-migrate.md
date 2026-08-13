---
gate: orchestrated
orchestrated_by: garden-tada-shard-orchestration
priority: normal
posted_by: producer
posted_at: 2026-08-13T21:30:24Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder
handler-timeout: 10800
repo: kriskowal/garden (main2) + the journal branch `journal2`

Stage 4 of the `jobs/tada/` date-sharding chain: migrate the existing entries.
Follow the design from `garden-tada-shard-01-design`.

**Preconditions, verified before touching the journal:** stages 2 and 3 are
landed AND deployed fleet-wide. Every host reads both layouts and writes sharded.
If any host is behind, STOP and report.

## The migration

Move every existing flat `jobs/tada/<base>.md` (there were **4,521** when this
was scoped) to `jobs/tada/<yyyy>/<mm>/<dd>/<base>.md`, using the completion date
the design specifies.

- **ONE atomic CAS push.** No reader may ever observe a half-migrated tree. If
  the push races and is rejected, re-sync and redo the whole move rather than
  pushing a partial.
- **Drain first if the design says so.** A completion landing mid-migration is
  the obvious hazard; handle it the way the design prescribes and say what you
  did.
- **Preserve history.** Use git moves so `git log --follow` still works, and
  verify a sample of entries retain their history after the move.
- **Entries whose date cannot be recovered** go wherever the design says, not
  wherever is convenient. Report how many hit that path.

## Verify, with evidence in the report

- Count before and after must match exactly. Report both numbers.
- Spot-check that a migrated entry is still found by basename lookup, that
  `post-job.sh` still dedups against it, and that `orchestrate.sh` still reads a
  migrated child as completed.
- Confirm no entry was dropped, truncated, or renamed beyond its path.

If anything does not reconcile, STOP and report with the journal left unchanged.
A wrong migration here loses the fleet's completion record.
