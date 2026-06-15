---
kind: result
role: liaison
dispatch-root: dispatches/liaison--a3fbae
cycle: 331
lane: designs
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 331: @endo/exo README.md (designs-lane; sixth honesty-about-API-tradeoffs subtype; cross-org pointer to Agoric; six citation arcs close)

Cycle 331 ingest: **@endo/exo README.md** (364 lines). Designs-lane after cycle 330's chat-lane. **Twenty-second consecutive non-garden source after the pivot** (cycles 310-331). **§twenty-two-cycles-with-named-pivot-domain-stay**. **Seventh package extends** (exo; previously in library via cycles 108 + 118 + 239 + 322).

Closes **six citation arcs**:

| Closes arc with | Arc length |
|---|---|
| Cycle 108 (exo-makers comment-fragment) | 223 cycles |
| Cycle 118 (exo-tools) | 213 cycles |
| Cycle 239 (get-interface.js) | 92 cycles |
| Cycle 322 (exo-makers full-source) | 9 cycles |
| Cycle 325 (pass-style README) | 6 cycles |
| Cycle 327 (patterns README) | 4 cycles |

**§thirty-five-citation-arc-closures-in-pivot-now** (29 + 6).

## Single most structurally interesting move

**§the-named-honesty-about-API-tradeoffs gains a sixth subtype** — line 327-346 ("Virtual and Durable Exos") points to **@agoric/vat-data** (a different organization) for production exo variants:

| Subtype | Cycle | Phrase / pointer-to |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" (sibling Endo package) |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| Functionality-not-supported-at-all | 329 | "The marshal-based alternatives do not" |
| **Functionality-in-different-org** | **331** | **"see @agoric/vat-data"** (different org/repository) |

**§six-cycles-with-named-honesty-about-API-tradeoffs** — the parameterized meta-pattern now spans six cycles with six distinct subtypes. The sixth subtype crosses the **organizational boundary** from Endo to Agoric — structurally different from cycle 325's "functionality-elsewhere" because Agoric is a different organization, not just a different package within the same family. **§the-named-cross-org-discipline-IS-named-organizational-boundary-crossing**.

**§the-named-positive-when-to-use-after-pointing-elsewhere** — after pointing to Agoric, the README names what heap-exos ARE good for (development/testing + low cardinality + temporary session state + non-critical services). **§the-named-scope-positive-naming-after-cross-pointer** — pair the "for X see other-package" pointer with "here's what THIS package IS good for".

## §the-named-same-code-with-and-without-discipline

The Why-Exo section (line 19-55) shows *identical* counter logic twice:

```js
// Far object - no validation
const counter1 = Far('Counter', { increment(n) { count += n; return count; } });

// Exo - automatic validation
const counter2 = makeExo('Counter', CounterI, { increment(n) { count += n; return count; } });
```

Only the wrapping factory differs (Far vs makeExo). **§two-cycles-with-named-side-by-side-comparison-discipline** (329 same-NaN-in-two-formats + 331 same-code-with-and-without). The discipline of *showing identical input/code in two contexts simultaneously* now recurs across two cycles in two distinct shapes (same-NaN-in-two-formats vs same-code-with-and-without-discipline).

## Other notable observations

