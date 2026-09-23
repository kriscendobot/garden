---
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: First library section files with source_authors including a bot identity (Kriscendo Bot). The design is the precise CBOR-shaped sibling of @endo/netstring and @endo/syrup-frame (per `syrups.md`, the latter is to be renamed @endo/syrups). All three carry Uint8Array at both boundaries; the value-codec sits above. Cross-cuts with streams (the async-iterator interface) and marshal (a consumer that wants structured CBOR sits above this layer).
---

> Abstract: Design for `@endo/cbors` — a small framing package for sequential length-prefixed byte strings using CBOR's byte-string head grammar (RFC 8949 § major type 2, optionally wrapped in tag 24). **Deliberately NOT a CBOR codec** — it only reads/writes the head, leaving the payload bytes opaque. The precise CBOR-shaped sibling of `@endo/netstring` and the proposed `@endo/syrup-frame` (to be renamed `@endo/syrups`). Five sections: overview + naming, design (scope + API shape), wire format with concrete hex examples for both plain and tag-24-wrapped streams, reader/writer behavior with chunked + tagged options + harden discipline + dependencies, relationship to existing packages + test plan + design decisions + open questions.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-naming](../sections/endo-but-for-bots--llm-designs-cbors--overview-and-naming.md) | streams, marshal | current |
| [design-scope-and-api](../sections/endo-but-for-bots--llm-designs-cbors--design-scope-and-api.md) | streams, marshal | current |
| [wire-format](../sections/endo-but-for-bots--llm-designs-cbors--wire-format.md) | streams, marshal | current |
| [reader-writer-behavior](../sections/endo-but-for-bots--llm-designs-cbors--reader-writer-behavior.md) | streams, hardened-javascript | current |
| [relationship-and-design-decisions](../sections/endo-but-for-bots--llm-designs-cbors--relationship-and-design-decisions.md) | streams, repository-governance | current |

## Cross-references

- Sibling design: `endo-but-for-bots--llm-designs-syrups--overview` (the Syrup-grammar peer; same shape).
- Predecessor: `endo--pkg-netstring-readme--*` (the netstring-grammar peer; this design ports its tests).
- Consumer migration target: `packages/daemon/src/envelope.js` (currently has inline CBOR head-bytes code; would adopt `@endo/cbors` for framing).
- Stream-interface basis: `endo--pkg-stream-readme--*`.

## Source

[designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
