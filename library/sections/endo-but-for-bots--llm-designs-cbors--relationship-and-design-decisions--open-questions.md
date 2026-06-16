---
title: Open Questions
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

1. **Should `@endo/cbors` (and other framing packages) live next to `@endo/netstring` or under a `framing/` subtree?** Today `@endo/netstring` lives at top level (`packages/netstring/`); the proposed `@endo/syrup-frame` follows the same pattern. Sibling consistency suggests `packages/cbors/` at top level, but a future `packages/framing/` subtree could be argued for once the family grows past four or five members. Layout question, not a design question.

2. **Should `tagged: true` be the default?** Tag-24 wrapping costs two bytes per frame and helps generic CBOR analyzers. If the dominant consumer is a peer that always carries CBOR, the default could be tagged; if many consumers carry opaque bytes, the default should remain untagged. Initial recommendation: `tagged: false` (untagged) — minimizes surprise for peers that don't expect a wrapping byte.

[rfc8949-tag24]: https://www.rfc-editor.org/rfc/rfc8949.html#section-3.4.5.1

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
