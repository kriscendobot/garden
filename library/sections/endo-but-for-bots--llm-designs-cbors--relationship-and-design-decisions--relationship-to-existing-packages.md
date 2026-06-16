---
title: Relationship to existing packages
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, repository-governance]
status: current
notes: The three-sibling-packages pattern (netstring / syrups / cbors) is principled — each framing grammar is its own package, no shared dependencies between siblings, head-parsing scaffolding deliberately duplicated. The daemon's `packages/daemon/src/envelope.js` is the obvious first consumer-migration target. The two open questions (top-level vs framing/ subtree placement; tagged-default) are maintainer-taste calls.
parent: endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions
---

| Package | Role |
|---|---|
| [`@endo/netstring`](../packages/netstring/) | Frames byte payloads as `<digits>:<bytes>,` |
| `@endo/syrup-frame` ([PR 29](./ocapn-tcp-syrup-framing.md), proposed, not yet landed) | Frames byte payloads as `<digits>:<bytes>` |
| `@endo/cbors` (this design) | Frames byte payloads as a CBOR byte-string head plus payload, optionally wrapped in CBOR tag 24 |
| `packages/daemon/src/envelope.js` | Inline CBOR codec for the engo bus envelope protocol; a candidate consumer of `@endo/cbors` for the framing layer |

The three are sibling packages. Each frames a sequence of byte payloads using a different head grammar. A consumer that wants the netstring grammar takes a dependency on `@endo/netstring` and gets nothing else; a consumer that wants the syrup-frame grammar (once it lands) would take `@endo/syrup-frame` only; a consumer that wants the CBOR-byte-string grammar takes `@endo/cbors` only. None of the three depends on any of the others, and adopting one does not entrain the rest.

The daemon's existing inline encoder is the obvious migration target for the framing layer: once `@endo/cbors` exists, the engo envelope protocol can drop its private head-bytes code and use the streaming reader and writer for that layer. The daemon would still encode and decode the *contents* of each frame with whatever CBOR codec it likes. That migration is out of scope here; this design only delivers the framing package.

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
