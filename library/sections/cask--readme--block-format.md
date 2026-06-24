---
title: Block format
source: README.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [content-addressed-storage]
status: current
---

> Abstract: The on-wire and on-disk block layout. Each block has a 1024-byte body and a 12-byte metadata footer. The body holds links (32-byte SHA-256 hashes) followed by data bytes. The metadata holds height (uint64), numLinks (uint8), dataLen (uint16), and a reserved (uint8) byte. The hash covers only the occupied portion of the block (links + data), so data with trailing zeros is preserved exactly through round-trips.

Each block has a 1024-byte body and a 12-byte metadata footer:

- **Body** (1024 bytes): links (32-byte SHA-256 hashes) followed by data bytes.
- **Metadata** (12 bytes): height (uint64), numLinks (uint8), dataLen (uint16), reserved (uint8).

The hash covers only the occupied portion of the block (links + data), so data with trailing zeros is preserved exactly through round-trips.

Source: [README.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/README.md) at commit `cdb975d8`.
