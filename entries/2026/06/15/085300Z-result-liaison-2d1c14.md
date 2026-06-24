---
kind: result
role: liaison
dispatch-root: dispatches/liaison--2d1c14
cycle: 325
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 325: @endo/pass-style README.md (designs-lane; ninth package; six citation arcs close — largest single-cycle closure)

Cycle 325 ingest: **@endo/pass-style README.md** (216 lines). Designs-lane after cycle 324. **Sixteenth consecutive non-garden source after the pivot** (cycles 310-325). **§sixteen-cycles-with-named-pivot-domain-stay**. **Ninth package added to pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + **pass-style**); pass-style was already heavily in library via nine prior comment-fragments (cycles 71/87/134/136/138/140/142/148/150).

## Six citation arcs close in one cycle — new record

| Cycle 325 closes | Arc length | Subject |
|---|---|---|
| Cycle 71 | 254 cycles | passStyleOf.js classifier → README's Core Functions |
| Cycle 87 | 238 cycles | error.js validation → README's `'error'` row |
| Cycle 134 | 191 cycles | remotable.js → README's `Far(iface, methods)` |
| Cycle 136 | 189 cycles | make-far.js → README's iface convention |
| Cycle 148 | 177 cycles | symbol.js Hilbert-Hotel → README's `passableSymbolForName()` |
| Cycle 150 | 175 cycles | typeGuards.js four pairs → README's Type Guards section |

**§six-citation-arc-closures-in-one-cycle** — new record. **§fourteen-citation-arc-closures-in-pivot-now**: 1, 2, 4, 165, 169, 175, 175, 177, 189, 191, 214, 238, 254, 255.

## Single most structurally interesting move

**§the-named-exhaustive-enumeration-via-table** — the pass-style table lists all 13 pass-styles with a fixed schema per row (style + category + description + example):

| Category | Count | Pass styles |
|---|---|---|
| Primitive | 7 | null + undefined + boolean + number + bigint + string + symbol |
| Pass-by-copy | 2 | copyArray + copyRecord |
| Pass-by-presence | 3 | remotable + error + promise |
| Extension | 1 | tagged |

**§the-named-closed-set-IS-named-security-foundation** — the capability-security argument of @endo rests on this set being **closed**, **knowable**, **complete**. The table format *commits to the enumeration in artifact form*; prose would obscure the exhaustiveness.

**§the-named-binary-distinction-with-internal-substructure** — a single binary axis (copy vs reference) with categorical substructure within each side. Contrasts with cycle 321's cartesian-product (locality × resolution) — that was *two* binary axes; this is one with internal categories.

## §the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere

(Line 88-90) — *"Far objects are remotable but don't validate their inputs. For defensive objects with automatic input validation, see [@endo/exo]"*. The README explicitly admits a limit and points to the sibling package. **Inverse of cycle 321's role-label discipline** (which named what packages DO; here the cited package names what it doesn't).

**§the-named-honesty-about-API-tradeoffs** now parameterized with **three named subtypes**:

| Subtype | Cycle | Specific phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" |

**§three-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325).

## Other notable observations

- §the-named-tentatively-modal ("Symbols must tentatively be created") — hedge word marks a rule as currently-in-place-but-possibly-subject-to-change
- §three-cycles-with-named-meta-discourse-in-pivot-READMEs (321 "what we call" + 323 "not for mutually-suspicious" + 325 "tentatively")
- §the-named-counterexample-discipline — show what's NOT covered (passable + NOT-passable not-frozen + NOT-passable cyclic) to disambiguate
- §the-named-makeTagged-IS-named-extension-point — 'tagged' is the only "Extension" row in the table; forwards-compatibility hatch
- §the-named-Hardened-JS-mentioned-pervasively-but-no-section — pass-style *defines* hardening for its scope; a Hardened-JS section would be circular; **§the-named-Hardened-JS-absent-as-section-by-foundational-status** (different reason than cycle 323's break)
- §the-named-Use-for-and-Pass-styles-pair-rows-discipline — each major category has "Use for:" + "Pass styles:" rows (when + what)
- §the-named-monorepo-docs-reference — `../../docs/message-passing.md` up two levels into shared monorepo docs/
- §the-named-Deep-Dives-IS-named-implementation-detail-section — four internal documents; contrasts with cycle 321's See Also which pointed to external sources

## Multi-cycle patterns extended

- §sixteen-cycles-with-named-pivot-domain-stay (310-325)
- §nine-named-packages-in-the-pivot-cluster (ninth: pass-style)
- §fourteen-citation-arc-closures-in-pivot-now (largest single-cycle increment: +6)
- §three-cycles-with-named-honesty-about-API-tradeoffs (three named subtypes)
- §three-cycles-with-named-meta-discourse-in-pivot-READMEs
- §two-cycles-with-named-role-label-before-package-name (321 + 325)
- §two-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325; different reasons)
- §two-cycles-with-named-four-predicate-assertion-pairs (150 + 325; doc/impl boundary)

