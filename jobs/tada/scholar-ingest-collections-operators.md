The work is complete. Here is my report.

---

**Job `scholar-ingest-collections-operators` — complete.**

Wore the scholar role and finished the `kriskowal/collections` README corpus by ingesting the remaining generic-operator READMEs. All sources idempotency-checked at file-commit `4688abad` via the GitHub commits API before ingestion.

**Sources ingested (9 sources → 9 sections, 1 each):**
- The eight polymorphic generic operators: `clear`, `clone`, `has`, `hash`, `iterate`, `swap`, `to-array`, `zip`.
- The `copy` extra (a non-polymorphic owned-property micro-utility used to mix generic prototypes).

Each became a `collections--pkg-<name>-readme--overview` section plus a `sources/collections--pkg-<name>-readme.md` index file. Section bodies are lightly-cleaned and mostly verbatim, abstract-first, with the repeated philosophical boilerplate lifted out into a shared concept page rather than duplicated nine times.

**Concept page added:** `concepts/polymorphic-operator.md` — captures the dispatch pattern the job flagged (a free function handles built-in types structurally and delegates to the eponymous method when the operand implements one, covering higher architectural layers while deferring to method names a later type may define, rather than monkey-patching backward). Cross-linked to `generic-order-comparison-protocol` (the `compare`/`equals` instance), `generic-collections`, and `generic-collection-mixin-protocol`; notes `copy` as the non-polymorphic exception and disambiguates from Endo's `@endo/no-polymorphic-call` rule.

**Not ingested (verified, no README at `4688abad`):** `operators` and `permute` ship only `operators.js`/`permute.js` — no README. Recorded in `sources/README.md` alongside the existing `multi-map`/`sorted-map`/`sorted-set` no-README note.

**Indexes updated:** `sources/README.md` (9 rows + prose now marks the corpus complete and records the operators/permute finding), `topics/data-structures.md` (9 rows), `topics/README.md` (count 23→32), `concepts/README.md` (new concept row), `keywords.md` (39 operator/dispatch keyword lines). Followed corpus precedent and left the giant auto-generated `sections/README.md` untouched (the prior 24 collections sections are likewise absent from it; the `sources/README.md` table is the authoritative collections index).

**Mechanics:** worked in an isolated worktree off `origin/journal2` to avoid the concurrently-mutated shared journal tree; committed 24 files explicitly; resolved two rebase conflicts (`keywords.md` and `topics/README.md`, both append-collisions with a concurrent frb gardener — kept both keyword blocks and the peer's newer reactive-bindings row alongside my data-structures count) across ~32 concurrent commits; pushed to `journal2`; verified all artifacts on origin (0/0); removed the worktree.

**Follow-on jobs:** none. The collections README corpus (33 source documents) is complete.

Self-improvement: nothing this time.
