---
title: §Tier-1 borrowing for downstream synthesis
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

For the slot machine library §game-engine-protocol-helpers cluster:

- §game-helper-uniform-shape (sibling to PassStyleHelper) — every game-type-helper exports a `styleName` + `confirmCanBeValid` + `assertRestValid` triple.
- §game-helper-feature-detection-at-load — if a game-engine depends on a stage-3 platform feature (e.g., immutable-RNG-seed), §feature-detect-once-at-module-load + §null-prototype-as-game-disabled-signal + §always-deny-getter-when-game-feature-not-present.
- §game-helper-canonical-prototype-as-side-channel-defense — §a-game-token-validator-must-use-strict-prototype-equality, not instanceof, because §a-malicious-subclass-of-GameToken-could-carry-attached-credentials-out-of-the-capability-graph.
- §game-helper-three-line-validity-check — §prototype-identity + §immutability + §no-own-properties.
- §game-helper-captured-getter-pattern — §capture-the-canonical-game-state-getter-at-module-load + §call-it-via-Reflect.apply + §never-trust-the-candidate's-own-property-lookup. (a §game-cheat-could-shadow-.immutable-on-a-game-token-to-bypass-server-side-validation; the captured-getter defends against this.)
