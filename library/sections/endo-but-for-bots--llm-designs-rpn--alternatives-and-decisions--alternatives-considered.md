---
title: Alternatives considered
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
notes: The "render on the daemon" alternative would have forced chat UI to re-parse CLI strings to discover segment boundaries — a wrong abstraction. The decision to render on the consumer (CLI string vs chat markup) means the typed `RetentionPath` is the canonical backbone. Snapshot semantics: pet names move, so a tenant's best path may change between two `endo workers` invocations; `--json` includes both locator and typed path, so scripts that want stability match on locator.
parent: endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions
---

### Use the formula identifier as the path

`{number}:{node}` is unambiguous and type-able, but is two 64-character hex strings. It carries no information about *why* the formula is alive, which is the question the operator is asking when they reach for `endo workers`. Rejected as the primary surface; retained as a secondary form available via `--full-ids`.

### Use the pet-name path verbatim (`alice/inbox/2026-05`)

Pet-name paths are already used by the CLI and are familiar. However, they only describe *one* way the value is reachable (through nested directories under one root), and they cannot express field edges, peer retention, or paths that pass through a non-pet-named intermediary. A worker held by the host's `:worker` field on a guest formula has no pet-name path at all. Rejected as insufficient; retained as the *substrate* for the `/<name>` segments in the notation.

### Use a JSON shape inline

`{"root":"endo","segments":[{"type":"pet","name":"pins"},...]}` is unambiguous and renderable, but is not type-able and reads poorly in a single-line CLI row. JSON is appropriate for `--json` output and is what the bulk method returns; inline rendering is the CLI notation's job. Rejected as a default for human-facing surfaces.

### Use a Unix-path-style notation throughout

`/endo/pins/shared-file` reads naturally to Unix users, but loses the distinction between pet-name edges and field edges (both look like `/`-segments). A field name like `worker` would collide with a pet name `worker` sharing the same store level. Rejected; the `:` prefix on field segments is load-bearing.

### Render on the daemon (`describeRetentionPaths`)

An earlier draft proposed a host method `describeRetentionPaths` that returned rendered notation strings instead of typed paths. Rationale was shared canonicality: one rendering site, no risk of drift between CLI and chat. Rejected: rendering is a consumer concern. The CLI's notation has no value to the chat UI (which renders with markup), and a daemon-side string method would force the chat UI to re-parse CLI strings just to discover segment boundaries it could have read straight from the typed value. The typed `RetentionPath` is the backbone that prevents drift; the two renderings are sibling consumers of that backbone.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
