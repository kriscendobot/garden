---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/pass-style/src/typeGuards.js
source_line_range: 1-153
file_commit: 7408280d9f730aeeea0fa60e5bc13f504adcbdde
file_commit_date: 2025-09-15
file_commit_author: Mark S. Miller
comment_subject: four predicate-assertion pairs and Atom as passable-leaf subset
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirty-fourth comment-fragment ingest (cycle 150 — milestone
  tick). 153-line user-facing type-guard surface for
  @endo/pass-style. Last touched 2025-09-15 by Mark S. Miller
  in commit `7408280d9f`. Imports only `passStyleOf` from
  cycle 71 + error/harden primitives.

  §Four predicate-assertion pairs: `isCopyArray` /
  `isByteArray` / `isRecord` / `isRemotable` (one-line
  dispatch to `passStyleOf(val) === '<style>'`) + matching
  `assertX` counterparts. §`Alleged X` default-name
  discipline — each assertion has `optNameOfX = 'Alleged X'`
  second parameter; §default-name-for-anonymous-throw idiom.
  §`Alleged:`-prefix-as-default-name parallel to cycle 136's
  make-far.js *Alleged: Foo* iface convention.

  Single most structurally interesting move: §all-predicates-
  and-assertions-hide-name discipline — *every* export
  (predicates *and* assertions, plus isAtom/assertAtom) gets
  `hideAndHardenFunction`. This is a **departure** from the
  cycle 134 / 138 / 142 / 148 pattern where only assertion
  functions are hidden. §user-facing-thin-wrapper discipline:
  these are *meant* to be invoked from user code where their
  identity in stack traces is uninformative; hiding
  concentrates the trace on the calling site.

  §Atom concept — the §passable-leaf subset. Eight AtomStyle
  cases enumerated in `confirmAtom` switch: undefined / null
  / boolean / number / bigint / string / byteArray / symbol.
  §Atoms-as-passable-values-without-composition-or-identity:
  no copyArray/copyRecord/tagged (composite); no remotable/
  error/promise (have identity or state outside). §marshal-
  table-free property: Atoms encode and decode *without* any
  per-session state.

  §`confirmAtom(val, reject)` private with §two-level-
  rejection discipline: (1) try/catch around `passStyleOf`
  catches *Not even Passable* failures with prefix `Not even
  Passable:`; (2) switch default rejects with `A <passStyle>
  cannot be an atom`. §two-different-error-prefixes-
  discriminate-cause: the caller can distinguish *not @endo-
  pass-style-valid* from *pass-style-valid but not an Atom*.
  §`reject &&` short-circuit short-form (cycle 102's Rejector
  trio pattern).

  §`isAtom = confirm(val, false)` + `assertAtom = confirm(val,
  Fail)` follows cycle 102's checkKey trio. §No-memo-for-Atom:
  unlike cycle 102's keys/checkKey.js's keyMemo WeakSet,
  confirmAtom doesn't memo (check is cheap — one passStyleOf
  + switch).

  §Unsurprising-not-clever shape: the complexity is elsewhere
  (cycle 71's passStyleOf, the @endo/errors primitives). This
  file *republishes* the passStyleOf-as-string mechanism as
  type-narrowing predicates. §Thin-wrappers-over-passStyleOf.
  §Minimal-dependency-surface — imports only passStyleOf +
  error/harden; no marshal, no patterns, no exo. Sits at the
  *bottom* of the @endo dependency stack.

  Cycle 150 was nominally chat-lane (exhausted at 20/20);
  papers-lane blocked 44+ consecutive cycles. Pivoted to
  comments-lane to continue the @endo/pass-style cluster
  (cycles 71 + 87 + 134 + 136 + 138 + 140 + 142 + 148 + 150;
  **ninth pass-style file** ingested). **Cycle 150 is a
  milestone tick** — completing 5 cycles of design+comment
  alternation since the formula-inspector / workers-panel
  daemon observability pair (cycles 145 + 147).
---

> Abstract: `typeGuards.js` (153 lines) is the **user-facing
> type-guard surface** for @endo/pass-style. Imports only
> `passStyleOf` from cycle 71 + error/harden primitives.
>
> §Four predicate-assertion pairs (`isCopyArray` /
> `isByteArray` / `isRecord` / `isRemotable`) with §`Alleged
> X` default-name discipline.
>
> **Single most structurally interesting move**: §all-
> predicates-and-assertions-hide-name discipline — *every*
> export gets `hideAndHardenFunction`, **departing** from the
> cycle 134/138/142/148 hide-only-assertions pattern.
> §User-facing-thin-wrapper rationale.
>
> §Atom concept — §passable-leaf subset. Eight AtomStyle
> cases (undefined/null/boolean/number/bigint/string/byteArray/
> symbol). §Atoms-as-passable-without-composition-or-identity;
> §marshal-table-free property.
>
> §`confirmAtom` private with §two-level-rejection: *Not even
> Passable* (passStyleOf throws) vs *cannot be an atom*
> (passable but composite/identity). §Two-different-error-
> prefixes-discriminate-cause.
>
> §Thin-wrappers-over-passStyleOf. §Minimal-dependency-surface
> at the bottom of @endo's dependency stack.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection](../sections/endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection.md) | pass-style, hardened-javascript, marshal | current |

Tight 153-line user-facing surface. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo@HEAD` (commit
  `7408280d9f730aeeea0fa60e5bc13f504adcbdde`) via the local
  bare-clone.
- Last substantive touch 2025-09-15 by Mark S. Miller.
- **Thirty-fourth comment-fragment ingest.** **Ninth pass-style
  file** in the cluster (cycles 71 + 87 + 134 + 136 + 138 +
  140 + 142 + 148 + 150).
- **Cycle 150 is a milestone tick** — completing 5 cycles of
  design+comment alternation since the daemon observability
  pair landed.
- Cycle 150 was nominally **chat-lane** (exhausted at 20/20);
  papers-lane blocked **44+ consecutive cycles** due to lack
  of PDF-fetching infrastructure. Cycle 150 pivoted to
  comments-lane.
- One cohesion-honest section.
