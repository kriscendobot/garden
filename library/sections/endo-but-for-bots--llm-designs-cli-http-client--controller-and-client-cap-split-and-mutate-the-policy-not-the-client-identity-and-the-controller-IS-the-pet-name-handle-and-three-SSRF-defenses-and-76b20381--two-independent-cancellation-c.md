---
title: §Two-independent-cancellation-channels
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

The design names §two-independent-cancellation-channels:

1. **§Host-side-cancellation**: the controller's `revoke()` — every in-flight request rejects.
2. **§Caller-side-cancellation**: the per-request `cancellation` promise — one specific in-flight request rejects.

§The-two-channels-are-independent-on-purpose: §the-host-can-revoke-without-coordinating-with-the-guest + §the-guest-can-abort-an-individual-slow-request-without-giving-up-the-whole-client. §When-a-cap-has-both-host-and-caller-cancellation, §design-them-as-two-independent-channels-not-one-channel-with-shared-state.
