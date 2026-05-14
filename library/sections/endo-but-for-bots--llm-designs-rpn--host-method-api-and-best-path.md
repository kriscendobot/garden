---
title: Host method API + best-path selection + errors
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, capability-security]
status: current
notes: The "host-only, not guest-accessible" choice matches `daemon-retention-paths.md` § Why host-only — guests can't enumerate retention paths through caps they don't own. The bulk return shape `Array<RetentionPath>` (one path per target, not one-per-target-array) is the load-bearing API decision; per-target multi-path use case is the inspector panel, served by the per-target API in the sibling design. The selection rule's lex-smallest tiebreaker is for determinism.
---

> Abstract: **One method added to `EndoHost`** (and the corresponding `Mail` interface). **Host-only** — guests cannot enumerate retention paths through caps they don't own. `listRetentionPaths(targetIds: Array<FormulaIdentifier|string>): Promise<Array<RetentionPath>>` — snapshot the best retention path for many targets in one call; one path per input, in input order; a target with no retention path returns an empty array at that position. **Bulk return shape is `Array<RetentionPath>` (one path per target), NOT `Array<RetentionPath[]>` (a list per target)** — the single-target "all paths" use case is the inspector panel, served by per-target `listRetentionPaths(locator): Promise<RetentionPath[]>` in `daemon-retention-paths.md`. **The daemon does not host any string-rendering method**: typed return is the shared canonical form; CLI renders with the string notation; chat UI renders with markup directly from the typed value. **Best-path selection rule** (when multiple paths exist): (1) prefer persistent-root paths over transient; (2) prefer paths with at least one pet-name edge over field-only paths; (3) prefer the shortest path; (4) prefer the lex-smallest rendered notation. Selection happens on the host because it requires the same graph walk that produced the candidates. **Errors**: invalid id/locator returns empty `RetentionPath` (length 0); not an error — matches the row-oriented case where tenants may have been collected between calls. Target whose formula is unknown to the local host (remote-only) returns the same empty path.

## Host method API

One method is added to the `EndoHost` interface (and the corresponding `Mail` interface). It is host-only; guests cannot enumerate retention paths through capabilities they do not own (the rationale matches `daemon-retention-paths.md` § "Why host-only").

```typescript
interface EndoHost {
  /**
   * Snapshot the best retention path for many targets in one call.
   * `targetIds` may be formula identifiers or locator strings.
   * Returns one path per input, in input order.
   * A target with no retention path returns an empty array (length 0)
   * at that position.
   * "Best" is defined by the selection rule below.
   */
  listRetentionPaths(
    targetIds: Array<FormulaIdentifier | string>,
  ): Promise<Array<RetentionPath>>;
}
```

The bulk return is `Array<RetentionPath>` (one path per target), not `Array<RetentionPath[]>` (a list of paths per target). The single-target "all paths" use case (the inspector panel) is served by the per-target `listRetentionPaths(locator): Promise<RetentionPath[]>` defined in `daemon-retention-paths.md`; this bulk method exists for the row-oriented surfaces that need exactly one path per target.

The daemon does not host any string-rendering method. The typed return is the shared canonical form; the CLI renders with the string notation defined below; the chat UI renders with markup directly from the typed value.

### Best-path selection rule

When a target has multiple retention paths, the host picks one as the "best" by:

1. Prefer paths rooted at a persistent root (e.g., `@endo`, `@known-peers-store`) over paths rooted at a transient root.
2. Prefer paths that contain at least one pet-name edge over paths that consist only of field edges (the latter are present but not user-named).
3. Prefer the shortest path among those tied on (1) and (2).
4. Prefer the lexicographically smallest path (by rendered notation) among those tied on (1), (2), and (3).

Selection happens on the host because it requires the same graph walk that produced the candidate paths; folding it into the same call avoids serializing every candidate.

### Errors

- An invalid id or locator string in `targetIds` produces an empty `RetentionPath` (length 0) at that position; it is not an error. This matches the row-oriented use case where some tenants may have been collected between the `listWorkerTenants` call and the `listRetentionPaths` call.
- A target whose formula is unknown to this host (a remote-only reference) returns the same empty `RetentionPath`.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
