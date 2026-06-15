---
title: "@endo/pass-style README.md — thirteen pass-styles enumerated in fixed table; six citation arcs close (cycles 71/87/134/136/148/150); ninth package; Hardened-JS pervasive but no section"
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
---

# `@endo/pass-style README.md` — thirteen pass-styles in a fixed table; six arc closures

The 216-line README for `@endo/pass-style` — the foundational classifier package. Cycle 325 is **designs-lane after cycle 324's chat-lane @endo/captp/src/atomics.js**. **Sixteenth consecutive non-garden source after the pivot** (cycles 310-325). **§sixteen-cycles-with-named-pivot-domain-stay**. **Ninth package added to pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + **pass-style**) — pass-style was already heavily in the library via cycles 71 + 87 + 134 + 136 + 138 + 140 + 142 + 148 + 150 (nine prior comment-fragment ingests).

Cycle 325 closes **six citation arcs** in one cycle — the **largest single-cycle arc-closure count in the pivot**:

| Cycle 325 closes | Arc length | Subject |
|---|---|---|
| Cycle 71 | 254 cycles | passStyleOf.js classifier internals → README's Core Functions section |
| Cycle 87 | 238 cycles | error.js passable-error validation → README's `'error'` row in pass-style table |
| Cycle 134 | 191 cycles | remotable.js → README's Far(iface, methods) section |
| Cycle 136 | 189 cycles | make-far.js → README's iface-naming convention |
| Cycle 148 | 177 cycles | symbol.js Hilbert-Hotel encoding → README's `passableSymbolForName()` mention |
| Cycle 150 | 175 cycles | typeGuards.js four predicate-assertion pairs → README's Type Guards section |

**§fourteen-citation-arc-closures-in-pivot-now** (1, 2, 4, 165, 169, 175, 175, 177, 189, 191, 214, 238, 254, 255 cycles). The cycle 71 arc is the **second-longest closure in the pivot**, just one cycle shorter than cycle 321's 255-cycle closure to cycle 66.

**§six-citation-arc-closures-in-one-cycle** — first-explicit-observation as a record. The pivot now has a clear *long-tail* of arc closures: as the pivot continues, the older comment-fragments are progressively closed by the newer README ingests.

## The single most structurally interesting move

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

## §the-named-Far-doesn-t-validate-with-pointer-to-exo

(Line 88-90) — *"Far objects are remotable but don't validate their inputs. For defensive objects with automatic input validation, see [@endo/exo](../exo/README.md)."*

**§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** — the README *explicitly admits a limit* (pass-style doesn't do input validation) and *points to the sibling package that does*. This is the **inverse** of cycle 321's role-label discipline (which named what each package does, FROM the citing package). Here, the *cited* package names what it *doesn't* do.

First-explicit-observation. Structurally novel because it:
1. Admits the limit honestly
2. Points to the solution
3. Implicitly says "this package's role is X; for Y, see Z"
4. Forms a *two-way* citation graph: cycle 321 cited @endo/exo as "Defensive Objects"; cycle 325 cites @endo/exo as "where to go for validation". Both ends agree on the role.

This is sibling to cycle 323's **§the-named-API-with-honesty-about-relaxed-security-model** (the TrapCaps disclaimer) and cycle 321's **§the-named-API-with-honesty-about-low-utility-paths** ("most users don't need this"). The pattern is **§the-named-honesty-about-API-boundaries** — admit what the API doesn't do.

**§the-named-honesty-about-API-tradeoffs** now has **three named subtypes**:
- **Low-utility-paths** (cycle 321): "most users don't need this"
- **Relaxed-security-models** (cycle 323): "not for mutually-suspicious parties"
- **Functionality-not-in-this-package** (cycle 325): "for validation, see @endo/exo"

§three-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325) — first-explicit-observation as a *parameterized* meta-pattern with three subtypes.

## Other key moves

- **§the-named-five-named-requirements-for-passability** (line 109-117) — numbered list: 1. Primitives always passable (except unregistered symbols); 2. Objects must be frozen; 3. No cyclic references; 4. Strings must be well-formed; 5. Symbols must tentatively use passableSymbolForName(). **§the-named-five-requirements-IS-named-substrate-rules**. First-explicit-observation.

