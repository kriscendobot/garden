---
title: §Synthesis target — slot machine library
source-slug: endo--packages-pass-style-src-copyRecord-js
section-slug: CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyRecord.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyRecord.js
source-author: Endo project (collective)
total-lines: 70
ingest-cycle: 264
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyRecord-js--CopyRecordHelper-third-PassStyleHelper-and-two-named-local-helper-functions-and-canBeMethod-guard-against-implicit-Remotable-and-work-distribution-between-phases-varies
---

§The-triplet-of-leaf-pass-styles instantiates for game-engine as a §triplet-of-leaf-game-value-helpers:

- §**GameTokenHelper** (cycle 260 sibling) — single-byte token, no internal structure, no own keys allowed.
- §**GameRollHelper** (cycle 262 sibling) — ordered sequence (length + indices), `len + 1` own keys required.
- §**GameRecordHelper** (cycle 264 sibling) — open key-value structure, string keys only, no method-shaped values (else the value is a Remotable game-rule-callback).

§The-triplet-IS-the-pedagogy — §the-implementer-reads-all-three-side-by-side-and-sees-three-points-of-variation-in-the-cluster-pattern; §three-points-define-the-pattern-better-than-two; §the-triplet-IS-the-canonical-cluster-shape.

§Each-game-helper-extracts-its-pass-style-specific-checks-into-named-local-functions: GameTokenHelper has confirmTokenPrototype + confirmTokenImmutable; GameRollHelper has confirmRollLength + confirmRollIndices; GameRecordHelper has confirmRecordPrototype + confirmRecordKeyString + confirmRecordValueNotCallback.

§The-cross-cluster-disambiguation-discipline — §when-a-GameRecord-might-be-confused-with-a-GameRuleCallback, §GameRecordHelper-imports-canBeCallback-from-`./game-rule.js`-to-reject-the-overlap.
