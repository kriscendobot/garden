---
title: "@endo/pass-style/src/makeTagged.js — the constructor counterpart to the TaggedHelper validator + the constructor-validator pair + asymmetric enumerability + Object.create with descriptor map"
source-slug: endo--packages-pass-style-src-makeTagged-js
section-slug: the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/makeTagged.js
source-repo: endojs/endo
source-path: packages/pass-style/src/makeTagged.js
source-author: Endo project (collective)
total-lines: 31
ingest-cycle: 270
ingest-date: 2026-06-10
lane: chat
kind: index
section_count: 15
---

Sections:

- [`@endo/pass-style/src/makeTagged.js` — the constructor counterpart to the TaggedHelper validator](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--endo-pass-style-src-maketagged.md)
- [§The constructor structure — five operations in eleven lines](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--the-constructor-structure-five.md)
- [§Asymmetric enumerability — payload is enumerable, marker fields are not](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--asymmetric-enumerability-paylo.md)
- [§`harden(payload)` BEFORE `assertPassable` — the harden-before-assert discipline](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--harden-payload-before-assertpa.md)
- [§Two-level harden — harden(result) plus harden(makeTagged)](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--two-level-harden-harden-result.md)
- [§`Object.create(objectPrototype, descriptors)` — the canonical descriptor-map construction](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--object-create-objectprototype.md)
- [§The factory pattern — input-validation → harden-payload → assertPassable → construct → harden-result](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--the-factory-pattern-input-vali.md)
- [§The generic typedef encodes both tag and payload types](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--the-generic-typedef-encodes-bo.md)
- [§Cycle 270 first-explicit-observations roundup (eleven)](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--cycle-270-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 270](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--tier-1-borrowing.md)
- [§Tier-2 borrowing](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--tier-2-borrowing.md)
- [§Tier-3 borrowing](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map--pattern-summary-tag-prefixed.md)
