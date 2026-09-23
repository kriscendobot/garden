cadence: weekly
last_dispatched: 2026-07-27T02:35:02Z
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
6. **Regenerate the endo courtesy redirect** (plan-in-journal Phase 1, kept
   indefinitely). Run `scripts/jobs/plan/render-endo-redirect.sh <worktree>/plan`
   and write its output to the `endojs/endo-but-for-bots` `llm` branch's
   `designs/README.md` (a non-authoritative pointer back to the journal plan,
   generated from the records). Push it change-gated, in a separate worktree off
   `origin/llm`: skip the push when the regenerated file is byte-identical to what
   is on `llm` (deterministic output, so a no-op week makes no push). The `llm`
   branch carries a "changes through a pull request" rule, so land the change as a
   bot PR against `llm` rather than a direct push (the only open redirect PR; reuse
   it across weeks if still open). Bot identity only; this fork is bot-pushable.

Bounds: bot identity, bot-actionable repos only; `agoric-sdk` excluded
unconditionally (the validator enforces this). Report what was reconciled,
recalibrated, and groomed.
