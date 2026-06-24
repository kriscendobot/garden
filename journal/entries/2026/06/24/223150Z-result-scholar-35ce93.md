---
ts: 2026-06-24T22:31:50Z
kind: result
role: scholar
project: collections
refs:
  - library/concepts/polymorphic-operator.md
---

Ingested the remaining `kriskowal/collections` generic-operator READMEs (job `scholar-ingest-collections-operators`), completing the collections README corpus. All sources at file-commit `4688abad` (idempotency-checked per-file via the GitHub commits API; all eight operators plus `copy` confirmed at that anchor).

**Sources ingested (9 sources, 9 sections, 1 each):**
`clear`, `clone`, `has`, `hash`, `iterate`, `swap`, `to-array`, `zip` (the eight polymorphic generic operators) and `copy` (the non-polymorphic owned-property micro-utility). Each became one `collections--pkg-<name>-readme--overview` section plus a `sources/collections--pkg-<name>-readme.md` index file.

**Concept page added:** `concepts/polymorphic-operator.md` — captures the shared free-function-delegates-to-eponymous-method dispatch pattern (handle built-in types structurally, defer to a method a later architectural layer may define rather than monkey-patching backward) that all eight operators and the already-ingested `compare`/`equals` follow. Cross-linked to `generic-order-comparison-protocol` (the comparison instance), `generic-collections`, and `generic-collection-mixin-protocol`. Notes `copy` as the non-polymorphic exception and disambiguates from Endo's `@endo/no-polymorphic-call` rule.

**Not ingested (no README at `4688abad`, verified via the contents API):** `operators` and `permute` ship only `operators.js` / `permute.js`, no README. Recorded alongside the existing `multi-map`/`sorted-map`/`sorted-set` no-README note in `sources/README.md`.

**Indexes updated:** `sources/README.md` (9 new rows + prose paragraph now marks the corpus complete and records the operators/permute no-README finding), `topics/data-structures.md` (9 section rows), `topics/README.md` (data-structures count 23→32), `concepts/README.md` (polymorphic-operator row), `keywords.md` (39 operator/dispatch-pattern keyword lines). Followed corpus precedent and did not add rows to the giant auto-generated `sections/README.md` (the prior 24 collections sections are likewise absent from it; `sources/README.md` is the authoritative collections index).

**Follow-on jobs:** none. The collections README corpus (33 source documents: 4 mixins, 10 operators-and-helpers, 19 concrete structures) is complete.

Self-improvement: nothing this time.
