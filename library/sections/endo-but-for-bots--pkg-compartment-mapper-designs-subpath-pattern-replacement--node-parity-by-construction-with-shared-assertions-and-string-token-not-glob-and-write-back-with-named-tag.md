---
title: "endo-but-for-bots/packages/compartment-mapper/designs/subpath-pattern-replacement.md — Node.js subpath pattern parity via shared assertions + the `*`-IS-a-string-token-not-a-glob distinction + write-back with named `__createdBy` tag + parity-by-construction testing discipline"
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
---

# `compartment-mapper/designs/subpath-pattern-replacement.md` (full design)

A 271-line design specifying how `@endo/compartment-mapper` achieves **parity with Node.js subpath pattern replacement** for the `exports` and `imports` fields of `package.json`. Lives at `packages/compartment-mapper/designs/` — the **first design from a packages-level `designs/` directory** the library has ingested (the prior designs were all from the top-level `designs/`). §the-second-named-designs-tree-in-the-endo-but-for-bots-repository (first-explicit-observation): there IS a top-level `designs/` directory AND a per-package `packages/<name>/designs/` directory; the compartment-mapper's design directory is the second-named-pattern.

## The shape

7 sections:

1. Objective (one paragraph)
2. Node.js Semantics (with code blocks + Rules subsection)
3. Implementation (organized by source file)
4. Eschewed Alternatives (two named rejected shapes)
5. Testing (Parity Strategy + Unit Tests + Fixtures + Integration Tests)
6. (Implicit) Fixture: fixtures-export-patterns

**§the-no-metadata-table-shape reaffirmed**: no Created/Author/Status table at top; jumps straight to `## Objective`. **§two-cycles-with-no-metadata-table-shape** (285 OUTLINER_INTERACTION_PATTERNS + 287 subpath-pattern-replacement).

## §the-`Objective`-section-as-named-design-doc-section-name (first-explicit-observation)

The design uses `## Objective` as its opening section — distinct from the canonical `## Motivation` or `## What is the Problem Being Solved?`. **§the-Objective-naming IS more concrete than Motivation/Problem**: Objective names *what is to be achieved*; Motivation names *why it's wanted*; Problem names *what's currently broken*. Three named opening-section conventions; cycle 287 instantiates the third.

§three-named-opening-section-conventions: Objective + Motivation + What-is-the-Problem-Being-Solved (first-explicit-observation pair: 287 introduces Objective alongside the prior two canonical choices).

## §the-`*`-IS-a-string-replacement-token-not-a-glob (first-explicit-observation)

> "In Node.js, the `*` wildcard in subpath patterns is a **string replacement token**, not a glob. All instances of `*` on the right side of a pattern are replaced with the text matched by `*` on the left side. `*` **matches across `/` separators** — it is not limited to a single path segment."

**§the-named-pejorative-of-mistaken-mental-model**: the design pre-empts the reader's likely-incorrect mental model ("`*` is glob-like and bounded by path-separators") by *explicitly naming* the correct semantics with bolded emphasis. **§the-named-counter-intuitive-semantic IS the spec's load-bearing claim** — most readers would assume globbiness; the design names the deviation upfront.

§the-defensively-bolded-counter-claim: bold formatting on the *not-this* claim, not the *is-this* claim. **`not a glob`** + **`matches across `/` separators`**. The design's bold formatting reflects the asymmetry between *what readers will assume* and *what is true*.

## §the-seven-numbered-Rules-of-Node.js-subpath-semantics (first-explicit-observation)

The Rules subsection enumerates **seven numbered rules** for Node.js subpath pattern semantics:

1. **One `*` per side.** Having zero `*` on one side and one on the other is an error.
2. **`*` matches any substring**, including substrings that contain `/`.
3. **Exact entries take precedence** over pattern entries.
4. **Pattern specificity.** Longest matching prefix wins.
5. **Null targets** can exclude subpaths.
6. **Conditional patterns.** Pattern values can be condition objects.
7. **No `**` (globstar).** Globstar entries are silently ignored.

