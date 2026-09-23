---
title: "Integration with `endo workers` (PR #151)"
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
parent: endo-but-for-bots--llm-designs-rpn--integration-and-phased-implementation
---

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

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
