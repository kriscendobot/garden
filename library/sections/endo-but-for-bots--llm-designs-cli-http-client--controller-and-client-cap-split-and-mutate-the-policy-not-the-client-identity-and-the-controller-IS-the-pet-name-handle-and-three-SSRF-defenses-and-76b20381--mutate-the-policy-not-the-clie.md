---
title: §Mutate-the-policy-not-the-client-identity
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

The §load-bearing-claim of the redesign: §the-controller-can-revise-the-policy-without-re-creating-the-formula-identity, so any existing guest grant continues to work after the host tightens or loosens the allowlist.

§Three-named-benefits over PR #144's one-shot create:

1. Tighten or loosen the allowlist after the fact, in response to the guest's actual usage.
2. Revoke the client without the daemon needing to re-derive its formula identifier from the original origin list.
3. Inspect the live policy without round-tripping through the client's surface.

§The-policy-IS-a-first-class-addressable-thing-not-a-transient-closure-variable. §When-a-capability's-policy-must-evolve-over-time, §make-the-policy-a-first-class-cap-with-its-own-pet-name + §the-policy-cap-survives-across-CLI-invocations.

§Sibling to cycle 236's daemon-make-archive §state-purge-as-acceptable-design-cost (both are §design-decisions-about-identity-stability — cycle 236 chose state-purge over migration; cycle 238 chose policy-mutation-without-identity-change). §Two-cycles-with-explicit-identity-stability-as-a-named-design-axis (cycles 236 + 238).
