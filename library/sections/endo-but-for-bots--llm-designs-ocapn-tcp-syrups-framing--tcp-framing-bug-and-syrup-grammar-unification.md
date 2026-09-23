---
title: "TCP framing bug and Syrup grammar unification"
source: designs/ocapn-tcp-syrups-framing.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: a4978698b19bbea5fcb8049e5cb7944ac8f2485a
source_date: 2026-05-06
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
topics: [streams, ocapn]
status: current
---

> Abstract: The `tcp-test-only` OCapN netlayer has a latent chunk-boundary bug: it feeds raw TCP `data` event bytes directly into `SyrupReader`, which works only if each TCP event contains a whole number of Syrup records. TCP makes no such guarantee; a single logical OCapN message split across two TCP chunks causes an abort. The fix motivation leads to a grammar-unification observation: **Syrup byte-string grammar is exactly Netstring grammar minus the trailing comma** (`<digits>:<payload>` with no separator vs. `<digits>:<payload>,`). Because OCapN messages are Syrup values, wrapping each one in a Netstring inserts a redundant outer length-prefix around a payload whose first bytes already form a Syrup expression. Dropping the comma (`<digits>:<payload>` grammar) makes the framed stream a sequence of Syrup byte-string records, collapsing framing and serialization to a single length-prefixed-bytes abstraction. This is the `@endo/syrups` package: Netstring without the comma, named for parallelism with `@endo/cbors` (plural-of-format convention for streaming framers). The daemon's own TCP transport (`packages/daemon/src/networks/tcp-netstring.js`) is cited as the correct pattern: it already uses `@endo/netstring` to wrap CapTP/JSON frames. The OCapN TCP netlayer lacks this framing today and this design adds it, choosing the comma-less variant to exploit the grammar identity.

**TCP framing bug (lines 14-52):**
The current `tcp-test-only` netlayer (`packages/ocapn/src/netlayers/tcp-test-only.js`) feeds raw socket `data` events into `SyrupReader`. The handler in `packages/ocapn/src/client/ocapn.js` loops `while (syrupReader.index < data.length)` — this works only when each TCP event contains exactly complete Syrup records. In practice, a message spanning two TCP segments causes `readOcapnMessage` to throw and aborts the session. The same deficiency exists in `handleHandshakeMessageData` in `packages/ocapn/src/client/handshake.js`.

**Grammar unification observation (lines 77-105):**
Syrup encodes a byte string as `<digits>:<bytes>`. A Netstring is `<digits>:<bytes>,`. The trailing comma is the only difference. OCapN messages are Syrup values; the sequence of OCapN messages is naturally a sequence of Syrup top-level values. Wrapping each in a Netstring duplicates the length-prefix machinery. Dropping the comma produces a stream that is literally a sequence of Syrup byte-string records — framing and serialization share a grammar. The bridge between wire and data model collapses to one length-prefixed-bytes abstraction.

**Named structural fact: §the-named-syrups-as-netstring-minus-comma** — the grammar-identity pattern. `@endo/syrups` grammar: `frame = length ":" payload` with no separator. This is simultaneously a valid Netstring (absent the comma) and a valid Syrup byte-string (the framing IS the serialization header).

**Named structural fact: §the-named-grammar-identity-as-justification-for-new-package** — the grammar identity is not coincidental; it is by design, and the package name (`@endo/syrups`) preserves that intent. The README documents that the grammar is independent of any Syrup dependency and may be used as a bare length-prefixed framer, but the package exists because of OCapN.
