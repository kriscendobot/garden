---
ts: 2026-06-25T16:51:44Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - jobs/tada/design-propagator-endo-exo.md
---

Designed a Radul/Sussman propagator at the Endo and Exo layers (job
`design-propagator-endo-exo`, gardener 26 on endolinbot).

Deliverable: `designs/propagator-cells.md` on `endojs/endo-but-for-bots`,
branch `design/propagator-cells`, opened as **DRAFT PR #529** against the `llm`
roadmap branch. Design slug: `propagator-cells`.

Content: the Endo layer (`@endo/propagator`: cells holding lattice-merged partial
information, multidirectional propagators, a run-to-quiescence scheduler, an
injected `Lattice` contract, hardened with explicit neighbor-graph teardown) and
the Exo lift (`@endo/exo-propagator`: `CellReader`/`CellWriter`/`CellAdmin`
facets, cross-vat eventual merge that stays monotone so reorder/duplicate/loss
converge, contradiction-as-passable, ocap-attenuable cell references). Situated
the propagator as the idempotent-convergence member of the change-propagation
family beside *latest* and *changes*, and as the n-ary generalization of FRB
`<->` two-way bindings (with FRB null-suppression named as the lattice bottom).
Truth maintenance left as a seam.

Grounding: Radul/Sussman cited as external lineage (MIT-CSAIL-TR-2009-002; Radul
thesis 2009); FRB reference-semantics, notifier lossiness (latest vs changes),
crdt-in-formula-persistence, exo taxonomy, eventual-send, and daemon-cross-peer-gc
grounded in the curated library.

Follow-ups: full README milestone / dependency-graph / Gantt integration deferred
to a grooming pass (design is DRAFT and unscheduled); the `@endo/pubsub`
`makeLatestTopic`/`makeChangeTopic` surface is flagged not-yet-in-corpus and left
as an open question for the builder to confirm.

Self-improvement: nothing this time.
