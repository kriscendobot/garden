---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-27T18:57:34Z
---
---
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/825
---

# attention directive routed on endo-but-for-bots#825 (dckc)

dckc asked (https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5095444886):
"why is this in the daemon package? It can, and hence should, go in its own
package, yes?" — re the persistent sorted collection stores (Phase 4).

Routed as a substantive design reply rather than a unilateral refactor.

Coupling analysis: `packages/daemon/src/collection-store.js` is already
dependency-injected — at runtime it imports only public `@endo/*` packages and
takes all daemon seams through the injected `powers` object of
`makeCollectionStoreMaker`. But its *contract* is daemon-shaped: formula-graph
identity (`FormulaIdentifier`/`FormulaNumber`), the daemon SQLite
manager-database (`DaemonicPersistencePowers`), and daemon-GC retention edges
(`addStoreEdges`/`removeStoreEdges` → `formulaGraph.onPetStoreWrite`). It is
registered as the `collection-store` formula type and surfaced via the
guest/host caplet API. Extraction is feasible but is a whole-file / whole-stack
(Phases 1–4) move requiring a generic persistence/identity/retention interface —
out of scope for this Phase-4 feature PR.

Reply posted: https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5095512522
Proposed: land the feature here; track package extraction as a dedicated
follow-up; asked dckc whether they'd prefer relocating before merge (a
stack-wide restructure) instead. No code change pushed.
