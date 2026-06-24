---
title: "@endo/pass-style/src/makeTagged.js — the constructor counterpart to the TaggedHelper validator"
source-slug: endo--packages-pass-style-src-makeTagged-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/makeTagged.js
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
---

# `@endo/pass-style/src/makeTagged.js`

A 31-line file that exports `makeTagged(tag, payload)`, the **constructor** for tagged records. **Closes the loop with cycle 268's `TaggedHelper`** — cycle 268 ingested the validator; cycle 270 ingests the constructor. The two stand side by side as a constructor-validator pair.

## Key moves

- **§The constructor-validator pair** — `makeTagged` builds the three named own properties (PASS_STYLE + Symbol.toStringTag + payload); `TaggedHelper` checks them; §two-cycles-with-constructor-validator-loops-closed (268 + 270).
- **§Five operations in a thirty-line constructor** — validate tag + harden payload + assertPassable + construct via Object.create + harden result.
- **§Asymmetric enumerability encoded by omission** — `{ value: X }` defaults to non-enumerable; only `payload` has explicit `enumerable: true`; §the-defaults-IS-the-discipline-and-the-deviation-IS-the-feature.
- **§The constructor and validator share the descriptor shape** — `Object.create` with descriptor map on construction; `Object.getOwnPropertyDescriptors` on validation; §the-two-functions-IS-protocol-duals.
- **§The harden-before-assert discipline** — `assertPassable(harden(payload))`; hardening IS part of the passability protocol; §two-cycles-with-the-harden-before-assert-discipline (134 + 270).
- **§Two-level harden** — result-harden (return value) + factory-harden (`harden(makeTagged)` after export).
- **§The factory-harden-after-export idiom** — `export const makeTagged = (...) => {...};` then `harden(makeTagged);`; the recursive `harden` call needs the named binding.
- **§Object.create with descriptor map** — three named advantages: atomicity + symbol-key support + explicit prototype.
- **§The five-step factory pattern** — validate-input + harden-input + assert-input-IS-passable + construct + harden-output.
- **§Two template parameters with `Passable` as constraint** — `<T extends string, P extends Passable>` parameterizes the tag's literal type and the payload's passable type.
- **§`CopyTagged<T,P>` as parameterized return type** — narrows both the tag and the payload.

## Section files

- [§The constructor counterpart to the TaggedHelper validator + §the constructor-validator pair + §asymmetric enumerability + §Object.create with descriptor map](../sections/endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map.md) — full 31-line file in scope.

## Ingest scope

Cycle 270 (chat-lane after cycle 269's designs-lane endor-tui). Full 31-line file ingested. **First-explicit-observations (eleven)**: the-constructor-and-validator-form-a-pair-where-the-validator-checks-what-the-constructor-builds + five-operations-in-a-thirty-line-constructor + the-asymmetric-enumerability-IS-encoded-by-omission + the-constructor-and-validator-share-the-descriptor-shape + the-harden-before-assert-discipline + two-level-harden-discipline + the-factory-harden-after-export-idiom + three-named-advantages-of-`Object.create`-with-descriptor-map + the-five-step-factory-pattern + two-template-parameters-with-`Passable`-as-constraint + `CopyTagged<T,P>`-as-parameterized-return-type.
