In the garden's own repo (`kriscendobot/garden`, branch `main2`), add `scripts/jobs/annotate-plan.sh`: a sanctioned CAS-append way to annotate an already-parked `plan/` job, since `post-plan.sh` is idempotent-only and a recent triage job had to hand-roll the CAS append. Follow the existing `scripts/jobs/` conventions (push-to-`journal2` retry loop, no LLM), and document it in `skills/job-board/SKILL.md`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-29T02:00:58Z
