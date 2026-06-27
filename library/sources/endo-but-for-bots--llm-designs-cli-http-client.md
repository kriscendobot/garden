---
title: "cli-http-client — Controller + client cap split for endo http subcommand tree"
source-slug: endo-but-for-bots--llm-designs-cli-http-client
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-http-client.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-http-client.md
total-lines: 644
status: Proposed (2026-05-09; updated 2026-05-10)
ingest-cycle: 238
ingest-date: 2026-06-08
lane: designs
---

# cli-http-client.md

A 644-line **Proposed** design that revises PR #144's `HttpClient` shape into a controller + client cap pair under a single `endo http` subcommand tree. §Source-field-cites-the-PR-review-id (4256844646 `CHANGES_REQUESTED`). §Supersedes-in-part: [`endoclaw-network-fetch`](endo-but-for-bots--llm-designs-endoclaw-network-fetch.md) — §partial-supersession-as-named-relationship.

## Key design moves

- **§Design-revision-after-CHANGES_REQUESTED** as named provenance — twenty-ninth honest-design-evolution-record family member; thirteenth-different-shape in 2026-06 cluster.
- **§The controller and client cap split** — canonical ocap two-facet pattern; disjoint method sets + shared private state.
- **§Mutate-the-policy-not-the-client-identity** — three named benefits over PR #144's one-shot create.
- **§The-controller-IS-the-pet-name-handle** that survives across CLI invocations.
- **§`endo http` subcommand tree** replaces single verb (room to grow).
- **§Method-placement-table** as cap-discipline statement.
- **§The-add-and-remove-convenience-methods** prevent read-mutate-write races.
- **§Cancellation-promise-as-platform-neutral-interface** + §AbortController-mapped-one-way-at-the-platform-boundary.
- **§Two-independent-cancellation-channels** (host-side revoke + caller-side cancellation).
- **§Three-named-SSRF-vectors-and-three-named-defenses** (redirect-following + slow-loris + response-flooding).
- **§Local-idioms-cited-table** as no-new-abstractions evidence (six-cycles-on-no-new-abstractions now).
- **§ReadableBlob-IS-the-forward-compatible-shim** — pick the shim shape now so the future lift is non-breaking.
- **§Alternatives-considered-with-three-fates** (rejected + rejected + deferred); each rejection names the specific failure mode.
- **§Identifier-conventions-TBD-pending-namer-dispatch** — placeholders called out where they appear.
- **§Test-plan-named-in-the-design-doc** — eight named scenarios.
- **§Dependencies-table-with-Relationship-column** (four-cycles).
- **§Prompt-section-captures-the-originating-review-comment** — fifth Prompt-section-instance.

## Section files

- [§controller-and-client-cap-split + §mutate-the-policy-not-the-client-identity + §the-controller-IS-the-pet-name-handle + §three-SSRF-defenses + §design-revision-after-CHANGES_REQUESTED](../sections/endo-but-for-bots--llm-designs-cli-http-client--controller-and-client-cap-split-and-mutate-the-policy-not-the-client-identity-and-the-controller-IS-the-pet-name-handle-and-three-SSRF-defenses-and-design-revision-after-CHANGES_REQUESTED.md) — full 644-line design ingest.

## Ingest scope

Cycle 238 (designs-lane): full 644-line ingest. §First-explicit-observation of three new design-doc structural shapes: §design-revision-after-CHANGES_REQUESTED with cited PR review id + §Supersedes-in-part as metadata field + §Alternatives-Considered-section-with-named-fates + §forward-compatible-shim-with-named-future-target.
