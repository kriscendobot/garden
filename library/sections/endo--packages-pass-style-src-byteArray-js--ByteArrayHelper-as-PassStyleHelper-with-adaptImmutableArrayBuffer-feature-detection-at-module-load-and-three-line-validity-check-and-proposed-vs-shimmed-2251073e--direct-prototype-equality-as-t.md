---
title: §Direct-prototype-equality as the side-channel defense
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
---

The §direct-prototype-equality-not-instanceof discipline (§prototype-identity check above) functions as a §side-channel-defense:

- §an-instanceof-check-walks-the-prototype-chain — a malicious actor could construct a subclass of ImmutableArrayBuffer with extra methods or shadowed properties; `instanceof ImmutableArrayBuffer` would return true, and the marshal layer would accept it as a canonical ByteArray.
- §strict-prototype-equality-rejects-anything-with-extra-chain-links — the canonical prototype is the only acceptable direct parent; any extra chain link signals tampering.
- §the-canonical-shape-IS-a-side-channel-defense — §when-the-marshal-protocol-promises-byte-array-passable-leaves-have-no-attached-data, §the-helper-must-enforce-it-structurally + §a-permissive-instanceof-would-violate-the-protocol-promise.

§This is the §sibling-pattern-to-cycle-244's-only-the-canonical-prototype-passes — the [TickResponse one-shot exo](endo-but-for-bots--llm-designs-endoclaw-timer--two-author-fields-and-heartbeat-vs-cron-split-and-start-to-start-timing-and-TickResponse-one-shot-exo-with-three-fates-and-missed-ticks-coalesced-not-replayed.md) used the same shape-only-one-canonical-prototype discipline.

§Two-cycles-with-canonical-prototype-as-side-channel-defense: cycle 244 (one-shot exo) + cycle 260 (PassStyleHelper byteArray).
