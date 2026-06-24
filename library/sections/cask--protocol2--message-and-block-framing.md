---
title: CASK Network Protocol v2 (superseded) — message structure and regular block framing
source: doc/design/protocol2.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: superseded
notes: |
  Never-implemented v2 proposal. The shipped block framing is the 1024-byte
  body + 12-byte metadata footer of cask--protocol--message-and-block-formats
  and cask--net-session-init-design--inner-command-wire-formats, NOT this
  1026-byte depth+type+payload framing.
---

## Abstract

The fixed-offset message structure and "regular framing" block format proposed for the never-built v2. Every v2 message opens with a 60-byte fixed header (4-byte command, 8-byte session, 32-byte recipient ed25519 public key, 8-byte span, 8-byte cohort), then message-specific fixed fields, then variable data last. The design principle is command-first/variable-data-last so all fixed fields parse by known offset without scanning. The proposed block was a fixed 1026 bytes (1 byte depth + 1 byte type + 1024 bytes payload), where type 0x00 means a data block and types 0x01-0x20 mean a hash block of that many 32-byte hashes followed by zero padding. **This framing was never shipped**; the actual block is a 1024-byte body with a separate 12-byte metadata footer.

## Message structure

All v2 messages followed a fixed structure with variable-length data at the end:

```
0       4       command     Command string (4 ASCII bytes)
4       8       session     Session number (uint64, big-endian)
12      32      recipient   Recipient's ed25519 public key
44      8       span        Span ID for correlation/tracing (uint64, big-endian)
52      8       cohort      Cohort ID for prioritizing/aggregating spans (uint64, big-endian)
60      ...     fixedFields Message-specific fixed fields
...     N       variable    Variable-length data (block, metadata, etc.)
```

Fixed header size: 60 bytes. Design principles: command-first (the first 4 bytes determine the whole packet structure), fixed offsets, variable data last, predictable parsing, efficient by-offset access, session-scoped spans.

**Commands.** Only `STOR` (store a block) and `LOAD` (request a block) were specified; "additional commands will be added as requirements emerge."

## STOR / LOAD message formats

`STOR` adds a 1-byte flags field (bit 0 = has-metadata) and a 32-byte hash after the 60-byte header (fixed portion 93 bytes), then optional length-prefixed metadata, then the 1026-byte block. Without metadata the total is 93 + 1026 = 1119 bytes; metadata is bounded to M ≤ 381 bytes to stay within the 1500-byte MTU. `LOAD` is the 60-byte header plus a 32-byte hash (total 92 bytes, no variable data); its response is a `STOR` echoing the same session, span, and cohort.

## Block format (regular framing)

```
0       1           depth       Depth in Merkle tree (0 = leaf, 1+ = internal)
1       1           type        Block type (0x00 = data, 0x01-0x20 = hash count)
2       1024        payload     Data bytes, or N=type hashes followed by zero padding
```

Total block size: 1026 bytes. Hash blocks (type N, 1 ≤ N ≤ 32) carry 32*N bytes of hashes then 1024-32*N bytes of zero padding; data blocks (type 0x00) carry up to 1024 content bytes. The stated benefits were fixed-size buffer management, an explicit depth byte for efficient tree traversal, a type byte distinguishing data from hash blocks, and predictable allocation. The shipped design instead keeps the block body at 1024 bytes and moves height/numLinks/dataLen into a separate 12-byte footer.

Source: [doc/design/protocol2.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol2.md) at commit `cdb975d8`.