- §the-named-Exo-IS-Far-plus-InterfaceGuard-combination (opening defines Exo as Far + InterfaceGuard)
- §the-named-three-patterns-for-creating-exos (makeExo + defineExoClass + defineExoClassKit — closes cycle 322 arc)
- §the-named-when-to-use-checklist-discipline (three "When to use:" bullet lists, one per pattern)
- §the-named-least-authority-as-named-discipline (closes cycle 322 amplify-capability arc)
- §the-named-canonical-three-facet-example (up + down + reader for least-authority illustration)
- §the-named-M.callWhen-three-or-four-step-semantics (closes cycle 327 patterns README callWhen-arc)
- §the-named-GET_INTERFACE_GUARD-as-meta-method (closes cycle 239 get-interface.js arc; §the-named-four-named-uses-of-interface-introspection)
- §the-named-cache-staleness-on-upgrade-warning (closes cycle 239's cache-staleness-caveat arc)
- §the-named-three-runtime-backing-tiers (heap + virtual + durable)
- §the-named-cross-package-pointer-names-the-specific-API-surface (@agoric/vat-data pointer names defineVirtualExoClass + defineDurableExoClass + prepareExoClass + prepareExoClassKit)
- §the-named-nine-section-README-shape (deep-feature-package shape)

## Multi-cycle patterns extended

- §twenty-two-cycles-with-named-pivot-domain-stay (310-331)
- §six-cycles-with-named-honesty-about-API-tradeoffs (six named subtypes — meta-pattern is structurally rich)
- §thirty-five-citation-arc-closures-in-pivot-now (added six in this cycle)
- §four-cycles-with-named-role-label-before-package-name (321 + 325 + 327 + 331)
- §four-cycles-with-named-monorepo-docs-reference (321 + 325 + 327 + 331)
- §four-cycles-with-named-Hardened-JS-discipline-streak-continues-broken (323 + 325 + 327 + 331)
- §two-cycles-with-named-Why-X-section-discipline (327 + 331)
- §two-cycles-with-named-side-by-side-comparison-discipline (329 + 331)
- §two-cycles-with-named-defensive-programming-as-named-discipline (327 + 331)

## Tier-3 meta-patterns

- **§the-named-honesty-about-API-tradeoffs** parameterized with six named subtypes — the meta-pattern is now structurally rich enough to serve as Tier-1 guidance for any package documentation
- **§the-named-cross-org-discipline-IS-named-organizational-boundary-crossing** — when a sibling-product in a different organization handles a related use case, name it explicitly
- **§the-named-positive-when-to-use-after-pointing-elsewhere** — pair the cross-pointer with positive scope-naming
- **§the-named-same-code-with-and-without-discipline** — show the same code in two contexts to illustrate the discipline's effect
- **§the-named-cross-package-pointer-names-the-specific-API-surface** — name the API exports, not just the package
- **§the-named-canonical-three-facet-example** (incrementer + decrementer + reader)
- **§the-named-numbered-step-semantics-discipline** (M.callWhen's four-step semantics)
- **§the-named-when-to-use-checklist-discipline** (bullet lists per pattern variant)

## Synthesis-target

Slot machine library **§`@game/exo/README.md`** — defensive game-entity factories:

1. Combine game-Far with game-InterfaceGuards opening
2. Three-pattern trio
3. Why-Game-Exo section with same-code-with-and-without comparison
4. When-to-use checklist per pattern
5. Canonical three-facet example (dealer + player + reader)
6. State access discipline
7. Async method guards with numbered-step semantics
8. Introspection meta-method with four-named-uses
9. Cache-staleness warning
10. Three-runtime-backing-tier if applicable
11. Cross-org pointer for production/cross-system variants
12. Positive when-to-use after cross-pointer
13. Cross-package pointer names specific API surface
14. Integration with role labels

## Library state after cycle 331

- §library-reaches-843-sections from 378 source documents
- §one-hundred-and-sixty-fourth consecutive designs-chat alternation
- §twenty-two-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §thirty-five-citation-arc-closures-in-pivot-now
- §six-cycles-with-named-honesty-about-API-tradeoffs (six named subtypes — Tier-3 meta-pattern with rich structure)

## Next cycle pacing

Cycle 332 is chat-lane next. Candidate moves:

- **@endo/exo/src/exo-tools.js** (513 lines) — chat-lane; **fourth** complementary-lens re-ingest matching cycles 322/324/330; cycle 118 ingested as comment-fragment; would extend the complementary-lens discipline to four applications
- **@endo/promise-kit source** — would introduce twelfth package
- **@endo/common source** — would introduce twelfth package
- **@endo/init source** — small; would close cycle 329's @endo/init citation arc

@endo/exo/src/exo-tools.js complementary-lens re-ingest is the most productive (fourth instance of the librarian discipline; pairs with cycle 331's exo README that introduced the trio; substantial 513-line file with rich material). Picking freely but tracking for future work.
