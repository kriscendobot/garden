---
title: Naming
source: designs/cbors.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0a99c7bc4a83b61b0b488146e262de08a588a998
source_date: 2026-05-05
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [streams, marshal]
status: current
notes: The naming story is non-trivial — the plural form `cbors` names "a sequence of length-prefixed byte strings on the wire, each headed in CBOR's grammar"; `@endo/cbor-frame` was rejected because it doesn't carry the plural / sequence-ness. `makeCborsReader` / `makeCborsWriter` exactly mirror `makeNetstringReader` / `makeNetstringWriter` so operators familiar with one read the other without translation.
parent: endo-but-for-bots--llm-designs-cbors--overview-and-naming
---

**Package: `@endo/cbors`.** A repository search returns no `cbors` package, so law 1 is clear. The plural form names "a sequence of length-prefixed byte strings on the wire, each headed in CBOR's grammar." The proposed sibling `@endo/syrup-frame` (PR 29; not yet landed) names the analogous package whose grammar is Syrup's byte-string record (`<digits>:<payload>`). "CBOR" is the canonical acronym for Concise Binary Object Representation and is therefore permitted under the namer's rule on canonical acronyms.

We rejected `@endo/cbor-frame` (mirroring `@endo/syrup-frame`) because the package frames a *sequence* of byte strings, and the plural form `cbors` keeps this property visible.

**Reader and writer identifiers: `makeCborsReader` and `makeCborsWriter`.** This replicates the netstring naming exactly (`makeNetstringReader`, `makeNetstringWriter`); operators familiar with one will read the other without translation. No legacy `cborsReader` / `cborsWriter` aliases (the package is new).

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
