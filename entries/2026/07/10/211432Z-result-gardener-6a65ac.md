---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-10T21:14:39Z
---
# scholar-ingest-unum-remainder — result

Follow-on to `scholar-ingest-unum` (token-spend/orchestration core). Ingested the
remaining transferable veins of jcorbin's **unum** (tangled.org, repo @ `1834aba`)
into `journal/library/`, consolidating aggressively per the job's direction. EXCLUDED
`ref/kris_garden/` and `ref/` subtrees as instructed.

## Sources ingested (10 new sections; unum source_count 5 → 15)

The **LORE corpus** (~67 distilled lessons) consolidated into 5 sections, NOT mirrored 1:1:
- `unum--lore-corpus-shape` (LORE/INDEX.md `764a14d`) — the corpus shape + distillation practice (shape-not-content).
- `unum--lore-claim-lifecycle` — claim triple atomicity, flock-verified liveness over occupancy inference, branch-landed≠done, missing-breadcrumb deadlock.
- `unum--lore-journal-durability` — git-ref RMW-CAS vs blind overlay, primitive-selection-by-lifecycle, journal-then-untrack cutover.
- `unum--lore-crash-safe-guards` — breadcrumb-before-killswitch ordering, source-gated auto-clear, model-guarded resume, context-exhaustion recap.
- `unum--lore-engineering-discipline` — design-out-the-hazard, lighter cut, fail-loud/log-and-swallow, schema-duplication drift, no dead parsed fields, seam injection.

Subsystems + house style (5 sections):
- `unum--garden-vs-devoker-fleet` (LORE `cb83f9a`) — unum's own dimension-by-dimension comparison of THIS garden's fleet vs devoker.
- `unum--devoker-four-layer-architecture` (devoker/DESIGN.md `23cb6dd`) — Evoker→Invoker→Agent→Model, argv[0] dispatch, vigil/refinery burst engine.
- `unum--make-user-host-resource-quota` (devoker/DESIGN.md `23cb6dd`) — systemd resource-slice quota profiles (light/medium/heavy) — a NON-token agent budget.
- `unum--notify-server-routedown` (notify_server/DESIGN.md `7c0a32c`) — durable persist-then-dispatch notification proxy + Routedown config.
- `unum--operations-standards` (STANDARDS/operations.md `339d53e`) — safety invariants, don't-stage-on-production, config/logging norms, lesson-capture pipeline.

## Declined this cycle (one-line reasons)
- Command-by-command `devoker/DESIGN.md` surface — reference-manual detail, low cross-cutting value beyond the architecture overview.
- `evoke/` persona/soul config shapes — unum-specific config; the transferable persona/workflow content (context-exhaustion roll-forward) already captured in the crash-safe-guards section.
- `STANDARDS/{golang,bash,monorepo}.md` idiom files — house-specific code style, not cross-cutting library material.

## Indexing
- New topic **agent-fleet-durability** (the state-integrity layer under agent-fleet-orchestration); source-index `unum.md` updated.
- 6 new concept pages: `claim-state-triple`, `journal-ref-rmw-cas`, `killswitch-source-guard`, `design-out-the-hazard`, `resource-slice-budget`, `log-and-swallow` — with ~36 keyword aliases and concepts/README rows.
- Section rows added to topics: agent-fleet-orchestration (6), repository-governance (3), persistence, testing, process-monitoring, coding-agent-economics, agent-conventions (1 each); new agent-fleet-durability page carries its 3 rows.
- sources/README, topics/README, concepts/README updated by hand; `regenerate-sections-index.sh` + `regenerate-topics-counts.sh` ran as the final landing step and landed current.

## Integrity gate
- `library-link-check.sh --changed` → OK (every unum-cluster section-table + sections/README row resolves).
- `regenerate-topics-counts.sh --check` → stale (informational; reconciled and landed by the `--land` final step).
- Verified on `origin/journal2` tip: `section_count: 15`, 15 `unum--` rows in the flat sections index.

## Follow-ups
- No `scholar-ingest-unum-remainder-2` posted — the transferable veins are covered; the declined material is unum-specific idiom/config with low cross-cutting value.
- The garden-vs-devoker comparison and the claim-lifecycle/journal-durability lessons are directly relevant to the garden's own job-board/CAS/reaper design; no structural lesson requiring liaison routing surfaced (the library taxonomy absorbed the new material cleanly via one new topic).

Self-improvement: consolidating a 67-file incident-lesson directory into 5 thematic sections (rather than 67) plus 6 concept lookup pages kept the section index navigable while preserving the transferable content; the "shape-not-content" convention applied cleanly to the LORE index itself. The one friction point: landing ~29 files one-at-a-time through `land-journal-edit.sh` exceeded a single 2-minute tool window (each does a full sync+CAS push) — a `land-journal-edit.sh --batch <dir>` that lands multiple allowlisted files in one producer-clone sync+push would cut a large ingest's landing time by ~10x; worth a mentor/liaison note if multi-file cycles recur.
