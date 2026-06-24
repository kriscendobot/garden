---
title: Overview + Naming (problem statement + package + identifier rationale)
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
kind: index
section_count: 2
---

> Abstract: **Problem**: the Endo daemon's bus protocol uses a hand-rolled length envelope; a second consumer (Rust endor daemon, XS worker snapshot pipeline) is coming. What's needed is a small focused framing primitive that buffers a stream of length-prefixed byte strings using the CBOR byte-string head as length encoding. **NOT a CBOR codec** — it only understands the byte-string head, optionally wrapped in tag 24. A consumer with structured CBOR encodes its own payload bytes and hands the writer a `Uint8Array`; the writer wraps in a CBOR byte-string head. **Naming**: `@endo/cbors` — the plural form names "a sequence of length-prefixed byte strings on the wire"; `@endo/cbor-frame` rejected for missing the sequence-ness. `makeCborsReader` / `makeCborsWriter` mirror `makeNetstringReader` / `makeNetstringWriter` exactly. No legacy aliases (package is new). Diagnostic surface (the `name` option, `maxMessageLength` ceiling, error wording) follows netstring's conventions.

Sections:

- [What is the Problem Being Solved?](endo-but-for-bots--llm-designs-cbors--overview-and-naming--what-is-the-problem-being-solved.md)
- [Naming](endo-but-for-bots--llm-designs-cbors--overview-and-naming--naming.md)

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
