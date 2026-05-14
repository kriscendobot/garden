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
---

> Abstract: **Problem**: the Endo daemon's bus protocol uses a hand-rolled length envelope; a second consumer (Rust endor daemon, XS worker snapshot pipeline) is coming. What's needed is a small focused framing primitive that buffers a stream of length-prefixed byte strings using the CBOR byte-string head as length encoding. **NOT a CBOR codec** — it only understands the byte-string head, optionally wrapped in tag 24. A consumer with structured CBOR encodes its own payload bytes and hands the writer a `Uint8Array`; the writer wraps in a CBOR byte-string head. **Naming**: `@endo/cbors` — the plural form names "a sequence of length-prefixed byte strings on the wire"; `@endo/cbor-frame` rejected for missing the sequence-ness. `makeCborsReader` / `makeCborsWriter` mirror `makeNetstringReader` / `makeNetstringWriter` exactly. No legacy aliases (package is new). Diagnostic surface (the `name` option, `maxMessageLength` ceiling, error wording) follows netstring's conventions.

# CBOR Byte-String Framing (`@endo/cbors`)

## What is the Problem Being Solved?

The Endo daemon's bus protocol exchanges length-prefixed payloads between the Node host and the Rust supervisor (see `packages/daemon/src/envelope.js`, `packages/daemon/src/bus-xs-core.js`). Today, that exchange is built on a private hand-rolled length envelope. A second consumer (the prospective `endor` Rust daemon, the XS worker snapshot pipeline) is on the way.

What is missing is a small, focused framing primitive that buffers a stream of length-prefixed byte strings on the wire, using the CBOR byte-string head as its length encoding. This package is the precise CBOR-shaped analog of `@endo/netstring` and of the proposed `@endo/syrup-frame` (see [`ocapn-tcp-syrup-framing.md`](./ocapn-tcp-syrup-framing.md), PR 29 in `endojs/endo-but-for-bots`, not yet landed): each names a different on-the-wire grammar for length-prefixed byte strings. Note: PR 29's package is queued to be renamed from `@endo/syrup-frame` to `@endo/syrups` for naming consistency with `@endo/cbors` (see [`syrups.md`](./syrups.md)).

This package is deliberately **not** a CBOR codec. It does not understand CBOR integers, arrays, maps, floats, or tags beyond what is needed to read and write the byte-string head. A consumer that wants to send structured CBOR uses any CBOR codec it likes to produce a `Uint8Array`, hands that array to the writer, and the writer wraps it in a CBOR byte-string head that names its length. The reader returns the payload bytes; the consumer decodes them as it sees fit.

The reader and writer mirror `@endo/netstring`'s shape. Reading a stream is `for await (const bytes of makeCborsReader(input))`; writing is `await writer.next(bytes)`. The diagnostic surface (the `name` option, the `maxMessageLength` ceiling, error wording) follows the same conventions.

## Naming

**Package: `@endo/cbors`.** A repository search returns no `cbors` package, so law 1 is clear. The plural form names "a sequence of length-prefixed byte strings on the wire, each headed in CBOR's grammar." The proposed sibling `@endo/syrup-frame` (PR 29; not yet landed) names the analogous package whose grammar is Syrup's byte-string record (`<digits>:<payload>`). "CBOR" is the canonical acronym for Concise Binary Object Representation and is therefore permitted under the namer's rule on canonical acronyms.

We rejected `@endo/cbor-frame` (mirroring `@endo/syrup-frame`) because the package frames a *sequence* of byte strings, and the plural form `cbors` keeps this property visible.

**Reader and writer identifiers: `makeCborsReader` and `makeCborsWriter`.** This replicates the netstring naming exactly (`makeNetstringReader`, `makeNetstringWriter`); operators familiar with one will read the other without translation. No legacy `cborsReader` / `cborsWriter` aliases (the package is new).

Source: [designs/cbors.md](https://github.com/endojs/endo-but-for-bots/blob/0a99c7bc4a83b61b0b488146e262de08a588a998/designs/cbors.md) at commit `0a99c7bc` on branch `llm`.
