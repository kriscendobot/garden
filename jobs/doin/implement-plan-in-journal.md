# Implement the plan-in-journal design (garden#4, approved — do NOT merge the PR)

Maintainer review (kriskowal, 2026-06-25T17:58Z) on **kriskowal/garden #4**:
"Looks good to me. We do not need to merge this PR, but **post a job to implement the
plan**. This may require **pausing the garden while the journal gets reorganized**. Please do."
https://github.com/kriskowal/garden/pull/4#pullrequestreview-4573611899

Wear the **builder** role (escalate to phased sub-jobs if too large for one pass). Implement
the **finalized** design at `designs/plan-in-journal.md` on garden#4's head (`ff8b4452`) — the
PR stays OPEN as the spec; do not merge it. Infrastructure on `main2` (bot identity; isolated
worktree off `origin/main2`) plus journal2 reorg.

## What to build (per the finalized design + the review decisions)

- The **plan lives fully in `journal2`**: per-design files at
  `journal/plan/designs/<project-slug>/<design-slug>.md` (frontmatter metadata + narrative in
  one file) are the **source of truth**; the aggregate roadmap is **generated** from them.
- A **`journal/plan/projects.md`** mapping short kebab-case **slug → repository URL** (field name
  **`repository`**; a project may span multiple repositories; keep the model open to
  **non-GitHub** repositories).
- A **reconciler** that **continuously** (not maintainer-gated) advances each record's lifecycle
  by comparing `status`/`pr` against actual PR + board state — **consolidated into the bulletin
  generator (`scripts/jobs/bulletin.sh`) and the journalist**, NOT a new role/service.
- A **weekly recalibration + grooming** scheduled task on **Sunday evenings** (via the `schedule`
  skill / `set-schedule.sh`).
- Latency stays a **single garden-wide metric**.
- The endo `designs/README.md` becomes a **generated, non-authoritative redirect, kept
  indefinitely**.
- Follow the design's **Migration phases**; if the whole thing is too large for one pass, do the
  early phases and **post follow-on `implement-plan-…` jobs** for the rest (report which).

## Pausing for the journal reorg

The reorg is largely additive (new `journal/plan/` tree), which does NOT need a pause. **Only if
a migration step restructures live journal paths the fleet actively uses** should you pause the
local garden for that step — use the reliable pause/resume scripts if present
(`scripts/jobs/pause.sh`/`resume.sh`), else the killswitch + stop/start, then **resume promptly**
and verify health. Keep any pause as short as possible and scoped to the destructive step. Do NOT
leave the fleet paused.

## Bounds & communication

- Bot identity; bot repos only. Migrate/ingest the existing endo plan data faithfully (don't lose
  the roadmap). Keep the existing journalist/bulletin/foreman consumers working through the
  cutover (they currently read the endo `designs/README.md`) — name the cutover point for each.
- Post a **top-level summary comment on garden#4** reporting what was implemented (and what was
  deferred to follow-on jobs), per the standing norm.

## Definition of done

The plan-in-journal architecture implemented per the approved design (per-design files as SoT in
journal2, slug→repo mapping, reconciler folded into bulletin/journalist, Sunday recalibration
schedule, garden-wide latency, indefinite redirect), with any required pause kept short and the
fleet resumed-and-verified, follow-on phase jobs posted if needed, and a #4 summary comment.
Report the SHA(s), what landed vs deferred, and whether a pause was needed. If a step is too risky
to do without maintainer presence, surface it rather than forcing it.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 73
  claimed_at: 2026-06-25T18:02:28Z
