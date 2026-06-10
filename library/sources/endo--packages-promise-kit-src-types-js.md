---
title: "@endo/promise-kit/src/types.js — PromiseKit, ERef, and the deprecated PromiseRecord alias"
source-slug: endo--packages-promise-kit-src-types-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
status: published
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
---

# @endo/promise-kit/src/types.js

A 25-line typedef-only file with three named typedefs: `PromiseKit<T>` (a reified Promise — three properties: resolve + reject + promise), `PromiseRecord<T>` (deprecated alias for PromiseKit), and `ERef<T> = T | PromiseLike<T>` (a reference of some kind for an object of type T — four named shapes in the prose: local T, local presence for remote T, promise for T, or thenable for T). The file ends with `export {};` to mark it as a module.

## Key design moves

- **§`export {};` typedef-only file pattern** (second instance: 249 + 256).
- **§PromiseKit as reified Promise** — three properties make the Promise constructor's implicit state explicit.
- **§resolve takes ERef not T** — the resolver accepts any of the four ERef shapes.
- **§ERef as four named shapes** — local T + local presence for remote T + promise for T + thenable for T.
- **§Four-named-shapes distinguished in prose**, not in a narrower type than `T | PromiseLike<T>`.
- **§Thenable defined explicitly** as *promise-like non-promise with a "then" method*.
- **§Deprecated typedef alias with named replacement** in JSDoc — pure type-erased rename discipline.
- **§Stack of three typedefs in one file** — general-input + canonical + deprecated-alias.
- **§`@template T` parameterization on all three typedefs**.

## Section files

- [§PromiseKit-as-reified-Promise + §ERef-as-four-named-shapes + §PromiseRecord-as-deprecated-alias + §second-typedef-only-file](../sections/endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file.md) — full 25-line module ingest.

## Ingest scope

Cycle 256 (chat-lane after cycle 255's designs-lane): full 25-line module ingest. Fourth-direct-ingest from `@endo/promise-kit/src/`. §First-explicit-observation of seven patterns: §PromiseKit-as-reified-Promise + §resolve-takes-ERef-not-T-as-canonical-PromiseKit-resolver-shape + §four-named-shapes-of-ERef + §thenable-defined-explicitly-as-promise-like-non-promise-with-then-method + §deprecated-typedef-alias-with-named-replacement-in-JSDoc + §stack-of-three-typedefs-in-one-file + §four-named-shapes-distinguished-in-prose-not-in-narrower-type.