## Tier-3 meta-patterns

- **§the-named-exhaustive-enumeration-via-table** — tables for exhaustive enumerations; the format commits to the schema
- **§the-named-closed-set-IS-named-security-foundation** — capability-security rests on closed, knowable, complete classifications
- **§the-named-cross-package-pointer-when-functionality-is-here-not-elsewhere** — admit what this package doesn't do; point to siblings
- **§the-named-honesty-about-API-tradeoffs** parameterized with three subtypes
- **§the-named-hedge-word-in-canonical-rule** — "tentatively", "what we call", "not for X"
- **§the-named-binary-distinction-with-internal-substructure** — one binary axis can sprout categorical substructure within each side
- **§the-named-Hardened-JS-absent-as-section-by-foundational-status** — when a package *defines* a discipline, a section about that discipline would be circular
- **§the-named-counterexample-discipline** — show what's NOT covered to disambiguate the rule's edges
- **§the-named-when-and-what-pair-rows** — Use-for + Pass-styles pair rows pattern for category sections

## Synthesis-target

Slot machine library **§`@game/pass-style/README.md`** — defines what data can be passed between game subsystems:

1. **Exhaustive table** of game-passable value types with schema per row.
2. **Closed-set commitment**: state the table is the *complete* enumeration.
3. **Four categories**: Primitive + Pass-by-copy + Pass-by-presence + Extension.
4. **Numbered requirements** for passability.
5. **Counterexamples after examples** to disambiguate.
6. **Use-for + Pass-styles pair rows** for major categories.
7. **Cross-package pointer** for functionality this package deliberately doesn't include.
8. **Hedge words** in canonical rules subject to change.
9. **Type Guards section** with canonical predicate-assertion pair imports.
10. **Integration with Endo Packages** with role labels.
11. **Deep Dives section** pointing to internal docs.
12. **Hardened-JS pervasive but no section** when the package *defines* hardening for its scope.

## Library state after cycle 325

- §library-reaches-837-sections from 373 source documents
- §one-hundred-and-fifty-eighth consecutive designs-chat alternation
- §sixteen-cycles-with-named-pivot-domain-stay
- §nine-named-packages-in-the-pivot-cluster
- §fourteen-citation-arc-closures-in-pivot-now (six closed in this cycle — new record)
- §three-cycles-with-named-honesty-about-API-tradeoffs (parameterized with three subtypes)

## Next cycle pacing

Cycle 326 is chat-lane next. Candidate moves:

- **@endo/pass-style/src/passStyleOf.js or symbol.js** — chat-lane; would be a third complementary-lens re-ingest (matching cycles 322 + 324 discipline); cycle 71 ingested passStyleOf already.
- **@endo/captp/src/captp.js** (1012 lines) — chat-lane; too large for one cycle in scope, would need to focus on a subset.
- **@endo/captp/src/index.js or types.js** — small chat-lane sources.
- **@endo/exo/src/exo-tools.js** (513 lines, already in library from cycle 118) — chat-lane; another complementary-lens re-ingest opportunity.
- **@endo/patterns/...** — would introduce a tenth package; cycle 325 cited @endo/patterns as the "Validation" role-label sibling.

@endo/patterns/...src (any reasonable source) is the most productive choice — introduces the tenth package, closes cycle 325's "Validation: patterns" role-label arc, and may close older arcs to cycles 102 + 104 + 120 (which all touched patterns files). Picking freely but tracking for future work.
