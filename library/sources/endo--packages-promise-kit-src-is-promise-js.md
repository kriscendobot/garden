---
title: "@endo/promise-kit/src/is-promise.js — Promise.resolve(x) === x as canonical promise detection"
source-slug: endo--packages-promise-kit-src-is-promise-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/is-promise.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/is-promise.js
total-lines: 12
status: published
ingest-cycle: 252
ingest-date: 2026-06-09
lane: chat
---

# @endo/promise-kit/src/is-promise.js

A 12-line file containing one function `isPromise(maybePromise)` that returns `Promise.resolve(maybePromise) === maybePromise` — the canonical way to detect a genuine Promise (not just a thenable) in JavaScript.

## Key design moves

- **§`Promise.resolve(x) === x` as canonical promise detection** — the ES spec guarantees `Promise.resolve` returns the same Promise unchanged for a Promise input + wraps everything else.
- **§The defense against malicious thenables** — distinguishes genuine Promises from any thenable that could carry attacker-controlled `.then`.
- **§Canonical tricks extracting a fact not available via the feature's stated purpose** (sibling to cycle 243's typed-array-aliasing for endianness detection).
- **§`unknown` plus type-predicate narrowing** as detection function type discipline.
- **§`@returns {x is T}` type-predicate narrowing** for runtime-checks bound to static-types.
- **§`harden(exportName)` immediately after declaration** as named SES discipline.
- **§`harden` imported from `@endo/harden` not from a global** — package-portability discipline.
- **§`maybe<TargetType>` as named parameter naming convention** for detection functions.
- **§Twelve lines as a complete promise-detection utility**.
- **§Single-export named the same as the purpose** — file name and export name converge.

## Section files

- [§Promise.resolve-equality + §type-predicate-narrowing + §twelve-lines](../sections/endo--packages-promise-kit-src-is-promise-js--Promise.resolve-equality-as-canonical-promise-detection-and-type-predicate-narrowing-and-twelve-lines.md) — full 12-line module ingest.

## Ingest scope

Cycle 252 (chat-lane, resuming after cycle 251's out-of-band papers ingest): full 12-line module ingest. §First-explicit-observation of seven patterns: §`Promise.resolve(x) === x`-as-canonical-promise-detection + §Promise.resolve-trick-as-defense-against-malicious-thenables + §canonical-tricks-extracting-a-fact-not-available-via-the-feature's-stated-purpose + §`unknown`-plus-type-predicate-narrowing-as-detection-function-type-discipline + §harden-immediately-after-export-as-named-SES-discipline + §`harden`-imported-from-`@endo/harden`-not-from-a-global + §`maybe<TargetType>`-as-named-parameter-naming-convention.
