---
title: §Forward-compatibility-with-exo-stream via shim shape
source-slug: endo-but-for-bots--llm-designs-cli-http-client
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED
---

§ReadableBlob-IS-the-forward-compatible-shim. When `exo-stream` lands (the unfinished refactor), the body parameter and result migrate from `M.remotable('ReadableBlob')` to `M.remotable('ExoStream')`. §The-change-is-non-breaking-for-callers because `text()` / `json()` / `streamBase64()` are §the-same-on-ReadableBlob-and-on-the-future-ExoStream — §ReadableBlob-is-the-explicit-forward-compatible-shim. §Callers-that-already-treat-the-body-as-an-opaque-remotable-do-not-change-at-all.

§The-design's-contribution-is-to-choose-the-body-shape-so-that-the-future-lift-is-a-non-breaking-refactor + §the-implementation-surface-becomes-a-thin-identity-once-the-platform-exposes-the-native-shape. §When-an-unfinished-refactor-is-known, §pick-the-shim-shape-now-so-the-future-lift-is-non-breaking + §name-the-future-target-explicitly + §name-the-current-shape-as-shim-not-as-final.
