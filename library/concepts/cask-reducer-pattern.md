---
id: cask-reducer-pattern
aliases: ["reducer", "cask reducer", "reducer pattern", "operation reducer", "state hash reducer", "(state_hash, args) -> new_state_hash", "pure function of hash"]
topics: [content-addressed-storage, data-structures]
status: current
---

# cask-reducer-pattern

The uniform shape of every persistent CASK operation: `Operation(ctx, store, root Hash, args...) (Hash, error)`. An operation takes the current state's root hash plus arguments and returns the new state's root hash — a deterministic, pure function of its inputs. This buys three properties: **replay** (applying the same operation to the same state always yields the same result), **verification** (anyone can re-run an operation and check the resulting hash), and **composition** (chain operations by passing one's output hash as the next's input). Reducers are written to minimize Merkle-tree disturbance, modifying a single leaf-to-root path rather than shifting data ranges. Operations that might resize a structure fold the resize into the reducer (`maybeResize`) so determinism holds including any width change; multi-structure atomic updates recompute each child root and commit a single CAS on the composite root. The pattern is the persistent-storage analogue of the in-memory parallel-array operations.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [cask--parallel-arrays--persistent-structures-as-reducers](../sections/cask--parallel-arrays--persistent-structures-as-reducers.md) | The reducer signature and the replay/verify/compose properties; minimizing disturbance; the four persistent structures. |
| [cask--parallel-arrays--compact-index-representation](../sections/cask--parallel-arrays--compact-index-representation.md) | maybeResize folded into the reducer so identical inputs give identical outputs. |
| [cask--parallel-arrays--rabin-bounded-sorted-indexes](../sections/cask--parallel-arrays--rabin-bounded-sorted-indexes.md) | Deterministic Rabin boundaries preserve the reducer property for sorted-index transforms. |

## See also

- [[content-addressed-block-store]] — the store whose root hashes reducers consume and produce.
- [[swap-to-end-allocation]] — Alloc/Free expressed as reducers.
- [[merkle-tree-of-blocks]] — the tree a reducer disturbs along one path.