**§the-seven-named-rules-as-named-specification-shape** (first-explicit-observation): a design that **enumerates the upstream spec it's matching**, not just the design's response to it. The spec IS the contract; the implementation MUST honor each numbered rule.

§the-implementation-must-honor-the-numbered-upstream-spec IS distinct from §the-implementation-defines-its-own-rules — this design takes the former discipline.

## §the-Implementation-section-organized-by-source-file (first-explicit-observation)

The Implementation section's subsections are named by *source file path*:

- ### Pattern Matching (`src/pattern-replacement.js`)
- ### Inference from `package.json` (`src/infer-exports.js`)
- ### Compartment Map Representation
- ### Cross-Package Pattern Propagation (`src/node-modules.js`)
- ### Pattern Resolution at Link Time (`src/link.js`)
- ### Archiving

**§the-design-section-IS-named-after-the-source-file-it-describes** — file-path-named-section. This is sibling-pattern to documentation generators (Sphinx + JSDoc) but here applied to a design doc that *pre-describes* the implementation.

§the-file-path-IS-the-section-anchor as named navigability discipline.

## §the-O(1)-Map-vs-sorted-wildcard-array distinction (first-explicit-observation)

> "Exact entries (no `*`) are stored in a `Map` for O(1) lookup. Wildcard entries are decomposed into prefix/suffix pairs and sorted by prefix length descending."

**§the-named-two-data-structures-for-the-two-entry-kinds**: exact-vs-wildcard ARE structurally different concerns; the design uses a `Map` for one and a sorted array for the other. **§the-data-structure-IS-the-decision** — not "use both arrays" or "use both Maps", but pick the structure for each kind's access pattern.

§the-prefix-length-descending-sort-IS-the-named-specificity-ordering: this implements Rule #4 (pattern specificity = longest matching prefix wins) by sorting wildcard entries once at construction time.

## §the-null-target-IS-named-as-explicit-exclusion-shape (first-explicit-observation)

> "Null-target patterns (`to: null`) match normally but return `{ result: null }` to signal exclusion."

**§the-null-target-IS-a-named-three-state-result-shape** (first-explicit-observation): matching can return `{ result: <string> }` (matched + replaced), `{ result: null }` (matched + excluded), or no-match. **Three named outcomes from one matcher**, not two. The null-target wraps the second outcome in a structured marker rather than collapsing to "no match".

§the-explicit-exclusion-IS-distinct-from-implicit-no-match shape: a successful match with a null-result *prevents* further fallback to scope descriptors; an absent match *would have* fallen through.

## §the-3-priority-resolution-order in moduleMapHook (first-explicit-observation)

> "The `moduleMapHook` resolves specifiers in this order:
> 1. **Concrete module descriptors** (exact matches, highest priority).
> 2. **Patterns** (wildcard replacement).
> 3. **Scope descriptors** (package-scope resolution, lowest priority)."

**§the-three-priority-tiers-in-named-explicit-order** — a numbered priority list where each item's priority is named and the fall-through ordering IS the design contract. §the-fall-through-order-IS-the-named-resolution-policy.

§the-three-priority-tiers-pair-with-Rule-3 (Exact entries take precedence over pattern entries) — Rule 3 maps to **tier 1 over tier 2**; the implementation realizes the upstream spec's priority order via the moduleMapHook's resolution order.

## §the-write-back-pattern-with-named-`__createdBy` tag (first-explicit-observation)

> "When a pattern matches, the resolved path is written back into `moduleDescriptors` as a concrete entry (with `__createdBy: 'link-pattern'`). This write-back serves three purposes: caching subsequent imports of the same specifier, enabling policy enforcement (which checks `modules[specifier]`), and capturing the expansion for archival."

**§the-named-double-underscore-tag-as-provenance-marker** (first-explicit-observation): the `__createdBy: 'link-pattern'` field names *which subsystem* created the concrete entry. The double-underscore prefix IS the convention for internal-use marker fields.

**§the-three-named-purposes-of-the-write-back** (first-explicit-observation):

