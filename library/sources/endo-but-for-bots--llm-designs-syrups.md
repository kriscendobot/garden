---
source: designs/syrups.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 1
status: current
notes: Source itself carries `Status: Deprecated` — consolidated with PR 29's `@endo/syrup-frame` (now to be renamed `@endo/syrups`). The companion design `cbors.md` is unaffected; both packages carry `Uint8Array` at their boundaries and the value-codec sits above them.
---

> Abstract: A deprecation/consolidation note. The earlier "sequential Syrup message framing" design was wrong: it conceived of `@endo/syrups` as a value-stream layer above the byte-string framer; the corrected reading is that `@endo/syrups` and `@endo/syrup-frame` (PR 29) are the same package — both adapt a `Uint8Array` chunk stream into a `Uint8Array`-delimited message stream using length-prefixed Syrup byte-string framing (`<digits>:<payload>`). Recommendation: rename `@endo/syrup-frame` → `@endo/syrups` for naming consistency with `@endo/cbors`. The companion `cbors.md` design is unaffected.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/endo-but-for-bots--llm-designs-syrups--overview.md) | streams, marshal, ocapn | current |

## Cross-references

- Companion: `endo-but-for-bots--llm-designs-cbors--*` (the CBOR-shaped peer; carries `Uint8Array` at its boundaries).
- Predecessor: `endo--pkg-netstring-readme--*` (the netstring-grammar peer).
- Wire-format detail: `ocapn--draft-specifications-captp` and the OCapN Implementation Guide stage 1 (sturdyref + bootstrap on Syrup wire format).

## Source

[designs/syrups.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/syrups.md) at commit `a4978698` on branch `llm`.
