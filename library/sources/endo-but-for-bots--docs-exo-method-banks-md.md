---
source_kind: design-doc
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: docs/exo-method-banks.md
source_line_range: 1-135
ingested: 2026-06-18
ingested_by: liaison
section_count: 1
status: current
notes: |
  Cycle 389 designs-lane ingest. 135-line design document
  explaining the method-bank-and-exo two-layer pattern used
  in endo-but-for-bots. Thirty-seventh AUTHORED conformant
  single-body section doc in post-refactor era. Seventy-
  ninth consecutive non-garden source after the pivot
  (310-389). §seventy-nine-cycles-with-named-pivot-domain-
  stay.

  Single most structurally interesting move: §the-named-two-
  layer-pattern-method-bank-and-exo — the document names the
  separation between the IMPLEMENTATION layer (the "method
  bank," a plain object whose values are functions) and the
  SURFACE layer (the exo, a hardened remotable created with
  makeExo, validated against an M.interface guard). The
  daemon uses this two-layer pattern systematically. §the-
  named-implementation-vs-surface-as-two-layers as tier-3
  meta-pattern; the method bank composes internally without
  guard overhead, while the exo enforces the guard at the
  external boundary.

  §The-named-three-reasons-for-two-layer — lines 19-27 give
  the three motivations: (1) Internal composition (methods
  call each other without guard overhead); (2) Signature
  adaptation (exo can rename or wrap methods, e.g., expose
  `writeLocator` as `write`); (3) Method inheritance (higher-
  level agents destructure methods from lower-level objects
  and carry them into their own method bank without re-
  implementing). §the-named-three-named-reasons-for-
  architectural-split as tier-3 meta-pattern.

  §The-named-exo-can-rename-methods — line 51 example: the
  exo's `write` is the implementation's `writeLocator`. The
  surface name can differ from the implementation name. §the-
  named-public-name-can-differ-from-private-name as tier-3
  meta-pattern; the exo is a translation layer between
  external naming and internal naming.

  §The-named-method-inheritance-via-destructuring — lines 63-
  89 show Host and Guest agents destructuring methods from
  Directory and Mailbox method banks. The Host's method bank
  is composed from the destructured methods plus agent-
  specific ones. §the-named-method-bank-composition-via-
  destructuring as tier-3 meta-pattern.

  §The-named-each-method-defined-once-at-owning-layer — line
  91-92: "This pattern ensures each method is defined once,
  at the layer that owns the logic, and carried up by
  reference." Single source of truth via reference, not
  re-implementation. §the-named-single-source-of-truth-via-
  reference as tier-3 meta-pattern.

  §The-named-makeIteratorRef-wraps-async-iterators-at-exo-
  boundary — lines 94-110: async iterator methods require
  special handling. The method bank returns a raw async
  iterator; the exo must wrap it in `makeIteratorRef` to
  make it passable over `E()`. §the-named-special-wrapping-
  at-boundary-for-passable-iterators as tier-3 meta-pattern;
  the substrate's passable shape requires explicit wrapping
  of certain return types.

  §The-named-withCollection-wraps-guest-methods-for-GC —
  lines 112-134: Guest methods are wrapped with
  `withCollection` to trigger garbage collection after each
  call. The wrapping applies to the method bank functions,
  not the exo methods. §the-named-method-wrapping-at-bank-
  level-not-exo-level as tier-3 meta-pattern; some wrappers
  belong on the inner layer (method bank), others on the
  outer layer (exo boundary).

  §The-named-unwrappedMethods-set-for-collection-exemption —
  line 122: `unwrappedMethods.has(name) ? fn : withCollection
  (fn)`. A set of method names exempt from the collection
  wrapper. §the-named-exemption-set-for-cross-cutting-
  concern as tier-3 meta-pattern.

  §The-named-Object-fromEntries-Object-entries-pattern-for-
  wrapping — lines 119-124 use the standard JS idiom for
  transforming object values: `Object.fromEntries(Object.
  entries(obj).map(...))`. §the-named-object-fromEntries-
  entries-as-functional-transform as tier-3 meta-pattern.

  §The-named-iterator-method-override-after-spread — lines
  126-134: the exo spreads the wrapped guest methods AND
  THEN overrides the iterator methods with the iteratorRef-
  wrapped versions. Order matters: spread first, override
  second. §the-named-spread-then-override-for-selective-
  replacement as tier-3 meta-pattern.

  §The-named-collectIfDirty-as-named-GC-trigger — line 131:
  `await collectIfDirty()` before returning the iteratorRef.
  Explicit GC trigger named with the dirty-flag pattern.
  §the-named-explicit-GC-with-dirty-flag as tier-3 meta-
  pattern.

  Closes seven citation arcs: cycle 388 (1, adjacent forward;
  AGENTS.md types-index convention extends here with the
  method-bank/exo two-layer pattern) + cycle 387 (1, the 3×3
  exo this-context matrix gets its underlying architecture
  named: the two-layer method-bank-and-exo) + cycle 368 (10,
  exo taxonomy's "this is how exos compose" gains the
  method-bank intermediary) + cycle 367 (10, exo README's
  three-shapes-of-make-and-define gain the two-layer
  decomposition below them) + cycle 327 (9, patterns'
  M.interface is the guard the exo wraps with) + cycle 321
  (11, eventual-send's E() is the call mechanism that
  makeIteratorRef enables for async iterators) + cycle 326
  (63). Pushes citation-arc-closures-in-pivot to FOUR-
  HUNDRED-TWO (395 + 7 net new) — citation-arc-closures-in-
  pivot crosses the four-hundred threshold.
---

135-line design doc explaining the method-bank-and-exo two-layer pattern used in endo-but-for-bots. §the-named-two-layer-pattern-method-bank-and-exo (single most structurally interesting move; separates implementation method bank from surface exo); §the-named-implementation-vs-surface-as-two-layers. §the-named-three-reasons-for-two-layer (Internal composition + Signature adaptation + Method inheritance). §the-named-exo-can-rename-methods (public name differs from private name; e.g., write→writeLocator); §the-named-public-name-can-differ-from-private-name. §the-named-method-inheritance-via-destructuring (Host composes from Directory + Mailbox); §the-named-method-bank-composition-via-destructuring. §the-named-each-method-defined-once-at-owning-layer; §the-named-single-source-of-truth-via-reference. §the-named-makeIteratorRef-wraps-async-iterators-at-exo-boundary; §the-named-special-wrapping-at-boundary-for-passable-iterators. §the-named-withCollection-wraps-guest-methods-for-GC; §the-named-method-wrapping-at-bank-level-not-exo-level. §the-named-unwrappedMethods-set-for-collection-exemption. §the-named-Object-fromEntries-Object-entries-pattern-for-wrapping. §the-named-iterator-method-override-after-spread. §the-named-collectIfDirty-as-named-GC-trigger. **Citation-arc-closures-in-pivot crosses 400 this cycle.** Seven citation arcs closed.
