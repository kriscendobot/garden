---
title: "@endo/pass-style/src/copyArray.js — CopyArrayHelper second PassStyleHelper concrete instance"
source-slug: endo--packages-pass-style-src-copyArray-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/copyArray.js
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/copyArray.js`

A 38-line file that exports `CopyArrayHelper` for the `'copyArray'` pass-style. **Second concrete instance** of the `PassStyleHelper` shape (after cycle 260's `ByteArrayHelper`); the two stand side-by-side as the canonical pair the cluster uses to teach the pattern — byteArray needs feature-detection-at-load + adapter-factory because it depends on a stage-3 proposal; copyArray uses the universal `Array` intrinsic and needs no adapter.

## Key moves

- **§Second PassStyleHelper concrete instance** — sibling to cycle 260's byteArray; §the-pair-IS-the-pedagogy.
- **§Three-concerns-template omits the adapter-factory step** when the substrate is a universal intrinsic.
- **§Three-named-import-styles** in seven lines: default (`harden`), named (`Fail, X`), sibling-module (`confirmOwnDataDescriptor`); plus three platform-intrinsic destructurings.
- **§Destructuring with rename when source name is too generic** — `const { prototype: arrayPrototype } = Array;`.
- **§Phase-1 uses `Array.isArray`** — §the-canonical-realm-aware-array-test (not `instanceof Array`).
- **§Four-line validity check with four orthogonal rejection criteria** — prototype-identity + length-property-shape + each-index-shape-and-recursive-passable + index-property-count-check.
- **§Index-property-count check** — `ownKeys(candidate).length === len + 1` rejects sparse arrays AND arrays with extra non-index keys; §the-`+1`-IS-the-`length`-property.
- **§ownKeys-length-check with pass-style-specific arithmetic** — byteArray uses `=== 0`; copyArray uses `=== len + 1`; the arithmetic IS the pass-style's shape signature.
- **§passStyleOfRecur callback** — the helper's hook back into the marshal core's recursion; the helper validates this level + the core handles recursion via the callback.
- **§Uniform helper interface even when some helpers don't need all arguments** — byteArray ignores the recur callback; copyArray uses it.
- **§confirmOwnDataDescriptor** — shared validation helper imported by name from `./passStyle-helpers.js`; takes a per-call `enumerableRequired` argument because indices (required enumerable) and `length` (canonically non-enumerable) differ.
- **§Callback-based rejection API** — `Fail` is passed *into* `confirmOwnDataDescriptor` as the rejecter.
- **§The "ensured" comment as named invariant** — the comment documents the redundancy of a defense-in-depth check (`length` validation after `confirmCanBeValid` has already asserted it's an array).

## Section files

- [§CopyArrayHelper as PassStyleHelper second concrete instance + §index-property-count check + §passStyleOfRecur callback + §no feature-detection because Array is universal](../sections/endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal.md) — full 38-line file in scope.

## Ingest scope

Cycle 262 (chat-lane after cycle 261's designs-lane endoclaw-network-fetch). Full 38-line file ingested. **First-explicit-observations**: §the-PassStyleHelper-template-omits-the-adapter-factory-step-when-the-substrate-is-a-universal-intrinsic + §the-validity-check-arity-correlates-with-the-internal-structure-of-the-pass-style + §ownKeys-length-check-with-pass-style-specific-arithmetic + §passStyleOfRecur-as-named-callback-for-helper-to-core-recursion + §uniform-helper-interface-even-when-some-helpers-don't-need-all-arguments + §shared-validation-helper-imported-by-name + §confirmOwnDataDescriptor-as-named-cluster-helper-with-enumerability-as-per-call-parameter + §the-comment-documents-the-redundancy-of-a-defense-in-depth-check + §callback-based-rejection-API-where-the-rejecter-is-passed-into-a-shared-validation-helper + §destructuring-with-rename-when-source-name-is-too-generic.
