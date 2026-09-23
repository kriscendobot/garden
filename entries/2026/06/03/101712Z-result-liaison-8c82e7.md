---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--8c82e7
ts: 2026-06-03T10:17:12Z
ref_id: 8c82e7
---

# Cycle 150 result — pass-style/src/typeGuards.js (milestone tick; thirty-fourth comment-fragment ingest)

**Cycle 150 — milestone tick.** Nominally chat-lane (exhausted at
20/20); papers-lane blocked **44+ consecutive cycles**. Pivoted to
comments-lane.

## Source

`endo/packages/pass-style/src/typeGuards.js` (153 lines). Last
touched 2025-09-15 by Mark S. Miller in commit `7408280d9f`. The
*user-facing type-guard surface* for @endo/pass-style. Imports only
`passStyleOf` from cycle 71 + error/harden primitives.

**Ninth pass-style file ingested** (cluster: 71 + 87 + 134 + 136 +
138 + 140 + 142 + 148 + 150).

## Structural moves captured

- **§Four predicate-assertion pairs**: `isCopyArray` /
  `isByteArray` / `isRecord` / `isRemotable` (one-line dispatch to
  `passStyleOf(val) === '<style>'`) + matching `assertX`
  counterparts. §`Alleged X` default-name discipline.

- **Single most structurally interesting move**: §all-predicates-
  and-assertions-hide-name discipline — *every* export
  (predicates *and* assertions, plus isAtom/assertAtom) gets
  `hideAndHardenFunction`. This is a **departure** from the cycle
  134 / 138 / 142 / 148 pattern where only assertion functions are
  hidden. §user-facing-thin-wrapper rationale: meant to be invoked
  from user code where wrapper identity is uninformative.

- **§Atom concept** — the §passable-leaf subset. Eight AtomStyle
  cases: undefined / null / boolean / number / bigint / string /
  byteArray / symbol. §Atoms-as-passable-values-without-composition-
  or-identity. §marshal-table-free property.

- **§`confirmAtom`** private with §two-level-rejection discipline:
  (1) try/catch around `passStyleOf` catches *Not even Passable*
  with prefix `Not even Passable:`; (2) switch default rejects with
  `A <passStyle> cannot be an atom`. §two-different-error-prefixes-
  discriminate-cause.

- **§Rejector trio**: `isAtom = confirm(val, false)` +
  `assertAtom = confirm(val, Fail)` follows cycle 102's checkKey
  trio.

- **§Thin-wrappers-over-passStyleOf**; §minimal-dependency-surface
  at the bottom of @endo's dependency stack.

## Output summary

- **Source slug**: `endo--packages-pass-style-src-typeGuards-js`
- **Sections**: 1 cohesion-honest section
  - `endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection.md`
- **Topics**: pass-style, hardened-javascript, marshal
- **Library totals**: 654 sections from 195 source documents
- **Lane rotation**: nominally chat-lane (exhausted; papers-lane
  blocked 44+ consecutive cycles); pivoted to comments-lane

## Milestone

**Cycle 150 closes.** Five cycles of design+comment alternation
since the daemon observability pair (cycles 145 + 147):

| Cycle | Lane | Subject |
|-------|------|---------|
| 145 | design | formula-inspector (pop-the-bonnet debug tool) |
| 146 | comment | E.js (eventual-send user-facing surface) |
| 147 | design | workers-panel (daemon observability sister) |
| 148 | comment | symbol.js (Hilbert-Hotel encoding) |
| 149 | design | unhandled-rejection-display (two-coordinated-changes) |
| 150 | comment | typeGuards.js (passable-leaf Atom subset) |

The pass-style cluster has grown to nine ingested files; the
@endo/pass-style stack is now well-mapped from the foundational
helpers (cycle 142) through the classifier (cycle 71) through the
type-guard surface (this cycle).

Schedule next wake 1500s for cycle 151.
