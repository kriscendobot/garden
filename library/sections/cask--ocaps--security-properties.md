---
title: Security Properties
source: doc/design/ocaps.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [capability-security]
status: current
---

Abstract: The four object-capability security properties the token model delivers. **Unforgeability**: capabilities are 32-byte random values (256 bits of entropy) and cannot be guessed or forged. **Attenuation**: capabilities attenuate naturally, with `write_cap > observe_cap > read_cap` in authority, and any derived capability has equal-or-lesser authority. **Revocability**: revoke by updating the cell's facet mapping so the old capability hash no longer appears in the caskmap and lookups fail. **Confinement**: a capability grants access only to its specific facet of its specific cell — no ambient authority exists. These are the cryptographic-network expression of the same POLA discipline that the entry-type layer (cell-capabilities.md) enforces structurally and locally.

### Unforgeability

Capabilities are 32-byte random values (256 bits of entropy). They cannot be guessed or forged.

### Attenuation

Capabilities attenuate naturally: `write_cap > observe_cap > read_cap` (in terms of authority), and derived capabilities have equal or lesser authority.

### Revocability

Capabilities are revoked by updating the cell's facet mapping. The old capability hash no longer appears in the caskmap, so lookups fail.

### Confinement

A capability grants access only to its specific facet of its specific cell. No ambient authority exists.

Source: [doc/design/ocaps.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/ocaps.md) at commit `cdb975d8`.
