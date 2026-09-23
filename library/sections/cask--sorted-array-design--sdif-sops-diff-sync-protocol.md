---
title: SDIF / SOPS Diff-and-Sync Protocol
source: doc/design/sorted-array-design.md
source_repo: kriskowal/cask
source_commit: cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4
source_date: 2026-02-17
source_authors: [Kris Kowal]
ingested: 2026-06-24
ingested_by: scholar
topics: [data-structures, content-addressed-storage, networking]
status: current
---

> Abstract: The network protocol that lets two peers reconcile their sorted arrays by exchanging a minimal diff instead of full contents, added to Layer 2 of the casknet stack as two verbs: **SDIF** (sorted-array diff request) and **SOPS** (sorted operations result). SDIF carries the requester's `local_root` and a known `remote_root`, plus a `mode` byte selecting full diff (0x00), range diff (0x01), or chunk diff (0x02) with optional hints. SOPS carries `base_root`, `result_root`, `op_count`, and a serialized Keep/Skip/Inject op sequence (the same caskarray op encoding: 1-byte op_type, 8-byte count, then entries for Inject). The **diff algorithm exploits the Merkle structure**: if the roots are equal, emit no ops; otherwise walk both chunk trees in sorted order, emitting `Keep(entry_count)` for chunks whose hashes match (skipping them without loading) and, only for chunks whose hashes differ, loading both and doing a sorted merge that emits Skip for local-only entries and Inject for remote-only ones. So only differing chunks are ever loaded. The protocol drives membership sync (one SDIF/SOPS exchange) and bidirectional sync (both directions, union of memberships), supports inspect-before-apply conflict resolution, allows partial sync by key range for bounded memory over unreliable links, and coexists with Raft: in a clustered deployment membership changes converge through the Raft log, and SDIF/SOPS handle initial join, disaster recovery, and cross-cluster federation.

## Protocol verbs

Added to Layer 2 (Merkle Tree & File System) in ARCHITECTURE.md:

- **SDIF** — sorted-array diff request.
- **SOPS** — sorted-array operations (diff result).

## SDIF message (sorted diff request)

```
Fixed Fields:
  0    4   command     "SDIF"
  4    8   session     Session number
  12   32  recipient   Recipient's ed25519 public key
  44   8   span        Span ID
  52   8   cohort      Cohort ID
  60   32  local_root  Hash of local sorted array root
  92   32  remote_root Hash of remote sorted array root (if known)
  124  1   mode        Diff mode
Variable Data:
  125  ... hints       Optional: known chunk hashes, key ranges
```

Diff modes: `0x00` full diff (compare entire arrays), `0x01` range diff (hints carry the range), `0x02` chunk diff (hints carry chunk hashes).

## SOPS message (sorted operations result)

```
Fixed Fields:
  0    4   command     "SOPS"
  4    8   session     Session number
  12   32  recipient   Recipient's ed25519 public key
  44   8   span        Span ID
  52   8   cohort      Cohort ID
  60   32  base_root   Root hash this diff applies to
  92   32  result_root Root hash after applying ops
  124  4   op_count    Number of operations
Variable Data:
  128  ... operations  Serialized Op sequence
```

Operation encoding (the same Keep/Skip/Inject shape as the caskarray op stream): `Bytes[0]` op_type (0=Keep, 1=Skip, 2=Inject), `Bytes[1:9]` count (uint64; entry_count for Inject), `Bytes[9:..]` entries (entry_count × entry_size, for Inject).

## Diff algorithm

```
func Diff(ctx, store, localRoot, remoteRoot) ([]Op, error):
    1. If roots are equal: return empty ops (no diff)
    2. Load chunk trees for both roots
    3. Walk trees in parallel (sorted order):
       - If chunk hashes match: emit Keep(chunk.entry_count)
       - If chunk hashes differ:
         a. Load both chunks
         b. Diff entries within chunks (standard sorted merge)
         c. Emit Skip for entries only in local
         d. Emit Inject for entries only in remote
    4. Return ops that transform local → remote
```

Only chunks with differing hashes are loaded and compared; unchanged regions (same chunk hash) are skipped with a single Keep. This is the same locality win the Rabin chunking buys for mutation, now applied to reconciliation.

## Use cases and integration

- **Membership sync**: A sends `SDIF(local=A, remote=?)`; B replies `SOPS(ops to reach B)`; A applies (or inspects first).
- **Bidirectional sync**: A↔B exchange SDIF/SOPS both directions; both apply the received ops (union of memberships).
- **Conflict resolution**: ops are inspectable before applying — Inject ops are new peers to add (usually accept), Skip ops are peers to remove (may require policy).
- **Partial sync**: for large arrays, SDIF with `mode=Range` over successive key ranges bounds memory and allows progress over unreliable connections.
- **Consistency with Raft**: in a clustered deployment, membership changes go through the Raft log and converge there, not via SDIF; SDIF/SOPS serve initial cluster join (new node catch-up), disaster recovery (rebuild from a peer), and cross-cluster federation (separate Raft groups).

Two future extensions are sketched: composite keys (multi-field sort keys with per-field offset/size/order) and computed/derived keys (store the computed value at insert time, look up by it).

Source: [doc/design/sorted-array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/sorted-array-design.md) at commit `cdb975d8`.
