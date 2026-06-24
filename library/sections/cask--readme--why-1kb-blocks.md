---
title: Why 1KB blocks
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage, networking]
status: current
---

> Abstract: The rationale for the fixed 1KB block size. A 1KB block plus its metadata and cryptographic envelope fits comfortably in a 1500-byte Ethernet frame, so every block is exactly one UDP datagram and the loss of any single packet is statistically independent of every other. Each block carries up to 32 links (32-byte SHA-256 hashes) followed by a data payload, plus a 12-byte metadata footer (height, link count, data length); a block is therefore simultaneously a node in a Merkle tree and a self-describing unit of transfer, and the same bytes that arrive on the wire are written straight to disk with no translation.

A 1KB block plus its metadata and cryptographic envelope fits comfortably in a 1500-byte Ethernet frame. That means every block is one UDP datagram, every datagram is one block, and loss of any single packet is statistically independent of every other.

Each block carries up to 32 links (32-byte SHA-256 hashes of other blocks) followed by a data payload, plus a 12-byte metadata footer recording the block's height, link count, and data length. A block is therefore both a node in a Merkle tree and a self-describing unit of transfer. The same bytes that arrive on the wire can be written directly to disk with no translation.

The format is defined in `cask.go`:

```go
const (
    HashSize     = 32   // SHA-256
    BlockSize    = 1024 // body
    MetadataSize = 12   // height:8 + numLinks:1 + dataLen:2 + reserved:1
)
```

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
