---
id: design-out-the-hazard
aliases: [design out the hazard, designed out not coordinated around, isolation over locks, isolation beats coordination, per-worktree isolation, bare-repo per-worktree, key state on durable content, tree-hash not commit-message grep, thread the resolved path, lighter cut, ship the smallest thing]
topics: [repository-governance, agent-fleet-orchestration]
---

# design-out-the-hazard

The architectural instinct: *when a hazard is a race or a shared-mutable, prefer a structure where it can't arise over a protocol that carefully avoids it.* jcorbin's unum states it as "the two-runs-racing-onto-one-branch hazard simply does not exist — it's designed out, not coordinated around": the bare-repo / per-worktree reorganization (one worktree per invocation, each on its own branch) made the shared-branch commit race *impossible*, so the realm-wide serial lock could be deleted rather than tuned. Locks, careful ordering, and "call X before Y" are coordination — fragile and easy to regress; isolation is design — the bug class is gone. Two corollaries: **key state on durable, immutable content** (git objects, tree hashes) rather than mutable artifacts (filenames, commit messages, worktree presence) — a tree-hash-keyed signal survives a history rewrite a message-grep does not; and **thread a resolved value through** (a scope path, a worktree path) rather than re-deriving it downstream, since every re-derivation is a fresh chance to derive it wrong. A sibling decision discipline, the **"lighter cut"** (ship the smallest thing capturing most of the value, name-and-defer the heavy version), keeps the same low-blast-radius stance for a self-editing harness. The garden's own push-CAS-as-serialization-point is the same move: the claim race is designed out, not locked around.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [unum--lore-engineering-discipline](../sections/unum--lore-engineering-discipline.md) | Design-out-the-hazard and the lighter cut, alongside fail-loud, cross-reference-not-inline schemas, no dead parsed fields, and seam injection. |
| [unum--garden-vs-devoker-fleet](../sections/unum--garden-vs-devoker-fleet.md) | Both fleets design the claim race out via git-as-serialization-point rather than a shared-branch lock. |

## See also

- [[claim-state-triple]] — the canonical hazard designed out: the shared-branch claim race.
- [[journal-ref-rmw-cas]] — where a race *can't* be structured away, CAS-guard it instead.
- [[log-and-swallow]] — a runtime-discipline sibling from the same engineering-discipline section.