- **§the-named-tentatively-modal** (line 116) — *"Symbols must **tentatively** be created using passableSymbolForName()"*. The word **tentatively** hedges the rule. **§the-named-hedge-word-in-canonical-rule** — first-explicit-observation. The hedge marks a rule as *currently-in-place but possibly-subject-to-change*; the reader is signaled to expect future revision. Compare to cycle 321's "what we call" meta-discourse and cycle 323's "not for mutually-suspicious parties" disclaimer — these are *related* but different shapes of meta-discourse. **§three-cycles-with-named-meta-discourse-in-pivot-READMEs** (321 + 323 + 325; "what we call" + "not for mutually-suspicious" + "tentatively").

- **§the-named-canonical-counterexamples-after-canonical-examples** (line 119-129) — passable example + two NOT-passable examples (not frozen + cyclic). **§the-named-counterexample-discipline** — show what's *not* covered to disambiguate the rule's edges. First-explicit-observation.

- **§the-named-makeTagged-IS-named-extension-point** (line 92-105) — *"CopyTagged object, the extension point for domain-specific data types"*. **§the-named-extension-point-IS-named-API-shape** — first-explicit-observation. The 'tagged' pass-style is the *only* row in the table marked as "Extension"; it's the forwards-compatibility hatch. §the-named-extension-via-named-axis.

- **§the-named-Use-for-and-Pass-styles-pair-rows-discipline** (line 138-140, 157-159) — each of Pass-by-Copy and Pass-by-presence sections includes a "Use for:" row and a "Pass styles:" row. The two rows together give the reader both the *when* (use for) and the *what* (pass styles). **§the-named-when-and-what-pair-rows** — first-explicit-observation.

- **§the-named-type-guards-section-with-canonical-imports** (line 170-190) — four predicate-assertion pairs destructured from `@endo/pass-style`: `{ isRecord, assertRecord, isCopyArray, assertCopyArray, isRemotable, assertRemotable, isAtom, assertAtom }`. **§the-named-four-predicate-assertion-pairs-cited-by-README** — closes citation arc with cycle 150 typeGuards.js (which had the same four pairs as §Four predicate-assertion pairs). §two-cycles-with-named-four-predicate-assertion-pairs (150 + 325; doc/impl boundary).

- **§the-named-Integration-with-Endo-Packages-with-role-labels** (line 192-201) — four packages cited with role labels: Validation (patterns) + Defensive Objects (exo) + Communication (eventual-send) + Serialization (marshal). **§two-cycles-with-named-role-label-before-package-name** (321 + 325) — first-explicit-observation as a recurring discipline.

- **§the-named-Deep-Dives-IS-named-implementation-detail-section** (line 207-216) — points to four documents *within* the package: copyRecord-guarantees.md + copyArray-guarantees.md + enumerating-properties.md + types.js. **§the-named-internal-docs-pointer-section**. First-explicit-observation. Contrasts with cycle 321 eventual-send's "Complete Tutorial" + See Also section (which pointed to *external* sources).

- **§the-named-monorepo-docs-reference** (line 203-205) — `[Message Passing](../../docs/message-passing.md)` — path goes *up two levels* from the package, into the monorepo's shared docs/. First-explicit-observation as a monorepo-specific reference pattern.

- **§the-named-Hardened-JS-mentioned-pervasively-but-no-section** — the README uses `harden()` in numerous examples (line 29, 30, 33, 47, 48, 66, 78, 112, 121, 127, 143, 162) but has **no dedicated Hardened-JavaScript section**. **§two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken** (323 + 325). For pass-style, the reason is structural: pass-style *defines what hardening means in this context*; a Hardened-JS section would be circular. First-explicit-observation as a deeper kind of break than cycle 323's (which was absence-via-presupposition; cycle 325's is absence-via-foundational-status).

- **§the-named-Far-iface-IS-named-identity-string** (line 80) — `Far('Counter', { ... })` — the first argument names the remotable's identity. **§the-named-iface-name-IS-named-debug-handle**. Closes citation arc with cycle 134/136 (which examined Far / make-far).

## Patterns the cycle extends