1. **Caching subsequent imports** of the same specifier.
2. **Enabling policy enforcement** (which checks `modules[specifier]`).
3. **Capturing the expansion for archival**.

§the-three-named-purposes-of-one-mechanism shape: a single design move (write-back) explicitly serves three named concerns. §the-design-names-the-purposes-not-just-the-mechanism.

§the-write-back-IS-the-name-for-this-pattern: the value is computed once on demand, then memoized as if it had been computed eagerly. Sibling-pattern to memoization but with explicit cross-system propagation.

## §the-`patterns: never` type-level enforcement (first-explicit-observation)

> "Patterns are removed from the compartment map during archiving. ... Type-level enforcement: `DigestedCompartmentDescriptor` has `patterns: never`."

**§the-`never`-type-as-named-compile-time-guarantee** (first-explicit-observation): the archived shape's type definition explicitly forbids the `patterns` field at the type level. **The TypeScript `never` type IS the named compile-time bouncer** that prevents the field from existing in the archived shape.

§the-type-system-enforces-the-archival-discipline: if someone later accidentally adds `patterns: somethingElse` to a `DigestedCompartmentDescriptor`, the compile fails. The type IS the spec.

## §the-Eschewed-Alternatives-section-with-named-rejected-shapes (first-explicit-observation)

The design names **two eschewed alternatives** with rejection rationale:

1. **Per-segment matching via prefix tree** — "An earlier approach split specifiers on `/` and matched `*` within a single path segment using a prefix tree. This did not match Node.js semantics, where `*` spans `/` boundaries. Prefix/suffix string matching on the full specifier is simpler and correct."
2. **Array fallback values** — "Node.js allows array values in exports as fallback lists... Pattern resolution in the compartment-mapper is a pure string operation with no filesystem access. Array fallbacks would require threading read powers through the pattern matcher and changing the `SubpathReplacer` signature. Node.js documentation discourages array fallbacks."

**§the-`Eschewed Alternatives`-section-name as named-design-doc-shape** (first-explicit-observation): a section that names what was *considered and rejected*. Compare cycle 283's §three-named-rejected-alternatives-with-reasons (loopback TCP + kernel credential check; cryptographic attestation) — but cycle 283 called these "alternatives... considered and rejected" inline; cycle 287 elevates them to a named section. **§two-cycles-with-named-rejected-alternatives-shape** (283 inline + 287 dedicated section).

§the-rejected-shapes-IS-named-design-content not just-omission. The design teaches the reader *what was tried first and why it was insufficient*.

## §the-pure-string-operation-discipline (first-explicit-observation)

> "Pattern resolution in the compartment-mapper is a pure string operation with no filesystem access."

**§the-pure-function-discipline-named-explicitly** (first-explicit-observation in this context): the design names a load-bearing property of the matcher: **no I/O**. This is the discipline that lets the matcher run inside SES, inside archives, and inside any context where filesystem access is unavailable. The rejection of array-fallback-values IS *because* it would require I/O — the pure-string property is the named constraint that drives the rejection.

§the-named-purity-discipline-determines-the-eschewed-alternative: when the purity property IS the design's named constraint, anything that violates it becomes ipso facto eschewed.

## §the-Parity-by-construction testing discipline (first-explicit-observation)

> "Each fixture is exercised by both Node.js and the Compartment Mapper. Assertions are shared via `_subpath-patterns-assertions.js`, so parity is verified by construction: if both test suites pass, the behaviors are equivalent."

**§the-parity-IS-verified-by-construction-not-by-comparison** (first-explicit-observation): rather than write tests that *compare* Node.js output to Compartment Mapper output, the design **shares the assertion file between the two test suites**. Each test suite passes iff its implementation matches the shared expected output. **If both pass, parity is structurally guaranteed**.

§the-shared-assertion-file-IS-the-parity-mechanism (`_subpath-patterns-assertions.js`). The single source of truth is the assertion file; the two implementations meet there. §the-leading-underscore-IS-the-private-helper-convention in JS test conventions.

