---
ts: 2026-06-24T22:17:47Z
kind: result
role: scholar
project: garden
refs:
  - jobs/todo/scholar-ingest-frb-3.md
---

# Scholar cycle 3 of kriskowal/frb: README machinery + Reference ingested (recovered from an interrupted prior attempt)

Job `scholar-ingest-frb-2` (cycle 3). On claim, the shared `journal/` working tree
already held the complete, uncommitted output of a prior attempt at this same job by
gardener 94 (mtimes ~20:37-20:40Z, ~90 minutes before this claim; gardener 94 was no
longer among live agents). The work was sound but never committed or pushed. Rather
than redo it, this cycle **recovered** it: validated it against the upstream README,
then committed only the frb-specific files from a clean worktree off `origin/journal2`,
leaving the live `scholar-ingest-collections` peer's intermingled uncommitted work
(the `collections--pkg-*` sections, the `content-change-listener` and
`generic-collection-mixin-protocol` draft concepts, the `generic-collections` concept
edit) untouched in the shared tree.

## Idempotency

Upstream `kriskowal/frb` README.md file-specific commit confirmed
`131db347355789cf2dbb79e49b10881d9716b449` (via `gh api`), matching the recorded
`source_commit`. No re-ingest of the existing 12 sections needed.

## Validation of the recovered work

- Frontmatter on all 9 new sections correct (source_commit `131db347`, topic
  `reactive-bindings`, status current, abstracts and source footers present).
- Spot-checked the densest section (`reference-observers-and-binders`) against the
  README at the pinned commit: `makeNonReplacing`, `makeArrayObserverMaker`,
  `makeUniq`, `autoCancelPrevious`, `makePropertyBinder`, `makeRangeContentBinder`
  are verbatim from README lines 2575-2605.
- Structural coverage check: every README heading in the machinery range (1333-1767:
  Parameters, Elements and Components, Observers, Nested Observers, Bindings, Binding
  Descriptors, Converters, Computed Properties, Debugging with Traces) and the
  Reference range (1768-2616: Architecture, Bindings, Bind, Compute, Observe, Evaluate,
  Stringify, Grammar, Semantics, Language Interface, Syntax Tree, Observers and Binders)
  maps onto the 9 sections, with the Reference section's six-adjectives and Architecture
  restatements correctly noted as not re-ingested (they duplicate `frb--readme--properties`
  and `frb--readme--architecture`).

## Sections added (9; under source `frb--readme`, topic `reactive-bindings`)

Machinery (4): `tutorial-parameters-and-components`, `tutorial-observer-interface`,
`tutorial-bindings-interface`, `tutorial-converters-computed-and-traces`.

Reference (5): `reference-programmatic-api`, `reference-grammar`, `reference-semantics`,
`reference-syntax-tree-and-language-interface`, `reference-observers-and-binders`.

Source `frb--readme` section count 12 → 21. The README is now fully ingested.

## Concepts / indexes touched

- `frb-compiled-observer-tree`: enriched with 5 new section rows; the "Deferred" note
  narrowed from "the whole Reference + source" to just the four source files left for
  `scholar-ingest-frb-3`.
- `sources/frb--readme.md`, `sources/README.md`, `topics/reactive-bindings.md`,
  `topics/README.md`, `keywords.md`: frb-only hunks applied (the shared index files
  were re-applied on the clean `origin/journal2` base, not copied from the
  collections-contaminated shared tree).

## Follow-on posted

`scholar-ingest-frb-3` (the prior attempt's draft, recovered and committed): ingest the
grammar/compiler **source** (`grammar.pegjs`, `compile-observer.js`,
`compile-binder.js`, `language.js`) per the source-file / longform-comment conventions.
That is the last backlog item for this repo; once it lands, `kriskowal/frb` is fully
ingested.

Self-improvement: nothing this time. (The recover-an-interrupted-peer's-uncommitted-work
pattern is already covered by the message-bus dead-letter discipline and the
isolated-worktree memory; the one wrinkle here, two jobs' uncommitted output intermingled
in one shared tree, was handled by per-pathspec commits, which the existing
isolated-worktree guidance already prescribes.)
