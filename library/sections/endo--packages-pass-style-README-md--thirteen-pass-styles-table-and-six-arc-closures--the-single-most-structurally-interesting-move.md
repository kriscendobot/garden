---
title: The single most structurally interesting move
source: endo--packages-pass-style-README-md
url: https://github.com/endojs/endo/blob/master/packages/pass-style/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/README.md
total-lines: 216
ingest-cycle: 325
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-exhaustive-enumeration-via-table
  - the-named-thirteen-pass-styles-in-one-table-fixed-set
  - the-named-closed-set-IS-named-security-foundation
  - the-named-pass-by-copy-vs-pass-by-presence-distinction
  - the-named-binary-distinction-with-internal-substructure
  - the-named-Far-doesn-t-validate-with-pointer-to-exo
  - the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere
  - the-named-makeTagged-IS-named-extension-point
  - the-named-extension-point-IS-named-API-shape
  - the-named-five-named-requirements-for-passability
  - the-named-tentatively-modal
  - the-named-hedge-word-in-canonical-rule
  - the-named-canonical-counterexamples-after-canonical-examples
  - the-named-counterexample-discipline
  - the-named-Use-for-and-Pass-styles-pair-rows-discipline
  - the-named-type-guards-section-with-canonical-imports
  - the-named-Deep-Dives-IS-named-implementation-detail-section
  - the-named-monorepo-docs-reference
  - the-named-Hardened-JS-mentioned-pervasively-but-no-section
  - sixteen-cycles-with-named-pivot-domain-stay
  - nine-named-packages-in-the-pivot-cluster
  - fourteen-citation-arc-closures-in-pivot-now
  - six-citation-arc-closures-in-one-cycle
  - two-cycles-with-named-role-label-before-package-name
  - two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken
parent: endo--packages-pass-style-README-md--thirteen-pass-styles-table-and-six-arc-closures
---

**§the-named-exhaustive-enumeration-via-table** — the pass-style table (line 20-34) lists *all thirteen pass-styles* in one structured artifact:

| Pass Style | Category | Description | Examples |
|---|---|---|---|
| `'null'` | Primitive | The null value | `null` |
| `'undefined'` | Primitive | The undefined value | `undefined` |
| `'boolean'` | Primitive | Boolean primitives | `true`, `false` |
| `'number'` | Primitive | IEEE 754 floats | `42`, `3.14`, `NaN`, `Infinity` |
| `'bigint'` | Primitive | Arbitrary-precision integers | `123n`, `-456n` |
| `'string'` | Primitive | Well-formed strings | `'hello'`, `''` |
| `'symbol'` | Primitive | Registered/well-known symbols | `Symbol.iterator` |
| `'copyArray'` | Pass-by-copy | Frozen arrays of passables | `harden([1, 2, 3])` |
| `'copyRecord'` | Pass-by-copy | Frozen plain objects | `harden({ x: 10 })` |
| `'remotable'` | Pass-by-presence | Far objects & remote presences | `Far('Counter', {...})` |
| `'tagged'` | Extension | Domain-specific types | `makeTagged('copySet', [...])` |
| `'error'` | Pass-by-presence | Error objects | `harden(Error('failed'))` |
| `'promise'` | Pass-by-presence | Promise objects | `Promise.resolve(42)` |

**§the-named-thirteen-pass-styles-in-one-table-fixed-set** — first-explicit-observation. The table commits to an *exhaustive*, *categorized*, *example-bearing*, *extension-aware* enumeration. The README states: *"Every passable value has exactly one pass style from a fixed set of possibilities."* (line 13-14)

**§the-named-closed-set-IS-named-security-foundation** — the whole capability-security argument of @endo rests on this set being **closed** (no new pass-styles can be added at runtime), **knowable** (every Passable value classifies to exactly one), and **complete** (no Passable values fall outside). The table format makes the closure *legible at a glance* and *committed in artifact form*. Prose would obscure the exhaustiveness; a table forces the schema-discipline (style + category + description + example) for each row. First-explicit-observation as a tier-3 meta-pattern.

The thirteen styles partition into **four categories**:
- **Primitive** (7): null + undefined + boolean + number + bigint + string + symbol
- **Pass-by-copy** (2): copyArray + copyRecord
- **Pass-by-presence** (3): remotable + error + promise
- **Extension** (1): tagged

**§the-named-pass-styles-organized-by-category** — the categorization names the *binary distinction* (copy vs reference) but the categories *split* copy and reference into sub-categories. **§the-named-binary-distinction-with-internal-substructure** — first-explicit-observation as a structural pattern that contrasts with cycle 321's *four-target cartesian product* (locality × resolution). Pass-style has a *single* binary axis (copy-vs-presence) but the axis sprouts a structure (Primitive vs Composite within copy; remotable vs promise vs error within presence; plus the Extension category for tagged).
