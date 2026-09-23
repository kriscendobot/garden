---
title: CASK Local Protocol (cask/sock) — message and block formats
source: doc/design/protocol.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking, content-addressed-storage]
status: current
---

## Abstract

The byte-exact wire layouts for casksock's three data-carrying messages (`stor`, `load`, `ackn`) and the CASK block format they move. A `stor` packet is a 68-byte header (command, 8-byte cohort, 8-byte span, 4-byte ttlms, 32-byte SHA-256 hash, 12-byte metadata footer) followed by the block body; a `load` is 36 bytes (command + hash); an `ackn` batches 1..32 hashes with an average hold-back time. The block body is up to 1024 bytes of links-then-data with a separately-stored 12-byte metadata footer (height, numLinks 0-32, dataLen 0-1024, reserved); the hash covers only the occupied links + dataLen bytes, and all multi-byte integers are big-endian.

## STOR message (store block)

The `stor` message instructs a peer to store a block with a given hash. Cohort carries priority and trace information; smaller cohort values are higher priority.

```
Offset  Size    Field       Description
------  ------  ----------  -----------------------------------------
0       4       command     ASCII string "stor"
4       8       cohort      Priority and trace cohort (uint64, big-endian)
12      8       span        Packet span identifier (uint64, big-endian)
20      4       ttlms       Time to live in milliseconds (uint32, big-endian)
24      32      hash        SHA-256 hash of the block (big-endian)
56      12      metadata    Block metadata (see Block Format below)
68      N       block       Block data (see Block Format below)
```

Total size: 68 + N bytes, N up to 1024. `ttlms` of 0 means no expiration. The block length is implied by the packet size; metadata determines how much of the block is links and how much is data.

## LOAD message (request block)

The `load` message requests a peer to send back a block with the given hash.

```
Offset  Size    Field       Description
------  ------  ----------  -----------------------------------------
0       4       command     ASCII string "load"
4       32      hash        SHA-256 hash of the requested block
```

Total size: 36 bytes. When a peer receives a `load`, it responds with a `stor` message carrying the requested block.

## ACKN message (acknowledge blocks)

The `ackn` message acknowledges receipt and storage of up to 32 `stor` blocks. Each `ackn` contains the average hold-back time (in nanoseconds) the receiver waited before emitting the acknowledgment.

```
Offset  Size    Field          Description
------  ------  -------------  -----------------------------------------
0       4       command        ASCII string "ackn"
4       1       count          Number of hashes (1..32)
5       8       avgHoldBackNS  Average hold-back time (uint64, big-endian)
13      32*N    hashes         Array of SHA-256 hashes (N = count)
```

Total size: 13 + (32 * N) bytes.

## Block format

Each CASK block body is up to 1024 bytes, with a separate 12-byte metadata footer. The body contains links followed by data bytes:

```
Block body (1024 bytes):
0       32*N        links       Array of SHA-256 hashes (N = numLinks)
32*N    dataLen     bytes       Content bytes

Metadata footer (12 bytes, stored separately):
0       8           height      Merkle tree tier (uint64 big-endian)
8       1           numLinks    Number of child block links (0-32)
9       2           dataLen     Data byte count (uint16 big-endian, 0-1024)
11      1           reserved    Padding for future use
```

Constraints: maximum block body 1024 bytes; maximum 32 links; maximum content bytes = 1024 - (32 * numLinks); all multi-byte integers big-endian; the hash covers only the occupied portion (links + dataLen bytes). This is the **same** 12-byte metadata-footer block shape the encrypted casknet protocol carries (see `cask--net-session-init-design--inner-command-wire-formats`); the never-implemented v2 used a different 1026-byte depth+type+payload framing instead (see `cask--protocol2--message-and-block-framing`).

Source: [doc/design/protocol.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/protocol.md) at commit `cdb975d8`.
