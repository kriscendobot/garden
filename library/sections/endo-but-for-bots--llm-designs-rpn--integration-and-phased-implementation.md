---
title: Fast collection + integrations (endo workers, chat UI) + phased implementation
source: designs/retention-path-notation.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: dea3e7186cb482a5fc9c368d0cc95355e3f0271d
source_date: 2026-05-10
source_authors: [Kriscendo Bot]
ingested: 2026-05-14
ingested_by: scholar
topics: [daemon, tooling]
status: current
notes: No reverse-lookup index added in this iteration — the existing `groupInEdges` map serves as the substrate; what was missing was an external API. Memoization layer keyed by (group, depth) is deferred behind profiling — the working set per `endo workers` call is bounded by tenant count (typically tens). The host holds the formula-graph lock for the duration of the bulk call, so memoization is correct.
---

> Abstract: **Fast collection**: the existing `listRetentionPaths(targetId)` in `graph.js` is BFS upstream through `groupInEdges`; cost linear in path count × average path length. Bulk variant walks each target independently; shared upstream work not memoized in this iteration (working set per `endo workers` typically tens of tenants). If profiling shows shared-upstream dominance, followup is a memoization layer keyed by `(group, depth)` — correct because the graph cannot mutate during the call (host holds the formula-graph lock). **No reverse-lookup index added** — `groupInEdges` already serves as the substrate; what was missing was the external API. **Integration with `endo workers` (PR #151)**: before — `worker-7a3f\n  shared-file (eval)\n  inbox-mailhub (mail-hub)`. After — `worker-7a3f\n  @endo/pins/shared-file#eval\n  @endo/inbox:mailHub#mail-hub`. `workers.js` calls `listRetentionPaths(tenantIds)` once per worker (or once total for all workers' tenants). Left-margin pet name dropped; rendered notation is the canonical identifier. `--json` form gains a `retentionPath` field per tenant containing the typed value. **Integration with chat UI**: tenant chip consumes typed `RetentionPath`, renders as sub-chips styled by edge kind, each bound to its segment's `locator`. Root segments bold blue; pet-name edges bold default color; field edges gray italic; retention edges gray with hover tooltip showing full peer id + pet name; type suffix small-caps muted. Each sub-chip clickable → opens inspector for the segment's locator. **Copy yields the CLI string notation** (rendered on client from typed value) so chip text round-trips through copy-paste into a CLI invocation. **Phased implementation**: (1) Typed bulk method + new fields on segment + unit tests; (2) CLI `retention-path-notation.js` with `renderRetentionPath`/`parseRetentionPath`, wire `endo workers` + `endo paths`; (3) Chat tenant chip with markup rendering + click-to-inspect + copy-to-CLI-string.

## Fast collection: indexing and cost

The existing `listRetentionPaths(targetId)` in `graph.js` is a BFS upstream from the target group through `groupInEdges`; cost is linear in the number of paths times the average path length. For the bulk variant, the daemon walks each target independently; shared upstream work is not memoized in this iteration because the working set per `endo workers` call is bounded by the tenant count (typically tens, not thousands).

If profiling shows shared upstream work dominating, the followup is a memoization layer keyed by `(group, depth)` that caches partial upstream walks across targets within a single bulk call. The memoization is correct because the graph cannot mutate during the call; the host holds the formula-graph lock for the duration.

No reverse-lookup index is added in this iteration. The `groupInEdges` map already serves as the reverse-lookup substrate; the missing piece was an externally accessible API and the shape of the bulk return.

## Integration with `endo workers` (PR #151)

The current PR #151 row format is:

```
worker-7a3f
  shared-file (eval)
  inbox-mailhub (mail-hub)
```

After this design lands, `workers.js` calls `listRetentionPaths(tenantIds)` once per worker (or once total for all workers' tenants), receives an `Array<RetentionPath>`, and renders each path with the CLI notation:

```
worker-7a3f
  @endo/pins/shared-file#eval
  @endo/inbox:mailHub#mail-hub
```

The row's left margin (the tenant's discovered pet name) is dropped; the rendered notation is the canonical identifier and includes any pet-name edges.

The `--json` form gains a `retentionPath` field per tenant containing the typed `RetentionPath`:

```json
{
  "name": "shared-file",
  "type": "eval",
  "id": "...:0000...",
  "retentionPath": [
    { "locator": "...", "groupMembers": ["..."], "rootKind": "persistent", "labels": ["pet:pins"] },
    { "locator": "..." }
  ]
}
```

JSON consumers read the typed shape directly; the CLI string is for the human-facing surface.

## Integration with chat UI

The chat tenant chip (rendered for each capability inside a worker tile, value tile, or inspector panel) consumes the same typed `RetentionPath` returned by `listRetentionPaths`. The chip renders the path as a sequence of sub-chips, each styled by edge kind and bound to its segment's `locator`:

- Root segments: bold, blue. Persistent vs transient distinguished by an icon, not by the `@` / `*` prefix used in the CLI string.
- Pet-name edges: bold, default text color.
- Field edges: gray, italic.
- Retention edges: gray, with a hover tooltip showing the full peer id and pet name (if any).
- Type suffix: small caps, muted.

Each sub-chip is clickable and opens the inspector for the segment's `locator`. The chat UI does not parse the CLI string notation; it walks the typed `RetentionPath` directly. The CLI string notation and the chat markup rendering are two independent renderings of the same typed value; the typed `RetentionPath` is the backbone that keeps them from drifting.

The user-facing copy operation in the chat UI yields the CLI string notation (rendered on the client from the typed value) so the chip text round-trips through copy and paste into a CLI invocation.

## Phased implementation

### Phase 1: Typed bulk method

- Add `host.listRetentionPaths(targetIds)` returning `Array<RetentionPath>`, with the per-segment `locator` and `mergeKind` fields surfaced from `graph.js`.
- Surface the new fields on `RetentionPathSegment` from `daemon-retention-paths.md`.
- Unit tests: best-path selection, positional preservation, missing/invalid ids, transient-only vs persistent-rooted, merged-group segments.

### Phase 2: CLI string notation and integrations

- Add `packages/cli/src/retention-path-notation.js` exporting `renderRetentionPath(path) -> string` and `parseRetentionPath(string) -> RetentionPath | undefined`. The parser is included so the CLI can validate hand-typed paths in a future search-by-path feature; the bulk method does not depend on it.
- Wire `endo workers` to `listRetentionPaths` and render with the notation.
- Add `endo paths <name-or-locator>` (defined in `daemon-retention-paths.md`) and have it print using the notation defined here.

### Phase 3: Chat tenant chip

- Tenant chip component reads the typed `RetentionPath` and renders per the styling above.
- Click on a sub-chip opens the inspector for that segment's locator.
- Copy yields the CLI notation, rendered on the client.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