§the-by-construction-IS-distinct-from-by-comparison: the latter says "compare A's output to B's output and assert equal"; the former says "both must satisfy the same assertion, and the assertion is the spec".

## §the-three-named-test-files for the three-test-mode pattern (first-explicit-observation)

Three test files for **three execution modes**:

- `subpath-patterns-node-parity.test.js` — runs fixtures under plain Node.js using dynamic `import()`.
- `subpath-patterns-node-condition.node-condition.test.js` — runs under `--conditions=blue-moon` via ses-ava.
- `subpath-patterns.test.js` — runs fixtures through the `scaffold()` harness.

**§the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker** (first-explicit-observation): the file suffix `.node-condition.test.js` is a *naming convention* that signals "this test needs the node-condition harness configuration". §the-file-extension-IS-the-test-mode-discriminator.

§three-named-execution-modes-for-the-same-fixture (plain Node + node-with-condition + scaffold-harness); §the-scaffold-harness-exercises-seven-named-functions (loadLocation + importLocation + makeArchive + parseArchive + writeArchive + loadArchive + importArchive).

## §the-named-fixture-package-shape (first-explicit-observation)

The primary fixture (`fixtures-package-imports-exports`) contains **five named packages** each representing a tested behavior:

- **`patterns-lib`** — basic exports with patterns + exact + null + specificity + #-imports.
- **`cond-patterns-lib`** — conditional pattern with `blue-moon` and `default` branches.
- **`multi-star-lib`** — multi-`*` pattern (silently ignored).
- **`multi-star-lib`** + **`globstar-lib`** — silently-ignored shapes.
- **`app`** — entry package consuming all the above.

**§the-named-package-IS-the-named-test-case** (first-explicit-observation): each package's *name* documents the behavior it tests. This is **§the-fixture-package-IS-self-documenting**.

§the-`cond-`-prefix-on-package-name IS the named conditional-pattern variant; §the-`multi-star-` and §the-`globstar-` prefixes name silently-rejected shapes. The prefix-naming-convention encodes the test taxonomy.

## §the-ten-row-Cases-Covered-table (first-explicit-observation)

| Case | Specifier | Resolves to |
|------|-----------|-------------|

A ten-row table maps **named test cases → named specifiers → expected resolutions**. The cases are named (Single-segment match + Cross-separator match + Exact over pattern + Imports pattern + Specificity + Null-target exclusion + Conditional (blue-moon) + Conditional (default) + Multi-star + Globstar). **§the-named-test-case-IS-the-named-borrowable-pattern**: each row of the table IS the unit of borrowable behavior.

§the-table-IS-the-named-test-taxonomy in the design — the reader can scan the cases column to know which behaviors are guaranteed.

## §the-import-patterns-NOT-propagated discipline (first-explicit-observation)

> "Import patterns (starting with `#`) are **not** propagated — they are internal to the declaring package."

**§the-imports-IS-package-private + the-exports-IS-cross-package** as named asymmetry. The `#`-prefix in `imports` IS the named *private*-marker; the absence of any prefix in `exports` IS the named *public*-marker.

§the-`#`-prefix-IS-the-named-internal-marker IS sibling-pattern to JS class private-field-`#` syntax. The two `#` conventions converge on the same idea: `#`-prefix = package-internal.

## Patterns from prior cycles, reaffirmed

