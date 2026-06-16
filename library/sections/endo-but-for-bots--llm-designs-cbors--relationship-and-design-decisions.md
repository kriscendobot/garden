---
title: Relationship to existing packages + Test plan + Design decisions + Open questions
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
kind: index
section_count: 4
---

> Abstract: **Relationship**: three peer framing packages — `@endo/netstring` (`<digits>:<bytes>,`), `@endo/syrup-frame` (proposed; `<digits>:<bytes>`; will be renamed `@endo/syrups`), `@endo/cbors` (this design; CBOR byte-string head ± tag 24). None depend on the others. The daemon's `envelope.js` is the obvious migration target. **Test plan**: tests ported from `packages/netstring/test/netstring.test.js`, adapted to CBOR head grammar. Covers all short-frame round-trips with/without chunked/tagged, chunk-boundary edges, head-spanning-chunks (head length 1-9 bytes), concurrent writes, CBOR-specific rejections (non-major-2, indefinite-length, oversize-against-maxMessageLength, truncated head/payload, name-option error messages, canonical-shortest-form encoding verification). **Design decisions**: (1) byte-string framing only — no full-CBOR-codec dependency; (2) use tag 24 specifically (Encoded CBOR data item; defined for byte strings whose contents are themselves CBOR) so the wire is self-describing to a generic CBOR analyzer; (3) reject indefinite-length and non-byte-string forms outright — narrow decision surface, clear errors at wire boundary. **Open questions**: (1) top-level vs `framing/` subtree for layout? sibling consistency suggests top-level; revisit when family grows past 4-5 members; (2) `tagged: true` as default? initial recommendation is untagged to minimize peer surprise.

Sections:

- [Relationship to existing packages](endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions--relationship-to-existing-packages.md)
- [Test Plan](endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions--test-plan.md)
- [Design Decisions](endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions--design-decisions.md)
- [Open Questions](endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions--open-questions.md)

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
