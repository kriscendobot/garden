cadence: weekly
last_dispatched: 2026-06-21T21:00:00Z
job_basename_prefix: plan-recalibrate
---
# Weekly plan recalibration and grooming (Sunday evening)

You are a gardener running the weekly plan recalibration + grooming pass over the
journal-local plan (`journal/plan/`, the single source of truth per
`designs/plan-in-journal.md`, garden#4). The continuous bulletin loop already keeps
`journal/plan/README.md` rendered; this weekly pass is the slower cadence for
estimates, projections, status drift, and grooming. Anchored to Sunday evenings via
`cadence: weekly` with `last_dispatched` seeded to a Sunday.

Work in an isolated worktree off `origin/journal2` (the shared /home/kris/journal
tree is concurrently mutated — never `git reset --hard` it). Do all of the
following, then commit the changed records + regenerated view and push HEAD:journal2
(CAS; re-sync and retry on rejection):

1. **Reconcile status/PR drift (the automatic Complete flip).** Run
   `scripts/jobs/plan/reconcile.sh <worktree>/plan <worktree>` — it queries GitHub
   PR merge state for each record's `pr` and flips a merged design to Complete with
   an audit note. Skim the flips for sanity before committing.
2. **Recalibrate velocity** from the week's merged-PR cadence per
   `skills/velocity-recalibration/SKILL.md`; update `journal/plan/velocity.md`
   (keep latency a single garden-wide figure).
3. **Reproject milestone target dates** per `skills/roadmap-projection/SKILL.md`
   from the recalibrated velocity; update milestone records' `target` where useful.
4. **Groom** open questions and stale records per
   `skills/groom-open-questions/SKILL.md`: file unfiled designs into milestones
   where clear, retire superseded ones, note dangling `depends_on` edges. Run
   `scripts/jobs/plan/validate.sh <worktree>/plan` and fix any ERROR it reports.
5. **Re-render** `journal/plan/README.md` with `scripts/jobs/plan/render.sh` so the
   committed view matches the groomed records.

Bounds: bot identity, bot-actionable repos only; `agoric-sdk` excluded
unconditionally (the validator enforces this). Report what was reconciled,
recalibrated, and groomed.
