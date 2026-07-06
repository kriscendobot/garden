---
title: The query cost model — index key layouts and contiguous-prefix selection
source: notes/query-cost-model.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [datalog-query]
status: current
---

> Abstract: The cost problem: a datalog query decomposes into premises, each resolved by a range scan over a prolly-tree index that is sparsely replicated on demand, so every node traversal may incur a network roundtrip. Premise order determines which variables are bound when later premises run, which determines how tight their scans are — a good order is the difference between point lookups and a full index walk. All claims live in a search tree with three key layouts distinguished by a tag byte, each 162 bytes: **EAV** (`tag | entity 64B | attribute 64B | typ | value_ref 32B`), **AEV** (attribute-leading), and **VAE** (`tag | typ | value_ref | attribute | entity`). A range scan builds a `(start_key, end_key)` pair: known fields set in both, unknown fields `0x00..` in start and `0xFF..` in end, and only fields forming a contiguous prefix from the key's start constrain the traversal. The model selects the index giving the longest contiguous prefix for the known fields — entity-known → EAV, attribute+value → VAE (value+attribute contiguous, 97 bytes vs AEV's 65 with value post-filtered), attribute-only → AEV, value-only → VAE.

## Problem

A datalog query decomposes into premises, each resolved by a range scan over a prolly tree index. The tree is sparsely replicated on demand. Every node traversal during a scan may incur a network roundtrip. The order in which premises execute determines which variables are bound when subsequent premises run, which determines how tight their scans are. A good ordering can be the difference between a handful of point lookups and a full index walk. The query planner needs a cost model to estimate the expense of each premise given currently bound variables, so it can choose an execution order that minimizes total traversal.

## Index Structure

All claims are stored in a search tree index with three key layouts distinguished by a tag byte. Every key is 162 bytes:

```
EAV
|1B |-----------64B-----------|-----------64B-----------|1B |------32B------|
+---+-------------------------+-------------------------+---+---------------+
|tag|         entity          |        attribute        |typ|   value_ref   |
+---+-------------------------+-------------------------+---+---------------+

AEV
|1B |-----------64B-----------|-----------64B-----------|1B |------32B------|
+---+-------------------------+-------------------------+---+---------------+
|tag|        attribute        |          entity         |typ|   value_ref   |
+---+-------------------------+-------------------------+---+---------------+

VAE
|1B |1B |------32B------|-----------64B-----------|-----------64B-----------|
+---+---+---------------+-------------------------+-------------------------+
|tag|typ|   value_ref   |        attribute        |          entity         |
+---+---+---------------+-------------------------+-------------------------+
```

A range scan constructs a `(start_key, end_key)` pair. Known fields are set to their actual value in both keys. Unknown fields are `0x00..` in the start and `0xFF..` in the end. Only fields that form a contiguous prefix from the start of the key constrain the tree traversal.

For example, `{the, is}` (attribute + value known) on AEV constrains only the 65-byte attribute prefix, with the value known but sitting after the unknown-entity gap and therefore post-filtered; the same two known fields on VAE form a 97-byte contiguous prefix (value + attribute). The cost model selects the index that produces the longest contiguous prefix for the known fields:

```
entity known         → EAV  (entity leads, 64B+)
attribute + value    → VAE  (value + attribute contiguous, 97B)
attribute only       → AEV  (attribute leads, 65B)
value only           → VAE  (value leads, 34B)
```

When entity is known, EAV always wins — entity is 64 bytes and leads the key. If attribute is also known the prefix extends to 129 bytes. If value is known instead, it sits at the end of the EAV key and gets post-filtered, but no index places entity and value adjacent so EAV is still best. When entity is unknown but both attribute and value are known, VAE produces a 97-byte prefix while AEV produces 65 bytes with value post-filtered.

Source: [notes/query-cost-model.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/query-cost-model.md) at commit `f777fe7c`.
