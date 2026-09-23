Job complete. Report follows.

---

## Completion report: attention directive on endojs/endo-but-for-bots #825

**Directive (from dckc, untrusted input treated as data):** "why is this in the daemon package? It can, and hence should, go in its own package, yes?" — on the Phase-4 persistent sorted collection stores.

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer had resolved it) → proceeded.

**Routing decision.** This is a design/architecture question from a maintainer-authority, not a concrete in-scope code fix. I routed it to a substantive PR reply and deliberately did **not** unilaterally refactor, because the extraction is out of scope for this Phase-4 feature PR (see below). No code was pushed.

**Coupling analysis I based the reply on** (`packages/daemon/src/collection-store.js`):
- Already dependency-injected: at runtime it imports only public `@endo/*` packages (harden, exo, patterns, errors) — no daemon-internal runtime import — and takes all daemon seams through the injected `powers` object of `makeCollectionStoreMaker`.
- But its *contract* is daemon-shaped: formula-graph identity (`FormulaIdentifier`/`FormulaNumber`), the daemon SQLite manager-database (`DaemonicPersistencePowers`), and daemon-GC retention edges (`addStoreEdges`/`removeStoreEdges` → `formulaGraph.onPetStoreWrite`, re-seeded from durable rows on restart). It is registered as the `collection-store` formula type and surfaced through the guest/host caplet API.
- So extraction is feasible but is a whole-file / whole-stack move (Phases 1–4 all live in this one file) requiring a generic persistence/identity/retention interface — not a Phase-4 addition.

**Actions taken:**
- Posted a substantive reply engaging the question honestly and proposing a path (land the feature here; track package extraction as a dedicated follow-up; asked dckc whether they'd instead prefer relocating before merge — a stack-wide restructure I offered to take on): https://github.com/endojs/endo-but-for-bots/pull/825#issuecomment-5095512522 (verified rendered correctly by re-fetch — no `@`-file literal defect). Standing comment authorization covers this repo.
- Journaled the outward-facing comment: `entries/2026/07/27/185732Z-result-gardener-5b9464.md`.

**No code change / no push.** Correct for an attention directive that is a design question awaiting the maintainer's disposition.

**Follow-ups (owner: dckc's choice):**
- If dckc wants extraction: a dedicated refactor PR (or stack restructure across Phases 1–4) to factor `collection-store` into its own package behind a generic persistence/identity/retention interface. Awaiting their reply, which routes back to this job's inbox / a fresh job.
- The separately-requested "run the gauntlet #825" is its own job (`endojs-endo-but-for-bots-pr825-gauntlet`), not part of this one.
