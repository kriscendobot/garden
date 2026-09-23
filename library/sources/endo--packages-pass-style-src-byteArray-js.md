---
title: "@endo/pass-style/src/byteArray.js — ByteArrayHelper concrete instance of the PassStyleHelper protocol"
source-slug: endo--packages-pass-style-src-byteArray-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/byteArray.js
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/byteArray.js`

A 68-line file that exports `ByteArrayHelper`, a concrete instance of the `PassStyleHelper` shape (see the [PassStyleHelper cluster sibling](endo--packages-pass-style-helpers-cluster.md) for the uniform shape). Implements the `'byteArray'` pass-style of `@endo/marshal` for **immutable ArrayBuffers**, which depends on the stage-3 `Immutable ArrayBuffer` ECMAScript proposal (`anArrayBuffer.sliceToImmutable()`).

## Key moves

- **§adaptImmutableArrayBuffer feature detection at module load** — immediately-invoked factory probes `ArrayBuffer.prototype.sliceToImmutable`; returns either real `{immutableArrayBufferPrototype, immutableGetter}` or `{null, () => false}` as **two shapes with the same keys**, so the call site does not branch on platform feature presence.
- **§proposed-vs-shimmed prototype discipline** — the doc comment names two runtime topologies (the proposal puts `.immutable` on `ArrayBuffer.prototype`; the shim puts it on a hidden intrinsic that inherits from `ArrayBuffer.prototype`); the code accepts either without branching by reading `getPrototypeOf(anImmutableArrayBuffer)`.
- **§three-line validity check** — `assertRestValid` enforces three orthogonal rejection criteria: prototype-identity (strict equality, not instanceof) + immutability (via captured getter applied via `Reflect.apply`) + no-own-properties.
- **§predicate-OR-fail idiom** — each line of the validity check uses `predicate || fail-call`; two error-API styles (`assert.fail(X\`...\`, TypeError)` for structural; `Fail\`...\`` for semantic).
- **§captured-getter pattern** — the `.immutable` getter is captured at module load via `getOwnPropertyDescriptor(immutableArrayBufferPrototype, 'immutable').get` and later applied via `Reflect.apply(immutableGetter, candidate, [])`; never trust the candidate's own property lookup.
- **§named-import isolation via destructuring** — `Object.{getPrototypeOf, getOwnPropertyDescriptor}` and `Reflect.{ownKeys, apply}` destructured into module-scope `const`s.

## Section files

- [§ByteArrayHelper as PassStyleHelper with adaptImmutableArrayBuffer feature-detection at module load and three-line validity check and proposed-vs-shimmed prototype discipline](../sections/endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline.md) — full 68-line file in scope.

## Ingest scope

Cycle 260 (chat-lane after cycle 259's designs-lane endoclaw-browser). Full 68-line file ingested. **First-explicit-observations**: §stage-3-proposal-feature-detection-at-module-load-with-null-prototype-as-impossibility-signal + §the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies + §three-line-validity-check-with-three-orthogonal-rejection-criteria + §three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call.
