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