- §sixteen-cycles-with-named-pivot-domain-stay (310-325)
- §nine-named-packages-in-the-pivot-cluster (ninth: pass-style)
- §fourteen-citation-arc-closures-in-pivot-now (added six in this cycle)
- §six-citation-arc-closures-in-one-cycle (new record)
- §two-cycles-with-named-role-label-before-package-name (321 + 325)
- §two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325)
- §three-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325; three named subtypes)
- §three-cycles-with-named-meta-discourse-in-pivot-READMEs (321 + 323 + 325)
- §two-cycles-with-named-four-predicate-assertion-pairs (150 + 325; doc/impl)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags marked first-explicit-observation above. Highest-portability observations:

- **§the-named-exhaustive-enumeration-via-table** — exhaustive enumerations belong in tables, not prose; the table forces a schema-discipline per row
- **§the-named-closed-set-IS-named-security-foundation** — capability-security rests on closed, knowable, complete classifications
- **§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** — admit what this package *doesn't* do; point to the sibling that does
- **§the-named-hedge-word-in-canonical-rule** — words like "tentatively" mark rules as currently-in-place but possibly-subject-to-change
- **§the-named-counterexample-discipline** — show what's NOT covered to disambiguate the rule's edges
- **§the-named-when-and-what-pair-rows** — Use-for + Pass-styles pair rows give the reader both the *when* and the *what*

## Tier-2 borrowing (multi-cycle patterns extended)

- §sixteen-cycles-with-named-pivot-domain-stay
- §nine-named-packages-in-the-pivot-cluster
- §fourteen-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-honesty-about-API-tradeoffs (three named subtypes)
- §three-cycles-with-named-meta-discourse-in-pivot-READMEs
- §two-cycles-with-named-role-label-before-package-name
- §two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken

## Tier-3 borrowing (meta-patterns)

- **§the-named-closed-set-IS-named-security-foundation** — capability-security rests on closed, knowable, complete classifications
- **§the-named-exhaustive-enumeration-via-table** — tables for exhaustive enumerations; prose for narratives
- **§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** — inverse of role-label citation; cited package names what it doesn't do
- **§the-named-honesty-about-API-tradeoffs** with three named subtypes (low-utility + relaxed-security + functionality-elsewhere)
- **§the-named-hedge-word-in-canonical-rule** — "tentatively", "what we call", "not for X" — meta-discourse markers that signal rule-status to readers
- **§the-named-binary-distinction-with-internal-substructure** — a single binary axis can sprout categorical substructure within each side
- **§the-named-Hardened-JS-absent-as-section-by-foundational-status** — when a package *defines* a discipline, a section about that discipline would be circular

## Synthesis-target

Slot machine library **§`@game/pass-style/README.md`** — defines what data can be passed between game subsystems (server / renderer / persistence / network):

1. **Exhaustive table** of every game-passable value type with category + description + example.
2. **Closed-set commitment**: state that the table is the *complete* enumeration; no new types can be added at runtime.
3. **Categories**: Primitive + Pass-by-copy + Pass-by-presence + Extension; tagged as the extension point.
4. **Numbered requirements** for passability (frozen + no cycles + well-formed strings + etc).
5. **Counterexamples after examples** to disambiguate the rule's edges.
6. **Use-for + Pass-styles pair rows** for each major category.
7. **Cross-package pointer** for functionality this package deliberately doesn't include (e.g., "for input validation, see @game/exo").
8. **Hedge words** in canonical rules when the rule is currently-in-place but possibly-subject-to-change.
9. **Type Guards section** with canonical predicate-assertion pair imports.
10. **Integration with Endo Packages section** with role labels.
11. **Deep Dives section** pointing to per-package implementation documents.
12. **Hardened-JS pervasive but no section** — if the package *defines* hardening for its scope, a Hardened-JS section would be circular.
13. **Tentatively-modal language** for any rule that may need to evolve as the game's data model matures.

## Library state after cycle 325

- §library-reaches-837-sections from 373 source documents
- §one-hundred-and-fifty-eighth consecutive designs-chat alternation
- §sixteen-cycles-with-named-pivot-domain-stay
- §nine-named-packages-in-the-pivot-cluster
- §fourteen-citation-arc-closures-in-pivot-now (cycle 325 contributed six, the largest single-cycle count)
- §six-citation-arc-closures-in-one-cycle (new record)
- §three-cycles-with-named-honesty-about-API-tradeoffs (three named subtypes; low-utility + relaxed-security + functionality-elsewhere)
- §three-cycles-with-named-meta-discourse-in-pivot-READMEs (321 + 323 + 325)
