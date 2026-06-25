---
title: Reified Op Streams — Reify, Realize, TransformReified
source: doc/design/array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage]
status: current
---

> Abstract: A `caskarray` op sequence (a run of Keep/Skip/Inject) can be **reified** into a linked list of CASK blocks so it can be persisted, transmitted, or replayed without holding the full sequence in memory. Each op-stream block has link 0 = the next block (ZeroHash terminates the list) and up to 992 payload bytes (1024 − 32 for the one link), so numLinks=1. Encoding per op: Keep is tag `0x00` + n as uint64-LE (9 bytes), Skip is tag `0x01` + n as uint64-LE (9 bytes), Inject is tag `0x02` + n as uint32-LE + n × 32-byte hashes (5 + 32n bytes); one block holds many Keep/Skip ops or one Inject of up to ⌊(992−5)/32⌋ = 30 hashes, with larger Injects split across consecutive ops or blocks. This gives two distinct "roots": the **array root** (trie + length) and the **op-stream root** (hash of the first stream block). `Reify(store, ops) → opStreamRoot` encodes and stores the blocks; `Realize(store, opStreamRoot) → ops` decodes them back; `TransformReified(store, priorRoot, opStreamRoot)` realizes then transforms. So a caller can store an op sequence once, share or persist just its op-stream root, and apply it later without keeping the op list resident — the same shape the SDIF/SOPS sorted-array sync protocol serializes over the wire.

## Op-stream block encoding

A reified op sequence is stored as one or more CASK blocks. Each block has:

- **Link 0**: hash of the next block in the stream (ZeroHash = no next block; this is the last block).
- **Bytes**: a chunk of the encoded op stream (up to 1024 − 32 = 992 bytes after the one link).

So numLinks=1, bytesSize = length of the chunk.

Encoding of a chunk (within the bytes region):

- **Keep(n)**: tag byte `0x00`; `n` as uint64 little-endian (8 bytes). Total 9 bytes.
- **Skip(n)**: tag byte `0x01`; `n` as uint64 little-endian (8 bytes). Total 9 bytes.
- **Inject(hashes)**: tag byte `0x02`; `n` as uint32 little-endian (4 bytes); then `n` hashes (32 bytes each). Total 5 + 32n bytes.

One 992-byte block holds many Keep/Skip ops or one Inject of up to ⌊(992 − 5)/32⌋ = 30 hashes. A larger Inject splits into consecutive Inject ops (`Inject(30), Inject(30), Inject(remainder)`), continuing in the same block if space remains or starting a new block (link 0 = next block). The chunk is a sequence of (tag, payload) pairs until the block fills or the chunk ends.

## Two notions of root

- **Array root** — hash of the array root block (trie root + length).
- **Op-stream root** — hash of the first op-stream block (the head of the linked list).

## Reify, Realize, TransformReified

- **`Reify(ctx, store, ops) → (opStreamRoot Hash, err)`** — encode the op sequence into one or more blocks (split across blocks when an op does not fit), store each block, link them in order, return the hash of the first block.
- **`Realize(ctx, store, opStreamRoot) → (ops, err)`** — load the block at `opStreamRoot`, decode its chunk of ops; if link 0 is non-zero, load and decode that block; repeat. Return the concatenated op sequence.
- **`TransformReified(ctx, store, priorRoot, opStreamRoot) → (newRoot Hash, err)`** — `Realize` the op stream, then `Transform(ctx, store, priorRoot, ops)`.

So reifying turns an in-memory op sequence into a DAG of blocks (a linked list); realizing inverts it. `Transform` can take `ops` either from memory or via `Realize` first, so a caller stores the sequence once, shares or persists the op-stream root, and applies it later without holding the full op list resident. This is the persistence/transmission layer the SDIF/SOPS sorted-array sync protocol reuses to carry a diff result on the wire.

Source: [doc/design/array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/array-design.md) at commit `cdb975d8`.
