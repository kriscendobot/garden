---
title: §The factory pattern — input-validation → harden-payload → assertPassable → construct → harden-result
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
parent: endo--packages-pass-style-src-makeTagged-js--the-constructor-counterpart-to-the-TaggedHelper-validator-and-the-constructor-validator-pair-and-asymmetric-enumerability-and-Object-create-with-descriptor-map
---

§Five-step-factory-pattern in `makeTagged`:

1. Validate the **tag** (type-check).
2. Harden the **payload** (the user-provided value).
3. Assert the **hardened payload IS passable** (recursive check via `assertPassable`).
4. Construct the tagged record via `Object.create` with descriptor map.
5. Harden the constructed record (the top-level wrap).

§First-explicit-observation in library: **§the-five-step-factory-pattern-as-named-discipline (validate-input + harden-input + assert-input-IS-passable + construct + harden-output) — §each-step-IS-a-named-defensive-checkpoint**.

§sibling-pattern to capability-systems' make-X factory conventions; §the-factory-pattern-IS-the-canonical-form-for-constructors-in-`@endo/*`.