- **§two-cycles-with-no-metadata-table-shape** (285 OUTLINER_INTERACTION_PATTERNS + 287 subpath-pattern-replacement).
- **§two-cycles-with-named-rejected-alternatives-shape** (283 inline three-rejected-alternatives + 287 Eschewed-Alternatives-section); §the-cluster-has-two-named-shapes-for-naming-rejected-alternatives.
- **§the-named-pejorative-of-mistaken-mental-model** — cycle 273's "ContentEditable is seductive but treacherous" + cycle 287's "string replacement token, not a glob"; §two-cycles-with-named-pejorative-of-mistaken-mental-model.

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-second-named-designs-tree-in-the-endo-but-for-bots-repository + §the-`Objective`-section-as-named-design-doc-section-name + §the-`*`-IS-a-string-replacement-token-not-a-glob + §the-named-counter-intuitive-semantic + §the-seven-numbered-Rules-of-Node.js-subpath-semantics + §the-Implementation-section-organized-by-source-file + §the-O(1)-Map-vs-sorted-wildcard-array distinction + §the-prefix-length-descending-sort-IS-the-named-specificity-ordering + §the-null-target-IS-a-named-three-state-result-shape + §the-3-priority-resolution-order-in-moduleMapHook + §the-write-back-pattern-with-named-`__createdBy`-tag + §the-three-named-purposes-of-the-write-back + §the-`patterns: never`-type-level-enforcement + §the-Eschewed-Alternatives-section + §the-pure-string-operation-discipline + §the-Parity-by-construction-testing-discipline + §the-shared-assertion-file-IS-the-parity-mechanism + §the-`.node-condition.test.js`-double-extension-as-named-test-mode-marker + §the-named-package-IS-the-named-test-case + §the-fixture-package-IS-self-documenting + §the-ten-row-Cases-Covered-table + §the-`#`-prefix-IS-the-named-internal-marker + §the-import-patterns-NOT-propagated-discipline — all twenty-three first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §three-named-opening-section-conventions (Objective + Motivation + Problem) + §the-defensively-bolded-counter-claim + §the-implementation-must-honor-the-numbered-upstream-spec + §the-file-path-IS-the-section-anchor + §the-named-double-underscore-tag-as-provenance-marker + §three-named-execution-modes-for-the-same-fixture + §the-by-construction-IS-distinct-from-by-comparison + §the-rejected-shapes-IS-named-design-content + §the-imports-IS-package-private + the-exports-IS-cross-package.
- **Tier 3 (multi-cycle pattern recognition)**: §two-cycles-with-no-metadata-table-shape (285 + 287) + §two-cycles-with-named-rejected-alternatives-shape (283 inline + 287 section) + §two-cycles-with-named-pejorative-of-mistaken-mental-model (273 + 287) + §the-cluster-has-two-named-designs-trees (top-level designs/ + per-package packages/<name>/designs/).

## Synthesis target

Slot machine library `@game/replay/designs/subpath-pattern-replacement.md` (located under `packages/replay/designs/` not `designs/`): Objective section (specify parity with a named upstream contract); Node.js Semantics with seven numbered Rules; Implementation section organized by source file (`src/pattern-replacement.js` + `src/infer-exports.js` + `src/link.js`); O(1) Map for exact + sorted array for wildcards; prefix-length-descending sort for specificity; null-target three-state result shape; 3-priority resolution order (concrete > patterns > scope); write-back with `__createdBy: 'link-pattern'` provenance tag serving three named purposes (caching + policy + archival); `patterns: never` type-level enforcement at archive time; Eschewed Alternatives section with two named rejected approaches; pure-string-operation discipline (no filesystem access); Parity-by-construction testing with shared assertion file (`_subpath-patterns-assertions.js`); three named test files for three execution modes (plain Node + node-with-condition + scaffold-harness); named-fixture packages where the name documents the behavior; ten-row Cases-Covered table; `#`-prefix as named internal marker.

## Single most structurally interesting move

**§the-Parity-by-construction testing discipline** with **§the-shared-assertion-file-IS-the-parity-mechanism** — rather than writing a comparison test ("does A == B?"), the design **shares the assertion file between the two test suites**. Each test suite passes iff its implementation matches the shared expected output. **If both pass, parity is structurally guaranteed by the shared file**, not by an explicit comparison step.

This is a profound testing-design move: it converts a *runtime correctness check* (does the implementation behave like the spec?) into a *structural invariant* (the spec IS the assertion file; both implementations meet there). The pattern generalizes far beyond subpath patterns: any time you have two implementations of the same spec, sharing the test fixtures + assertions makes parity a property of the file system, not the test runner.

§the-shared-assertion-file-as-named-cross-implementation-spec-anchor: the assertion file IS the spec; the implementations meet at the spec; parity emerges from co-location, not from comparison.
