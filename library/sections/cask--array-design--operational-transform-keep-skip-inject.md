---
title: Operational Transform — Keep / Skip / Inject
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

> Abstract: Every `caskarray` mutation is expressed through a single primitive, `Transform(ctx, store, priorRoot, ops) → newRoot`, that takes the prior array root hash plus a sequence of ops covering the entire breadth of the prior state and produces a new root hash. There are exactly three op types: **Keep(n)** copies the next n prior elements into the new array, **Skip(n)** advances past n prior elements without copying, and **Inject(hashes)** appends new hashes at the current output position. The covering invariant is that the sum of all Keep and Skip counts equals the prior length, so every prior index is kept or skipped exactly once (Inject does not consume the prior array). The transform walks a read cursor over the prior array and the op stream in lockstep, building a fresh array trie from the kept and injected elements in order. Each mutation is just an op sequence: `Set(i,h)` = Keep(i), Skip(1), Inject([h]), Keep(len−i−1); `Append(h)` = Keep(len), Inject([h]); `Insert(i,h)` = Keep(i), Inject([h]), Keep(len−i); `Delete(i)` = Keep(i), Skip(1), Keep(len−i−1); `Replace [i,j)` = Keep(i), Skip(j−i), Inject(hashes), Keep(len−j). The **stated weakness**: Append and Set preserve trie structure, but Insert and Delete at an offset re-read and re-write the whole suffix from index i onward, discarding much of the parent trie (the cost the columnar tables avoid by moving indexes, not values).

## The single mutation primitive

All mutation operations are implemented in terms of one operational transform that accepts the prior array root hash and a sequence of operations covering the entire breadth of the prior state, producing a new array root hash.

**Op types**

- **Keep(n)** — copy the next `n` elements from the prior array into the new array (n ≥ 0).
- **Skip(n)** — advance over the next `n` prior elements without copying (n ≥ 0).
- **Inject(hashes)** — append the given hashes to the new array (insert at the current output position).

**Invariant**: the sum of all Keep and Skip counts equals the prior array length. Every prior index is therefore kept or skipped exactly once. Inject does not consume the prior array; it only adds to the output.

## Transform routine

`Transform(ctx, store, priorRoot, ops) → (newRoot Hash, err)` maintains a **read cursor** into the prior array (starting at index 0) and an output array (initially empty). For each op:

- **Keep(n)**: for each of the next n prior positions, `Get(priorRoot, cursor)`, append to output; advance the cursor by n.
- **Skip(n)**: advance the cursor by n (append nothing).
- **Inject(hashes)**: append each hash to the output (cursor unchanged).

The new state is "walk the prior array and the op stream in lockstep; copy kept elements and inject runs into a new array." All structural sharing or discard is implied by this single pass. Then the new array root block (trie root + new length) is written and its hash returned.

## Mutations as op sequences

Let `priorLen = Len(priorRoot)`:

| Mutation | Op sequence | New length |
|---|---|---|
| `Set(i, h)` | Keep(i), Skip(1), Inject([h]), Keep(priorLen − i − 1) | priorLen |
| `Append(h)` | Keep(priorLen), Inject([h]) | priorLen + 1 |
| `Insert(i, h)` | Keep(i), Inject([h]), Keep(priorLen − i) | priorLen + 1 |
| `Delete(i)` | Keep(i), Skip(1), Keep(priorLen − i − 1) | priorLen − 1 |
| `Replace [i, j)` with `hashes` | Keep(i), Skip(j − i), Inject(hashes), Keep(priorLen − j) | varies |

## The stated weakness

Append and Set preserve trie structure (a single root-to-leaf path changes). Insert and Delete at an offset re-read and re-write a suffix of the array from index i onward, **discarding much of the parent trie** — the op sequences cause Transform to copy every element after the edit point into fresh blocks. Worst-case cost is O(length / 32). The documented guidance is to prefer Append and Set, and to flag Insert/Delete with a comment that they may rewrite a large suffix. This is exactly the cost the columnar [[parallel-arrays-columnar]] tables sidestep: values keep stable slots and only the narrow index columns move.

Source: [doc/design/array-design.md](https://github.com/kriskowal/cask/blob/cdb975d875b876c8fb7b4fb9e97f6567b52a7aa4/doc/design/array-design.md) at commit `cdb975d8`.
