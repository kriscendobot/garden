---
title: "@endo/check-bundle/src/json.js — parseLocatedJson wraps JSON.parse with file-location context"
source-slug: endo--packages-check-bundle-src-json-js
url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
status: published
ingest-cycle: 247
ingest-date: 2026-06-08
re-ingest-cycle: 398
re-ingest-date: 2026-06-18
section_count: 2
lane: chat
---

# @endo/check-bundle/src/json.js

A 22-line file that exports `parseLocatedJson(source, location)` — wraps `JSON.parse` and augments any `SyntaxError` with the file location.

## Key design moves

- **§The single-function file** — isolate one error-augmentation utility in its own named file.
- **§Augment the error with location on the error-path only** — cost is only paid on failure.
- **§Two named error cases** — SyntaxError augmented with context + non-SyntaxError rethrown undisguised.
- **§The `instanceof SyntaxError` discrimination** as named narrow scope.
- **§Template-literal error coercion** via `${error}` (with named stack-trace-loss trade-off).
- **§Location q-quoted before inclusion** via JSON.stringify for safe special-character handling.
- **§The q alias as direct property alias** (`const q = JSON.stringify;`) — third stylistic variant in library.
- **§Comment `For enquoting strings`** explains why the letter q.
- **§SyntaxError without `new`** as stylistic shorter form — Error subclass constructors are callable as functions since ES6.
- **§The function name encodes the discipline** (`parseLocatedJson` names its augmentation).
- **§The parameter `location` IS the required context** (parameter name encodes the contract).

## Section files

- [§parseLocatedJson augments SyntaxError with location + §q as direct stringify alias + §SyntaxError without new](../sections/endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new.md) — full 22-line module ingest.

## Ingest scope

Cycle 247 (chat-lane): full 22-line module ingest. §First-explicit-observation of four patterns: §augment-the-error-with-location-on-the-error-path-only + §two-named-error-cases (augmented + rethrown) + §Error-constructor-without-`new` + §template-literal-error-coercion-loses-stack-trace.

## Re-ingest scope (cycle 398)

Cycle 398 chat-lane complementary-lens re-ingest paired to cycle 397 designs-lane @endo/check-bundle README. Forty-sixth AUTHORED conformant single-body section doc in post-refactor era. Eighty-eighth consecutive non-garden source after the pivot (310-398). §eighty-eight-cycles-with-named-pivot-domain-stay.

The cycle 247 ingest named eleven first-explicit-observations of the file's structure. Cycle 398's lens adds CROSS-REFERENCE framings that locate the file's patterns within the broader cluster.

**Single most structurally interesting move at this lens**: §the-named-q-as-recurring-quoting-alias-different-implementations — cycle 247 named "the q alias as direct property alias (`const q = JSON.stringify;`)"; cycle 394's @endo/daemon pet-name.js IMPORTS q from `@endo/errors`. Both files use the same letter `q` for safe-error-message quoting, but with different implementations. The same convention emerges in two places with different mechanisms. §the-named-cross-package-q-convention-with-divergent-implementations as tier-3 meta-pattern; the discipline of using `q` for error-message quoting is shared across packages even when the implementations differ.

§The-named-zero-imports-as-discipline — the file has zero `import` statements. Line 4's `const q = JSON.stringify` is a LOCAL alias, not an import. Sibling shape to cycle 372's @endo/compartment-mapper extension.js (also zero imports — pure string ops on the location). §the-named-zero-import-utility-as-recurring-shape as tier-3 meta-pattern; pure utilities that need no @endo/* dependencies achieve the cluster's caller-supplies-IO-powers discipline (cycle 371 framing) by needing no powers at all.

§The-named-twenty-two-line-utility-as-recurring-substantial-package-decomposition — sibling shape across cycle 372 extension.js (22 lines), cycle 370 daemon deferred-tasks.js (23 lines), cycle 376 module-source hidden.js (20 lines), cycle 386 chat message-parse.js (30 lines), cycle 394 daemon pet-name.js (126 lines, larger), cycle 398 check-bundle json.js (22 lines). The substantial-package-decomposes-into-tiny-utilities pattern recurs across the cluster.

§The-named-error-decoration-at-boundary-with-location — refines cycle 247's "§Augment the error with location on the error-path only" with the specific structural observation: the boundary is the JSON.parse call site; the decoration is location; the discipline pattern is wrap-call-add-context. §the-named-wrap-call-add-context-on-error-path as tier-3 meta-pattern.

Cycle 398 closes seven citation arcs: cycle 397 (1, adjacent forward; check-bundle README → its parseLocatedJson source) + cycle 394 (3, sibling q-usage with divergent implementation; pet-name.js imports q from @endo/errors while json.js defines q locally as JSON.stringify) + cycle 372 (4, zero-import sibling shape; extension.js is the parallel small-pure-utility) + cycle 322 (73, @endo/errors q discipline; this file declines to use it) + cycle 326 (73, pure-naming-as-discipline) + cycle 370 (4, sibling small-utility-from-substantial-package) + cycle 376 (5, sibling small module shape). Pushes citation-arc-closures-in-pivot to FOUR-HUNDRED-SIXTY-FIVE (458 + 7 net new).
