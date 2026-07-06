---
title: The divergence clock — a {since, drift, at} synchronization-point tuple
source: notes/divergence-clock.md
source_repo: dialog-db/dialog-db
source_commit: abb5ca3f7c1b7bde278034eed41b66207a2b1d4e
source_date: 2026-07-01
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [change-propagation, local-first-sync]
status: current
---

> Abstract: The note's proposed clock synthesizes the surveyed ideas to get two desired properties at once: identifying concurrent changes, and comparing any two events without reading arbitrary tree branches. The insight: capture the *synchronization point* — the tree revision changes were made from — so two changes sharing a synchronization point are concurrent; but because a revision is a cryptographic hash, two changes from different revisions can't be ordered. So replace the revision hash with a **monotonically growing time** as the synchronization point, encoded as a `{ since, drift, at }` tuple: `since` is an increment of the highest `since` across all commits in the *shared* tree (not the local replica) — the shared convergence point; `drift` is the number of commits made since the last synchronization with the shared tree; `at` is the unique site identifier that produced the change. The key property: when two operations share a `since` but differ in `at`, they diverged from the same tree state and are therefore concurrent. Any two timestamps are comparable by replacing `at` with a hash of the change, and the tuple encodes into a lexicographic `${since}/${at}/${drift}` path that indexes commits in deterministic order. A worked pull/commit/push table and a git-graph visualization show `since` advancing only at push (shared-tree convergence) while `drift` counts local commits between syncs.

## Desired properties

1. Identify concurrent changes.
2. Compare any two events without reading arbitrary tree branches.

For the first goal, capture synchronization points — e.g. the tree revision changes were made from. If two changes share a revision, they can be considered concurrent. But since a revision is a cryptographic hash, two changes with different revisions can't be compared (it's unclear which is older).

## The clock

Build on that idea, but use a **monotonically growing time** as the synchronization point instead of a revision hash. Use a `{ since, drift, at }` tuple:

- `since` — an increment of the highest `since` across all commits in the *shared* tree (not the local replica).
- `drift` — the number of commits made since the last synchronization with the shared tree.
- `at` — the unique identifier of the site that produced the change.

**The key insight**: `since` represents the shared convergence point — when two operations have the same `since` value but different `at` values, they diverged from the same tree state and are therefore concurrent.

With such timestamps, concurrent changes are identified by comparing `since` and `at`: same `since`, different `at` ⇒ concurrent. Any two timestamps can also be compared by replacing `at` with a hash of the change. The tuple encodes into a lexicographic `${since}/${at}/${drift}` path used to index commits in deterministic order.

## Worked trace

A pull/commit/push table walks three sites A, B, C through offline commits and syncs. `since` stays 0 while A and B commit offline (both diverging from tree state 0, hence concurrent), advances to 2 when A pushes, and continues advancing only at push/merge points as later sites converge — while `drift` counts each site's local commits between synchronizations. The accompanying git-graph visualization tags merges with the resulting `since` values (2, 5, 8), showing `since` as the shared-convergence coordinate and `drift` as the per-site local offset.

Source: [notes/divergence-clock.md](https://github.com/dialog-db/dialog-db/blob/abb5ca3f7c1b7bde278034eed41b66207a2b1d4e/notes/divergence-clock.md) at commit `abb5ca3f`.
