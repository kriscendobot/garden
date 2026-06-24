---
title: §Five-named-Endo-Idiom-points
source-slug: endo-but-for-bots--llm-designs-endoclaw-channel-bridges
section-id: named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-channel-bridges.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-channel-bridges.md
total-lines: 183
status: Not Started (Parent: endoclaw)
ingest-cycle: 232
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-channel-bridges--named-third-party-foundation-and-seven-platform-adapters-and-five-message-mappings-and-Bridge-is-a-confined-guest-and-SES-compatibility-with-three-fallback-paths-and-state-is-Endo-native
---

```
1. Bridge is a confined guest.
2. One bridge per agent per account.
3. Platform credentials are capabilities.
4. State is Endo-native.
```

§Four-named-disciplines (the design says §**Five** but lists four). §Borrowable-pattern: §the-Endo-Idiom-section-enumerates-the-design-principles-that-emerge-from-the-substrate-choice (consistent with cycle 222's §named-Endo-Idiom-section).

### §Bridge-is-a-confined-guest

> The bridge plugin runs in a SES-locked worker with only its granted capabilities. It cannot read other agents' inboxes, access the filesystem, or make network requests outside the platform API.

§Confinement-via-SES-locked-worker + §no-ambient-X enumeration (consistent with cycle 226's pattern).

### §One-bridge-per-agent-per-account

> This avoids a single bridge becoming a choke point with broad authority.

§Authority-concentration-prevented-by-architecture. §Borrowable-pattern: §one-instance-per-narrow-scope (per-agent-per-account) prevents §authority-aggregation.

### §Platform-credentials-are-capabilities

> The bridge receives an `OAuth` or `HttpClient` capability for the platform API — it never sees the raw bot token. Revocation of the platform credential is instant via `OAuthControl.revoke()`.

§The-bridge-never-sees-the-raw-token + §revocation-is-via-the-control-facet. §Sibling to cycle 226 endoclaw-cluster's §two-facet-control-pair canonical shape.

### §State-is-Endo-native

> Rather than using the `chat` SDK's Redis state adapter, the bridge can persist thread-to-inbox mappings in the Endo formula store via pet names. Each platform thread maps to an Endo message number.

§Reject-the-SDK's-state-adapter-and-use-the-native-formula-store. §Borrowable-pattern: §when-the-SDK-offers-a-state-adapter-but-the-host-has-its-own-storage, §use-the-host's-storage-not-the-SDK's. §The-bridge-keeps-state-in-the-substrate-that-matches-the-rest-of-the-system.

§Sibling to cycle 222 endoclaw-skill-registry's §no-new-abstractions discipline — both designs §use-the-existing-Endo-primitives-rather-than-introduce-foreign-ones. §Four-cycles-on-no-new-abstractions-discipline now (cycles 211 + 214 + 222 + 232).
