---
source: packages/notifier/README.md
source_repo: agoric/agoric-sdk
source_commit: eaef5bfd888e01d641e3e450df4809a165c68633
source_date: 2024-10-31
source_authors: [Unknown]
ingested: 2026-05-14
ingested_by: scholar
section_count: 6
status: current
notes: The PublishKit/NotifierKit/SubscriptionKit triad is agoric-sdk's canonical async-iteration infrastructure for capability-bearing distributed observers. PublishKit is the recommended choice; the other two are deprecated. Cross-cuts with eventual-send (the iteration plumbing uses E()), pass-style (iteration values must be Passable for distributed operation), patterns (consumer-side guards), and zoe (`StoredPublishKit` builds on this). The README uses # as a top-level heading at multiple points; the 6-section split treats each # block as a section.
---

> Abstract: PublishKit and the deprecated NotifierKit and SubscriptionKit provide async iteration with carefully-designed distributed-systems properties. Three lossiness modes — fully lossless (subscription, every value seen), forward-lossless (suffix-starting-at-current, gap-free from some starting point), and lossy (sampling subsets, may drop intermediate values). PublishKit is the recommended choice as it supports both forward-lossless and lossy on the same publisher. Six sections: PublishKit and Related Types (frame), Distributed Asynchronous Iteration (formal semantics), Type Differences (the three kits + their interfaces + lossiness definitions), Example (worked Paula/Alice/Bob walkthrough), Distributed Operation (the multicast properties + Passable requirement + `getSharable*Internals` adapter pattern), Summary.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [publishkit-and-related-types](../sections/agoric-sdk--pkg-notifier-readme--publishkit-and-related-types.md) | eventual-send, capability-security | current |
| [distributed-asynchronous-iteration](../sections/agoric-sdk--pkg-notifier-readme--distributed-asynchronous-iteration.md) | eventual-send | current |
| [type-differences](../sections/agoric-sdk--pkg-notifier-readme--type-differences.md) | eventual-send, capability-security | current |
| [example](../sections/agoric-sdk--pkg-notifier-readme--example.md) | eventual-send | current |
| [distributed-operation](../sections/agoric-sdk--pkg-notifier-readme--distributed-operation.md) | eventual-send, pass-style, capability-security | current |
| [summary](../sections/agoric-sdk--pkg-notifier-readme--summary.md) | eventual-send | current |

## Cross-references

- The "iteration values must be Passable" rule (Distributed Operation) cross-cuts with `endo--pkg-pass-style-readme--*`.
- `agoric-sdk--pkg-zoe-readme--reading-data-off-chain` describes `StoredPublishKit`, which builds on PublishKit.
- The "consumers can't interfere with producer or each other" property is the same capability-bearing-observer pattern from `endo--docs-message-passing--digital-purse-example`.

## Source

[packages/notifier/README.md](https://github.com/Agoric/agoric-sdk/blob/eaef5bfd888e01d641e3e450df4809a165c68633/packages/notifier/README.md) at commit `eaef5bfd`.
