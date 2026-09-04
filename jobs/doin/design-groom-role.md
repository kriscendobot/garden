---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Formally land the **groom** role for this (the garden's own) repo — `roles/groom/AGENT.md` per CLAUDE.md § Adding a role (purpose, skills, operating norms, definition of done). This is garden-infrastructure work, not a project design: land it directly per the garden's own no-PR convention (CLAUDE.md § Conventions), with the open-questions-PR carve-out if real open questions remain.

## Why

`groom` is a **v1 role** kriskowal has asked to be captured formally. Per `designs/v1-migration-manifest.md`: *"references/-adopted roadmap-maintenance role; reference-shelf; roadmap upkeep is a posted job if revived."* That claim is stale — no `groom.md` file actually exists under `references/endo-but-for-bots/roles/` (checked 2026-09-03; only chronicler/juror/marshal/namer/scribe/stratego/triager are present). Its four associated v1 skills — `velocity-recalibration`, `roadmap-projection`, `dependency-graph-maintenance`, `groom-open-questions` — are likewise unmaterialized stubs, not files.

Despite that, the *verb* is alive and doing real, un-owned work today: `groom-endo-designs-readme`, `groom-refine-endo-roadmap`, `groom-endo-stale-design-docs`, `groom-parked-job-queue-*`, `ebfb-llm-designs-groom-*` all appear as completed jobs in `journal/jobs/tada/` — ad hoc, basename-convention-only, with no role brief backing them.

## What grooming actually maintains

The concrete target is `designs/README.md` on **endojs/endo-but-for-bots**' `llm` branch (its default branch) — a large (~187K char), living, ranked project roadmap:

- `## Roadmap` → `### Milestones`: **"Milestones are numbered in approach order: M1 first, M11 last. Each milestone's dependencies all live in earlier milestones"** (verbatim; invariant enforced since a 2026-06-03 renumbering per maintainer directive on PR #400). Each milestone carries a goal, a `| Design | Status | Notes |` table, an exit criterion, actual/estimated duration.
- `### Strategic Early Items` — designs pulled ahead of their natural milestone because they're foundational (currently `endo-reminder`, `endo-fetch`).
- `### Execution lead` — a numbered `Order` table naming the current leading integration spine.
- `### Unattended design routing`, `### Dependency Graph` (mermaid), `### Size and Time Estimates`, `### Timeline`.
- A "current-totals" block at the top; historical grooming notes live in a separate `ARCHIVE.md` — *"record each grooming pass by appending its note to ARCHIVE.md; do not layer new groom notes at the top of this file"* is an explicit convention inside the doc itself.

This is the per-project analogue of the garden's own `journal/plan/` + `velocity.md` mechanism described in `README.md` § Planning ("a weekly recalibration job re-fits velocity to what actually shipped, reprojects the roadmap, and grooms the records") — same shape, different repo.

## Scope for this design

1. Author `roles/groom/AGENT.md`: purpose (roadmap upkeep on a consuming project's `designs/README.md` — flip completed-design status rows, re-fit size/time estimates against actual duration, reproject milestones/timeline, prune/archive stale entries into the project's `ARCHIVE.md` convention where one exists, maintain the dependency graph), skills (translate or write v2-native versions of `velocity-recalibration`, `roadmap-projection`, `dependency-graph-maintenance`, `groom-open-questions` — decide per skill whether it's still accurate against the current `designs/README.md` shape or needs a rewrite), operating norms (cite the actual doc conventions found above — the ARCHIVE.md split, the M1→M11 invariant, the Strategic Early Items carve-out), definition of done.
2. Decide whether `groom` should be a directly-postable role (added to the CLAUDE.md § Current inventory roles list) or stay a job-basename convention dispatched under an existing role (e.g. `gardener` or `researcher` wearing a groom hat) — the current ad hoc jobs already run successfully without a formal role, so justify whichever way this lands.
3. If real open questions surface (e.g. the exact skill translations, or role-vs-basename), leave them in `## Open questions` and take the open-questions-PR carve-out per `roles/designer/AGENT.md` rather than picking silently.

## References

- `designs/v1-migration-manifest.md` (the stale "adopted to reference shelf" claim)
- `README.md` § Planning (the garden's own analogous grooming pattern)
- `journal/jobs/tada/groom-*`, `journal/jobs/tada/ebfb-llm-designs-groom-*` (the live, currently-unowned convention)
- `endojs/endo-but-for-bots` `designs/README.md` (the concrete target document)



<!-- garden-transient-elapsed: kind=signature through=1 values=2,3 -->

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-04T07:40:53Z
