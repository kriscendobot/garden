---
title: §The controller and client cap split (canonical ocap two-facet pattern)
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

The host's `make` call returns a kit of two facets: a **controller cap** (policy-bearing authority — the allowlist, rate limit, byte cap, timeout, revoked bit) and a **client cap** (use-the-policy authority — `fetch` and inspection). §The-host-retains-the-controller + §the-host-grants-the-client-to-a-guest. §Disjoint-method-sets + §shared-private-state.

§Property: §A-guest-in-possession-of-the-client-cannot-widen-the-allowlist + §A-host-in-possession-of-the-controller-can-mutate-or-revoke-without-the-guest's-cooperation. §The-revocation-flips-a-shared-bit-and-every-client-method-rejects.

§Sibling to cycle 226's network-fetch six-design-cluster two-facet template; §sibling to cycle 234's endoclaw-oauth's the-agent-never-sees-the-token (where the credential is the analog of policy authority). §This-design-is-the-CLI-surface-for-the-network-fetch-two-facet-shape; §the-design-cluster-grows-by-renaming-and-restructuring-rather-than-by-adding-new-facets.
