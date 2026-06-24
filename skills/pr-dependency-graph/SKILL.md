---
created: 2026-05-13
updated: 2026-06-24
author: gardener
---

# Skill: pr-dependency-graph

Read the journal's per-PR dependency registry (`journal2`'s `pr-deps/*.md`) into an adjacency list, and offer queries against it. Canonical for any gardening step that needs to reason about inter-PR ordering: the topo-sort primitive (`[pr-dependency-topo-sort]`) reads it for gauntlet ordering and per-cycle bulletin rendering; dependency-triage and rebase steps read it to detect cycles and discover inter-PR dependencies from PR bodies.

The registry's schema, lifecycle, and write conventions live in `journal2`'s `pr-deps/README.md`. This skill is the *read* side: parse the files, return graph queries.

## Inputs

- The `journal2` worktree root (so the skill can read `pr-deps/`).
- Optional filter: a list of PR identifiers (`<owner>/<repo>#<n>`) to restrict the graph to. The caller passes the canonical-set member list so transitive walks do not chase merged PRs.

A PR identifier in this skill is always the string `<owner>/<repo>#<n>`. When parsing a registry file, the filename `<owner>--<repo>--<n>.md` and the frontmatter's `repo:` + `number:` agree; the parser uses the frontmatter as the source of truth and warns if the filename disagrees.

## State

None. The skill is a pure read over `journal2`'s `pr-deps/*.md`.

## Procedure

1. Enumerate `pr-deps/*.md` (skip `README.md`).
2. For each file, parse the YAML frontmatter. Required fields: `repo` (string), `number` (integer). Optional: `blocked_by` (list of `{repo, number, reason}`), `blocks` (same shape).
3. Build the adjacency list. The canonical edge is `blocked_by`: a `blocked_by` entry on `A` for `B` adds an edge `B → A` (B blocks A; A depends on B). A `blocks` entry on `A` for `C` adds an edge `A → C`. Reciprocity is encouraged but not enforced (see `pr-deps/README.md`); if `A.blocked_by = [B]` and `B` has no `blocks` entry, the edge `B → A` is still recorded once.
4. De-duplicate edges by `(from, to)`. The `reason` from the `blocked_by` side wins on conflict; if only the `blocks` side carried a reason, use that.
5. If `filter` is supplied, prune nodes not in the filter set, then prune edges with either endpoint missing. (Edges touching a pruned node are dropped, not surfaced as orphans; the topo-sort skill's "blockers not in this section" rule handles that case explicitly using the unpruned graph.)

The output of the parse is a stable record:

```python
{
  "nodes": [<pr-id>, ...],                # sorted by (repo, number)
  "edges": [{"from": <pr-id>, "to": <pr-id>, "reason": "<one-line>"}, ...],
  "warnings": ["<one-line>", ...],
}
```

## Helpers

The skill exposes four query helpers; each takes the parse output above plus a PR identifier and returns a list (or, for `detect_cycles`, a list of cycles).

- `blockers_of(pr)`: direct blockers. Returns `[<pr-id>, ...]` such that an edge `<pr-id> → pr` exists. One hop.
- `blockees_of(pr)`: direct blockees. Returns `[<pr-id>, ...]` such that an edge `pr → <pr-id>` exists.
- `walk_blockers(pr)`: transitive blockers via BFS. Returns the set of all PRs reachable by following `→ pr` edges backward, excluding `pr` itself. The result is ordered by BFS layer, then by `(repo, number)` within a layer.
- `detect_cycles()`: every elementary cycle in the graph. Returns `[[<pr-id>, <pr-id>, ...], ...]`, each inner list a cycle starting at the lexicographically smallest member and rotating to a canonical order. Tarjan or Johnson; either is fine.

`detect_cycles` runs in time proportional to (V + E) per simple cycle, which is acceptable for the registries we expect (low hundreds of PRs at most).

## Output shape

The parse record above plus the four query helpers' results. Consumed by `[pr-dependency-topo-sort]` for gauntlet ordering, and by dependency-triage / rebase gardening steps for cycle detection.

## Implementation note

The first caller is `[pr-dependency-topo-sort]`, which runs inside a per-cycle bulletin-rendering gardening step. The implementation can be inline in that step's tooling (a 40 line Python or jq pipeline) or, if it earns its own script, lives under the gardening scripts and is invoked from the step. Either way, the contract above is the public surface.

## Pitfalls

- **Stale registry entries.** A PR that has merged still has its `pr-deps/<file>` until the lifecycle rules in `pr-deps/README.md` retire it. Callers must combine the graph with their own "is this PR still in the canonical set?" check; the graph itself does not know about PR state.
- **Asymmetric declarations.** `A.blocked_by = [B]` without a matching `B.blocks = [A]` is normal; the canonical edge is the `blocked_by` side. Do not warn on absence of reciprocity. Do warn on direct contradiction (e.g. `A.blocked_by = [B]` and `B.blocked_by = [A]` declared at the same time, which is a 2-cycle; surface via `detect_cycles`, not via parse warnings).
- **Cross-repo edges.** A `blocked_by` entry may name a different `repo` than the file's own. Cross-repo edges are first-class. The PR identifier carries the `<owner>/<repo>#<n>` qualification.

## Notes from the field

- _2026-05-13_: first defined. The per-cycle bulletin rendering is the only caller for now; expect dependency-triage callers within a cycle or two once dep-tracking spreads beyond the bulletin.
- _2026-06-24_: migrated into v2. The parse-and-query contract is unchanged; the registry moved from the v1 `journal` branch's `pr-deps/` to `journal2`'s `pr-deps/`, and the callers are now gardening steps (topo-sort for gauntlet ordering, triage/rebase for cycle detection) rather than dispatched journalist/steward/fixer roles.
