---
title: §Synthesis target — slot machine library
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

§The-constructor-validator-pair-pattern applies to the §game-engine-value-cluster:

- §**`makeGameTagged(tag, payload)`** — the constructor for tagged game values; mirrors `makeTagged`.
- §**`GameTaggedHelper`** — the validator (cycle 268 sibling).
- §**§the-asymmetric-enumerability** — the payload visible; the GAME_STYLE marker hidden.
- §**§Object.create with descriptor map** for atomic construction with symbol keys.
- §**§harden-before-assert** — `assertGameStyle(harden(payload))`.
- §**§two-level-harden** — result-harden + factory-harden.
- §**§five-step-factory-pattern** — validate-tag + harden-payload + assertGameStyle + construct + harden-result.
- §**§parameterized return type** — `GameCopyTagged<T,P>` narrows both the tag and the payload.
