---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: pr-dependency-topo-sort

Stable topological sort of a list of PR identifiers against a dependency graph, with a documented tie-break and an explicit cycle-handling rule. Consumed when ordering rows within a milestone bin (for example, by whatever producer renders a roadmap or pending-review bulletin).

The dependency graph is produced by [pr-dependency-graph](../pr-dependency-graph/SKILL.md). This skill is the ordering algorithm; that skill is the registry it consumes.

## Inputs

- `prs`: an ordered list of PR identifiers (`<owner>/<repo>#<n>`). The caller's bin; ordering is the input order but is not load-bearing (a stable sort is fine).
- `graph`: the parse output from [pr-dependency-graph](../pr-dependency-graph/SKILL.md) (nodes, edges, warnings). Edges are `from → to` meaning "`from` blocks `to`" (equivalently, "`to` is blocked by `from`").

## State

None.

## Procedure

1. Restrict the graph to the input set: keep only edges where both endpoints are in `prs`. Call this `local_edges`.
2. Compute in-degree per PR over `local_edges`.
3. Kahn's algorithm:
   a. Initialize the work queue with every PR whose in-degree is zero, ordered by `(repo, number)` ascending (the tie-break).
   b. Pop the smallest PR. Append to the output. Decrement the in-degree of each neighbor (each `popped → x` edge's `x`). When a neighbor's in-degree reaches zero, insert it into the work queue preserving the `(repo, number)` ordering.
   c. Repeat until the queue empties.
4. If the output's length equals `len(prs)`, return it. This is the stable topo order with the documented tie-break.
5. If the output is shorter, the remaining PRs participate in one or more cycles. Do not silently render either order. Surface the cycle:
   a. Compute `detect_cycles()` on the local graph.
   b. Return a structured failure: `{"ordered": <partial>, "cycle_members": <set of PRs in any cycle>}`.
   c. The caller raises the contradiction to the maintainer through the message bus (`send-msg.sh role/liaison …` or the directed maintainer channel per [message-bus](../message-bus/SKILL.md)), naming the cycle members, and stops rendering the affected section. Do not fall back to "render in input order and hope"; the maintainer needs to see the contradiction.

## Cycle-handling rule

A cycle in the declared graph is a registry bug, not a sort bug. The remediation is human:

- The maintainer (or a role authorized to write `pr-deps` registry entries) edits one of the entries to remove the contradicting edge, with a one-line `reason` change explaining why.
- The next render re-reads the graph and the cycle is gone.

Until the cycle is resolved, the affected bin renders as `(none rendered: PR dependency cycle, see message)` between the section's delimiters, with the bus message referenced from the run's summary. Rendering stops cleanly; it does not partial-render a misordered bin.

## "Blockers not in this section" rule

A PR whose declared blockers are all *outside* the bin (e.g., they are merged, or they live in another milestone) has effective in-degree zero within the local graph. By construction (step 1 prunes edges with either endpoint absent), this falls out: such a PR enters the work queue in the first batch and sorts to the top of the bin by the `(repo, number)` tie-break.

This is the rule named as "top-of-bin for PRs whose deps are not in the same section."

## Output shape

Success:

```python
{"ordered": [<pr-id>, ...]}   # length == len(prs); stable; deterministic.
```

Failure (cycle detected):

```python
{
  "ordered": [<pr-id>, ...],          # the prefix Kahn produced before the cycle.
  "cycle_members": [<pr-id>, ...],    # every PR that participates in any cycle.
}
```

The caller distinguishes by checking `"cycle_members"`.

## Determinism

Two runs with byte-identical inputs produce byte-identical orderings. This is load-bearing for any "idempotent rewrites" rule: a render that classifies the same set into the same bins must produce a byte-identical bulletin diff against the prior run. Stable tie-break (`(repo, number)` ascending) and stable insertion into the work queue together suffice.

## Pitfalls

- **Mutating the input.** Do not sort `prs` in place; the caller's row metadata (links, parentheticals) is keyed off the input ordering of equivalent rows. Use the output ordering to *select* rows, not to *transform* them.
- **Self-loops.** A `blocked_by` entry naming the file's own PR is a 1-cycle. Treat as a cycle (surface via `detect_cycles`); do not silently drop.
- **Disconnected components.** Common. Kahn's handles them naturally; each component contributes its own zero-in-degree starts to the work queue, all interleaved by the tie-break.

## Notes from the field

- _2026-05-13_: first defined as the structural fix for kriskowal's directive on endojs/endo-but-for-bots#128 ("consider sorting PRs topologically on their dependency graph"). The duct-tape annotation in the bulletin (the `depends on #160` parenthetical on the #128 row) is the predecessor; this skill is the replacement.
- _2026-06-24_: migrated to v2. The algorithm is unchanged; only the cycle-surfacing path was rewired from a v1 `message`-to-liaison journal entry to the v2 message bus.
