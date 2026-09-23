Job complete.

**Design delivered: a Sussman/Radul propagator at the Endo and Exo layers**

- **Design slug:** `propagator-cells`
- **DRAFT PR:** [endojs/endo-but-for-bots#529](https://github.com/endojs/endo-but-for-bots/pull/529), branch `design/propagator-cells`, based on the `llm` roadmap branch. Confirmed `isDraft: true`, `state: OPEN`.

**What I did**
- Wore the designer role; researched first. Read the curated library for grounding: the `reactive-bindings` topic and FRB `frb--readme--reference-semantics` (the `<->` two-way binding, automatic algebraic inversion, null-suppression), the agoric notifier `lossiness` section (latest/lossy vs changes/lossless), the `crdt-in-formula-persistence` concept, the exo taxonomy, `eventual-send`, `daemon-cross-peer-gc`, and `hardened-javascript`.
- Wrote `designs/propagator-cells.md` (matching the project's metadata-table convention and sentence-per-line markdown style, with two mermaid diagrams). It covers: the Radul/Sussman model cited as external lineage; the Endo layer (`@endo/propagator` — cell/propagator/scheduler interfaces, the injected `Lattice` contract with nothing/value/interval/set domains, hardening, and explicit teardown of the cyclic neighbor graph); the FRB `<->` generalization table; the Exo lift (`@endo/exo-propagator` — `CellReader`/`CellWriter`/`CellAdmin` facets via `defineExoClassKit`, async cross-vat eventual merge with a state-based-CRDT convergence argument, contradiction-as-passable, ocap attenuation); situating it as the idempotent-convergence member of the change-propagation family beside *latest* and *changes*; a 5-phase plan; design decisions; and open questions. The `exo-` prefix on the passable package follows the designer naming norm.
- Updated `designs/README.md` with a summary-table row (Proposed) and a "Recently added" entry.
- Committed under the bot identity (`endolinbot`), pushed, opened the draft PR, and wrote a `result` entry to the journal (`journal2`).

**What changed:** two files added/modified on a new branch; one draft PR opened; one journal result entry.

**Follow-ups (noted in the doc and PR):**
- Full README milestone / dependency-graph / Gantt integration is deferred to a grooming pass (design is DRAFT and unscheduled).
- The `@endo/pubsub` `makeLatestTopic` / `makeChangeTopic` surface is flagged in the library keywords as load-bearing but not yet curated; left as an open question for the builder to confirm before the cell's `follow()` stream depends on it.
- Hardening open question: WeakRef/`FinalizationRegistry` GC of subnetworks vs explicit `dispose()`, given a propagator can be the sole keeper of a cell's freshness.

Worktrees I created (project + journal) were torn down; inbox drained empty at every checkpoint. Self-improvement: nothing this time.
