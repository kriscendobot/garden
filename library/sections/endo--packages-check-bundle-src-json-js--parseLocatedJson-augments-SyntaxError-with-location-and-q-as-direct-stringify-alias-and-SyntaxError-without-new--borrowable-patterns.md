---
title: §Borrowable patterns
source-slug: endo--packages-check-bundle-src-json-js
source-url: https://github.com/endojs/endo/blob/master/packages/check-bundle/src/json.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/check-bundle/src/json.js
total-lines: 22
ingest-cycle: 247
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-check-bundle-src-json-js--parseLocatedJson-augments-SyntaxError-with-location-and-q-as-direct-stringify-alias-and-SyntaxError-without-new
---

**Tier-1 (highest borrowing value):**

- §The-single-function-file — isolate one error-augmentation utility in its own named file.
- §Augment-the-error-with-location-on-the-error-path-only — the cost is only paid when an error occurs.
- §Two-named-error-cases — expected error augmented with context + unexpected error rethrown undisguised.
- §The-`instanceof SyntaxError`-discrimination as named narrow scope.
- §Template-literal-error-coercion via `${error}` (with named stack-trace-loss trade-off).
- §Location-q-quoted-before-inclusion via JSON.stringify for safe special-character handling.

**Tier-2 (stylistic patterns):**

- §The-q-alias as direct property alias (`const q = JSON.stringify;`).
- §Comment-`For enquoting strings` explains why the letter q.
- §SyntaxError-without-`new` as stylistic shorter form.
- §The-resulting-error-loses-the-original's-stack-trace as named-trade-off.

**Tier-3 (file-shape patterns):**

- §Twenty-two-lines-as-a-complete-error-augmentation-utility.
- §The-function-name-encodes-the-discipline (`parseLocatedJson` names its augmentation).
- §The-parameter-`location`-IS-the-required-context (parameter name encodes the contract).
