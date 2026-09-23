---
title: "@endo/pass-style/src/string.js — the passable-string utility module"
source-slug: endo--packages-pass-style-src-string-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/string.js
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/string.js`

An 83-line file that exports **three named primitives** (`isWellFormedString` + `assertWellFormedString` + `assertPassableString`). **Not** a PassStyleHelper concrete instance but a cluster utility module — the pass-style cluster has two named file shapes: helper-files (cycles 260 + 262 + 264 + 268) and utility-files (cycle 272's string-js).

## Key moves

- **§A cluster utility module that IS not a PassStyleHelper but carries three named predicates and asserters** — the cluster has two named file shapes, not one.
- **§Named criticism of a standard method as design justification** — *"Unfortunately, the standard built-in `String.prototype.isWellFormed` does a ToString on its input, causing it to judge non-strings to be well-formed strings if they coerce to a well-formed strings. This recapitulates the mistake in having the global `isNaN` coerce its inputs"*; §two-named-existing-API-mistakes-as-paired-design-justification.
- **§The conditional-binding via ternary on feature-detection bool** — `hasWellFormedStringMethod ? native : polyfill`; §two-named-shapes-of-feature-detection-at-module-load (260 adapter-factory + 272 conditional-binding).
- **§The unicode-iteration-trick as named polyfill strategy** — JS's string iterator produces a single surrogate character ONLY when it encounters an unpaired surrogate; iterating and checking the code point range against surrogates IS the well-formed check.
- **§Named Unicode iteration property as load-bearing polyfill discipline** — two paragraphs of Unicode explanation in the polyfill comment; surrogate range 0xd800-0xdfff named explicitly.
- **§Three named exports as predicate + asserter + extended-asserter** — the cluster's canonical discipline from cycle 150's typeGuards.js, extended here with a third asserter that uses a runtime flag.
- **§The runtime-toggle pattern** — `ONLY_WELL_FORMED_STRINGS_PASSABLE` env-option with named default + named allowed non-default values list (`['enabled']`).
- **§The three-stage migration plan named explicitly in prose doc-comment** — Stage 1 (disabled by default) + Stage 2 (change default to enabled) + Stage 3 (remove switch and simplify); the TODO IS anchored to the final stage.
- **§Named future-change warning in prose doc-comment** — *"Be prepared for these changes"*.
- **§The performance-uncertainty acknowledgment as named default rationale** — *"we do not yet know the performance impact"*; the conservative default IS justified by named unknown cost.

## Section files

- [§isWellFormedString + assertWellFormedString + assertPassableString + named criticism of String.prototype.isWellFormed + the unicode-iteration-trick as polyfill + three-stage migration plan](../sections/endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan.md) — full 83-line file in scope.

## Ingest scope

Cycle 272 (chat-lane after cycle 271's designs-lane endor-bus-tui). Full 83-line file ingested. **First-explicit-observations (eleven)**: a-cluster-utility-module-that-IS-not-a-PassStyleHelper-but-carries-three-named-predicates-and-asserters + named-criticism-of-a-standard-method-as-design-justification + two-named-existing-API-mistakes-as-paired-design-justification + the-conditional-binding-via-ternary-on-feature-detection-bool-as-alternative-to-the-adapter-factory-pattern + two-named-shapes-of-feature-detection-at-module-load + the-unicode-iteration-trick-as-named-polyfill-strategy + named-Unicode-iteration-property-as-load-bearing-polyfill-discipline + three-named-exports-as-predicate-asserter-extended-asserter + the-runtime-toggle-pattern-with-named-environment-option-and-allowed-non-default-values-list + the-three-stage-migration-plan-named-explicitly-in-prose-doc-comment + named-future-change-warning-in-prose-doc-comment.
