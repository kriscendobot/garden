---
source: designs/ocapn-tcp-syrups-framing.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 4
status: current
notes: Design for the @endo/syrups package — comma-less Netstring framing that exploits grammar identity between Syrup byte-string and Netstring. Status: Not Started. Resolves both the OCapN TCP chunk-boundary bug (raw socket bytes fed directly to SyrupReader) and the redundancy of wrapping Syrup payloads in Netstring framing when Syrup's own byte-string header is structurally identical minus the comma. Recommends Option 2 (two transport identifiers: tcp-testing-only gets real netstring fix; tcp-syrups gets comma-less framing). Layered on ocapn-network-transport-separation.md (prerequisite) and relates to ocapn-tcp-for-test-extraction.md (sibling).
---

> Abstract: Design for `@endo/syrups` — a comma-less Netstring framing package named for parallelism with `@endo/cbors`. The key structural insight: Syrup byte-string grammar (`<digits>:<payload>`) is Netstring grammar minus the trailing comma (`<digits>:<payload>,`). Because OCapN messages are Syrup values, framing each in a Netstring duplicates the length-prefix machinery; dropping the comma collapses framing and serialization to a single length-prefixed-bytes abstraction. The design resolves the OCapN TCP netlayer's chunk-boundary bug (raw socket bytes fed to `SyrupReader` without framing, fragile on TCP segmentation) while proposing a companion `tcp-syrups` transport identifier (Option 2) that keeps `tcp-testing-only` netstring-compliant for Python test-suite interop. The package mirrors `@endo/netstring` module-for-module with one behavioral change: no trailing comma check in the reader; no `COMMA_BUFFER` write in the writer.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [tcp-framing-bug-and-syrup-grammar-unification](../sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--tcp-framing-bug-and-syrup-grammar-unification.md) | streams, ocapn | current |
| [endo-syrups-package-grammar-and-api](../sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--endo-syrups-package-grammar-and-api.md) | streams, ocapn | current |
| [netlayer-framing-placement-and-migration](../sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--netlayer-framing-placement-and-migration.md) | streams, ocapn | current |
| [ocapn-spec-compatibility-options](../sections/endo-but-for-bots--llm-designs-ocapn-tcp-syrups-framing--ocapn-spec-compatibility-options.md) | ocapn | current |

## Cross-references

- Prerequisite: `endo-but-for-bots--llm-designs-ocapn-network-transport-separation--*` (establishes `OcapnNetwork` interface and netlayer-owns-transport principle).
- Consolidation: `endo-but-for-bots--llm-designs-syrups--overview` (the syrups.md deprecation/rename note; this design is the concrete application of that rename).
- Cohort peer: `endo-but-for-bots--llm-designs-cbors--*` (the CBOR byte-string-delimited streaming framer; same plural-of-format naming convention).
- Daemon pattern: `endo-but-for-bots--packages-daemon-src-networks-tcp-netstring-js` (cycle 446; the model for netlayer-level framing this design extends to OCapN).
- Canonical decoder: `endo--packages-netstring-reader-js--two-state-iterator-with-zero-copy-fast-path-and-allocate-on-multi-chunk` (the `@endo/netstring` reader this design derives `@endo/syrups` from).
- Sibling: `designs/ocapn-tcp-for-test-extraction.md` (not yet ingested; the `op:start-session` handshake extraction that flows through the same syrups framer).

## Source

[designs/ocapn-tcp-syrups-framing.md](https://github.com/endojs/endo-but-for-bots/blob/a4978698b19bbea5fcb8049e5cb7944ac8f2485a/designs/ocapn-tcp-syrups-framing.md) at commit `a4978698` on branch `llm`.
