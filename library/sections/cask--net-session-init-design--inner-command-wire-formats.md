---
title: Inner Command Wire Formats
source: doc/design/net-session-init-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-14
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [networking]
status: current
---

> Abstract: The byte layout of each casknet inner command (the plaintext inside the AEAD ciphertext), with packet sizes. **LOAD** (44B plaintext): command, 8-byte span_id correlation, 32-byte block hash. **STOR** (56+B): command, span_id, 32-byte hash, 12-byte metadata footer (`height` uint64, `numLinks` 0-32, `dataLen` 0-1024 uint16, 1 reserved), then up to 1024 block bytes; also the response to LOAD; a full 1024-byte block totals 1140 bytes on the wire (fits a 1500 MTU). **ROTS** (13+32N): command, count 1-32, 8-byte average holdback_ns, then N 32-byte acknowledged hashes (32 hashes → 1097 bytes). **CASC** (141B): command, span_id, 1-byte traffic_class, 32-byte capability-token nonce, 32-byte cell address, 32-byte expected `old`, 32-byte desired `new`. **CSAC** (45B): command, span_id, 1-byte success, 32-byte current hash. **GCGC** (12B): command, span_id. **CGCG** (33+E): command, span_id, blocks_retained, blocks_collected, status, error_len, variable UTF-8 error_msg. Server processing of an encrypted packet extracts session_id, looks up and expiry-checks the session, verifies `counter > recv_ctr`, decrypts, updates recv_ctr and peer address (mobility), then dispatches on the inner 4-byte command.

## LOAD (load request)

```
0   4   command   "load"
4   8   span_id   Request correlation ID
12  32  hash      Hash of requested block
```

44 bytes plaintext | total packet 104 bytes.

## STOR (store block; also the response to LOAD)

```
0   4   command   "stor"
4   8   span_id   Request correlation ID
12  32  hash      Block hash
44  12  metadata  Block metadata (see below)
56  B   block     Block data (variable, up to 1024 bytes)
```

Metadata is always exactly 12 bytes (`cask.MetadataSize`): `height` (uint64 BE, Merkle tier), `numLinks` (1B, 0-32), `dataLen` (uint16 BE, 0-1024), 1 reserved byte. For a full block (B=1024): 1080 bytes plaintext, 1140 bytes total (fits 1500 MTU).

## ROTS (store acknowledgement)

```
0   4     command       "rots"
4   1     count         Number of hashes (1-32)
5   8     holdback_ns   Average hold-back (nanoseconds)
13  32*N  hashes        Array of acknowledged hashes
```

13 + 32*N bytes plaintext. For 32 hashes: 1097 bytes total.

## CASC (compare-and-swap cell)

```
0    4   command        "casc"
4    8   span_id        Request correlation ID
12   1   traffic_class  Priority class (0-128)
13   32  nonce          Capability token
45   32  address        Cell address
77   32  old            Expected current hash
109  32  new            Desired new hash
```

141 bytes plaintext | total 201 bytes.

## CSAC (CAS response)

```
0   4   command   "csac"
4   8   span_id   Request correlation ID
12  1   success   1=success, 0=failed
13  32  current   Current hash at address
```

45 bytes plaintext | total 105 bytes.

## GCGC (garbage collection request)

```
0   4   command   "gcgc"
4   8   span_id   Request correlation ID
```

12 bytes plaintext | total 72 bytes.

## CGCG (garbage collection response)

```
0   4   command           "cgcg"
4   8   span_id           Request correlation ID
12  8   blocks_retained   Blocks reachable from root (uint64 BE)
20  8   blocks_collected  Unreachable blocks deleted (uint64 BE)
28  1   status            0=success, 1=error
29  4   error_len         Error message length (uint32 BE)
33  E   error_msg         Error message (variable, UTF-8)
```

33 + E bytes plaintext.

## Processing an encrypted packet

The server extracts the session_id (first 32 bytes), looks up the session and verifies it is not expired, extracts the nonce and verifies `counter > recv_ctr` (replay protection), decrypts with ChaCha20-Poly1305, updates recv_ctr, updates the peer address (mobility support), then dispatches on the inner 4-byte command (`load`/`stor`/`rots`/`casc`/`csac`/`gcgc`/`cgcg`).

Source: [doc/design/net-session-init-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/net-session-init-design.md) at commit `cdb975d8`.
