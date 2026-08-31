---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-31T17:56:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Re-promote the quarantined ironhorse fuzz-repair jobs

BLOCKED on `ironhorse-fuzz-repair-template-policy-rewrite`. Do not start until
that job has landed a reworded template AND demonstrated one real dispatch
surviving the provider policy filter. If it did not prove that, stop and report
rather than promoting jobs that will simply be refused and re-quarantined.

## What happened

Between 2026-08-31 05:23Z and 14:15Z, 55 `ironhorse-fuzz-<hash>-repair` jobs hit
a deterministic provider policy refusal and the reaper quarantined them into
`jobs/plan/` (gate `go-ahead`, `doom_signature: policy-refusal`). As of this
posting **62** ironhorse-fuzz jobs sit in `plan/`. Nothing is lost — they are
held, not deleted.

## The work

1. Enumerate the quarantined set: jobs in `jobs/plan/` matching
   `ironhorse-fuzz-*-repair` with `doom_signature: policy-refusal`. Report the
   exact count you found; it may have grown since this was written.
2. Regenerate each body from the NEW template so a promoted job carries the
   reworded framing rather than the one that was refused. A bare
   `promote-plan.sh` on a stale body just re-runs into the same block — promotion
   alone is NOT the fix.
3. Promote in a BOUNDED batch, not all at once. Start with ~5, confirm they are
   claimed and are not refused, then continue. Log what you promoted and what you
   deliberately left for a later batch — never a silent cap.
4. If refusals resume at any point, STOP, leave the remainder quarantined, and
   report. Do not grind the whole set through a filter that is still rejecting.

## Notes

- `promote-plan.sh` clears the reaper's cycle counters from the body and records
  what it cleared, so a promoted job gets a real requeue rather than being
  re-doomed off a stale count.
- Deduplicate: several findings may share a root cause. If regenerating reveals
  duplicates, say so — collapsing them is more valuable than promoting 62 jobs
  that produce one fix.

## Definition of done

The quarantined set is either promoted-and-running or explicitly accounted for,
with counts at each step and the commands that produced them.

<!-- garden-annotation: key=liaison-role-fix by=producer at=2026-08-31T17:49:08Z fields=role=builder -->

Selection metadata corrected: the original body set 'tier: builder', an invalid tier value (builder is a ROLE; tier takes mentor/minion). Role is now set explicitly so this job draws the 7200s builder handler budget rather than the 2400s default.
