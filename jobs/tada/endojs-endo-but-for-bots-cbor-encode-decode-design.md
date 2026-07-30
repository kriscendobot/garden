# Completion report: endojs-endo-but-for-bots-cbor-encode-decode-design

Design-stage follow-up to kriskowal's approving review of PR #885, which
asked for a refactor that splits `@endo/cbor` into `@endo/cbor/encode`
and `@endo/cbor/decode` so readers do not retain writers and vice versa.

## What I did

- Wore the **designer** role. Read `roles/designer/AGENT.md`, the
  project's `designs/AGENTS.md` conventions, the originating review on
  #885, the existing `designs/cbor-codec.md` (the package's source of
  truth), and the live `packages/cbor/index.js` plus the #885 consumer
  import patterns in `packages/ocapn/src/cbor/{encode,decode}.js`.
- Drafted `designs/cbor-encode-decode.md` — a self-contained design for
  the entry-point split, matching the project's metadata-table and
  section conventions.
- Registered the design in `designs/README.md`: summary table, M4
  milestone table, per-design estimate (XS, <1 day), M4 count (8 → 9),
  the "Recently added or revised" header, and the recently-added list.
- Committed on a `design/cbor-encode-decode` branch, pushed to the
  `kriscendobot` fork, and opened **draft PR #896** against the `llm`
  roadmap branch.
  - https://github.com/endojs/endo-but-for-bots/pull/896
  - Draft, base `llm`, head `kriscendobot:design/cbor-encode-decode`.

## What changed

- `designs/cbor-encode-decode.md` (new, 445 lines): the design.
- `designs/README.md`: roadmap registration (5 additive edits).

## Design summary

The split factors `packages/cbor/index.js` (741 lines) into:

- `encode.js` — the `write*` exports, `makeCborWriter`,
  `cborWriterBytes`, and encode-private helpers (`append`,
  `appendBytes`, `appendBigEndian`, `assertHeadArgument`, `assertCount`,
  `assertMajor`, `writeCountHead`, `minimalBignumBytes`).
- `decode.js` — the `read*` exports, `makeCborReader`, `peekHead`, and
  decode-private helpers (`readerError`, `take`, `readHeadInternal`,
  `headCount`, `expectHead`).
- `internals.js` (not a subpath export) — the four shared runtime
  bindings both halves need from one definition: `canonicalInfo` (the
  minimal-length selector the writer emits and the reader's minimality
  check compares against), `CANONICAL_NAN`, `UINT64_BOUND`,
  `UINT32_BOUND`. Keeping these in one internal module preserves the
  byte-identity invariant structurally rather than as a review
  inspection.

`package.json` declares `./encode` and `./decode` subpath exports; the
root `.` re-export is preserved (`export *` from both halves, whose
export name sets are disjoint, asserted by the test plan). No signature,
canonicality, or number-domain change — a packaging refactor refining
`cbor-codec.md`, which stays the source of truth. Migration retargets
ocapn (post-#885) and slots imports to the narrower entry points; the
root import stays valid. **Does not modify PR #885.**

## Verification

- Not verified by execution: this is a design-stage deliverable (no
  code changed in `packages/cbor`). The design's test plan specifies
  the execution checks a future builder runs (ported suite retargeted
  to all three entry points, export-name disjointness, root re-export
  completeness, internals-not-exported, ocapn suites green post-retarget).
- Mermaid: the design document contains no mermaid fences; the README
  mermaid graphs were not modified (diff is purely additive).
- PR #896 confirmed draft, base `llm`, head `design/cbor-encode-decode`.

## Follow-ups

- A builder dispatch implements the split once the design is accepted
  (phase 1: split the module; phase 2: retarget ocapn post-#885; phase
  3: retarget slots post-#124; phase 4 optional: daemon envelope).
- Open questions surfaced for the maintainer: (1) whether to deprecate
  the root `@endo/cbor` import in a future cycle (design says keep it);
  (2) whether `internals.js` warrants a subpath export for audit tools
  (design says no).
