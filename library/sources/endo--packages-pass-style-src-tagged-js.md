---
title: "@endo/pass-style/src/tagged.js — TaggedHelper fourth PassStyleHelper, extending the triplet to a quartet"
source-slug: endo--packages-pass-style-src-tagged-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/tagged.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/tagged.js
total-lines: 49
ingest-cycle: 268
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/tagged.js`

A 49-line file that exports `TaggedHelper` for the `'tagged'` pass-style. **Fourth concrete instance** of the `PassStyleHelper` shape — extends cycle 264's **triplet** to a **quartet** (260 byteArray + 262 copyArray + 264 copyRecord + 268 tagged). The four-instance picture refines the cluster pedagogy: each helper's phase-1 tactic reflects its substrate's discriminator.

## Key moves

- **§Fourth PassStyleHelper concrete instance** — §upgrades cycle 264's triplet to a quartet.
- **§Four different phase-1 tactics across the quartet** — `instanceof ArrayBuffer` (byteArray) + `Array.isArray` (copyArray) + `getPrototypeOf === Object.prototype` (copyRecord) + symbol-marker check `candidate[PASS_STYLE] === 'tagged'` via `confirmPassStyle` (tagged).
- **§The fourth helper imports four cluster helpers** — `confirmTagRecord` + `PASS_STYLE` + `confirmOwnDataDescriptor` + `confirmPassStyle` from `./passStyle-helpers.js`; the most of any PassStyleHelper; §the-cluster-helper-import-count-correlates-with-the-helper's-cluster-integration.
- **§`confirmPassStyle` as named cluster helper for symbol-marker validation** — first cycle to import this; takes the expected style name as an argument.
- **§The destructure-then-rest-then-count-zero pattern** — `getOwnPropertyDescriptors(candidate)` + destructure the three known keys (PASS_STYLE + Symbol.toStringTag + payload) + collect everything else into `...restDescs` + assert `restDescs.length === 0`.
- **§The side-channel defense takes four forms across the quartet** — count-zero (byteArray) + count-equal-to-len-plus-1 (copyArray) + per-key-and-per-value-rules (copyRecord) + destructure-then-rest-then-count-zero (tagged).
- **§Tagged records have three named own properties** — PASS_STYLE (symbol with value 'tagged') + Symbol.toStringTag (developer-visible string label) + payload (wrapped value).
- **§microsoft/TypeScript#1863 workaround citation** — typecasts via JSDoc `/** @type {unknown} */` for symbol-keyed destructuring; §three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations (146 + 264 + 268).
- **§The defense-in-depth comment continues the cycle 264 pattern** — *"confirmTagRecord already verified PASS_STYLE and Symbol.toStringTag own data properties"*; §four-cycles-with-doc-comment-documenting-defense-in-depth-redundancy (260 + 262 + 264 + 268).
- **§The payload-recursion uses `confirmOwnDataDescriptor` + `passStyleOfRecur`** — §three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value (262 indices + 264 each-property + 268 payload).

## Section files

- [§TaggedHelper fourth PassStyleHelper + quartet pedagogy + symbol-valued phase-1 check + four cluster-helper imports + destructure-then-rest-then-count-zero](../sections/endo--packages-pass-style-src-tagged-js--TaggedHelper-fourth-PassStyleHelper-quartet-pedagogy-and-symbol-valued-phase-1-check-and-four-cluster-helper-imports-and-destructure-then-rest-then-count-zero.md) — full 49-line file in scope.

## Ingest scope

Cycle 268 (chat-lane after cycle 267's century-milestone README ingest). Full 49-line file ingested. **First-explicit-observations (ten)**: four-cycles-with-PassStyleHelper-concrete-instance + the-quartet-extends-the-triplet-pedagogy + four-different-phase-1-tactics-across-the-quartet + the-fourth-helper-imports-four-cluster-helpers-the-most + confirmPassStyle-as-named-cluster-helper-for-symbol-marker-validation + the-destructure-then-rest-then-count-zero-pattern + the-side-channel-defense-takes-four-forms-across-the-quartet + tagged-records-have-three-named-own-properties + three-cycles-with-named-microsoft-TypeScript-issue-references-as-workaround-citations + three-cycles-with-confirmOwnDataDescriptor-followed-by-passStyleOfRecur-on-the-value.
