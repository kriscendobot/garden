---
title: Greedy premise ordering, its rationale, and the Held-Karp alternatives
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

> Abstract: The greedy planner runs in O(N²) for N premises — at each of N steps it scans the remaining premises for the cheapest viable one. It is chosen because most real queries have a handful of premises where the cost gaps between orderings are large enough that the locally cheapest choice is globally optimal, and the index-aware tiers amplify those gaps (a SCAN-vs-READ gap is roughly 10×) so cost ties that would force an arbitrary choice are expected to be rare. The cost function is keyed on *which* components are bound, not merely how many: `{the, of}` (129-byte EAV prefix) is fundamentally cheaper than `{the, is}` (97-byte VAE prefix with possible verification). **Alternative — exhaustive search (Held-Karp DP):** optimal minimum-cost ordering over all permutations via DP over subsets (state = bitmask of evaluated premises, O(2ᴺ·N²)); rejected as significant implementation complexity for a margin gain when N<10 greedy usually finds a near-optimal order. **Future — hybrid greedy + Held-Karp for tie-breaking:** when greedy hits a cost tie it picks arbitrarily and can miss the order whose bindings cascade best downstream, so apply Held-Karp over the tied subset only — O(N²) in the common case, O(2ᴺ·N²) only when it matters, and planning is cached per adornment so its overhead is negligible against a single network roundtrip.

### Greedy ordering

The greedy algorithm runs in O(N^2) for N premises. At each of N steps it scans remaining premises for the cheapest viable one. This is simple to implement, easy to reason about, and produces optimal or near-optimal orderings when the cheapest next step is clearly distinguished — which the index-aware cost tiers ensure in most cases.

### Rationale

The cost function is keyed on *which* components are bound, not merely *how many*. This matters because two premises with the same number of known components can have very different scan costs depending on index layout. `{the, of}` (129-byte EAV prefix) is fundamentally cheaper than `{the, is}` (97-byte VAE prefix with possible verification overhead).

Greedy is the right starting point because most real queries have a handful of premises where the cost differences between orderings are large enough that the locally cheapest choice at each step is globally optimal. The index-aware tiers amplify these differences (SEGMENT vs SCAN is a 10x gap), so ties that would force greedy into an arbitrary (possibly wrong) choice are expected to be rare.

## Alternatives

### Exhaustive search (Held-Karp DP)

Find the minimum-cost ordering over all N! permutations using dynamic programming over subsets. State is a bitmask of evaluated premises; complexity is O(2^N * N^2).

```
cost(S) = min over Pi in S: cost(S \ {Pi}) + estimate(Pi, bound(S \ {Pi}))
```

This is optimal and DP overhead is small in absolute terms, but adds significant implementation complexity for what is expected to be a margin gain in the common case where (N < 10) the greedy algorithm can often find a near-optimal order, because cost tiers create clear winners at each step.

## Future Improvements

### Hybrid greedy + Held-Karp for tie-breaking

Greedy fails to determine the most optimal order when multiple premises tie on cost, because it picks arbitrarily without considering how each choice's bindings cascade to downstream premises:

```
P1: (person/name, ?person, ?name)       {the} only → SCAN (1000)
P2: (dept/members, ?dept, ?person)       {the} only → SCAN (1000)
P3: (dept/budget, ?dept, ?budget)        {the} only → SCAN (1000)

Greedy picks P1 (arbitrary). Binds ?person.
  P2 → {the, is} READ (200). P3 still {the} → SCAN (1000).
  Total: 1000 + 200 + 1000 = 2200.

P2 first. Binds ?dept and ?person.
  P1 → {the, is} READ (200). P3 → {the, is} READ (200).
  Total: 1000 + 200 + 200 = 1400.
```

When greedy encounters a tie, apply Held-Karp over the tied subset and remaining premises to break it optimally. This gives O(N^2) in the common case and O(2^N * N^2) only when it matters. Planning runs once per adornment and is cached, so planning overhead is negligible against a single network roundtrip.

Source: [notes/query-cost-model.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/query-cost-model.md) at commit `f777fe7c`.
