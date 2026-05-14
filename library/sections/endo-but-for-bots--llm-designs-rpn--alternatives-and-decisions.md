---
title: Alternatives considered + Decisions + Open questions + Test plan
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
---

> Abstract: **Alternatives considered**: (1) formula id `{number}:{node}` — unambiguous + type-able but two 64-char hex strings; carries no "why is this alive" info; rejected as primary surface, retained as `--full-ids` secondary form. (2) Pet-name path verbatim `alice/inbox/2026-05` — familiar but only describes one reachability, can't express field edges or peer retention or non-pet-named intermediaries; a worker held by `:worker` field on a guest has no pet-name path at all; rejected, retained as substrate for `/<name>` segments. (3) JSON shape inline `{"root":"endo",...}` — unambiguous + renderable but not type-able + reads poorly inline; rejected as default, retained for `--json`. (4) Unix-path-style throughout (`/endo/pins/shared-file`) — natural to Unix users but loses pet-name-vs-field distinction (both `/`-segments); rejected, `:` prefix is load-bearing. (5) Render on the daemon (`describeRetentionPaths`) — earlier draft proposed daemon-side string method for canonicality; rejected because rendering is a consumer concern (CLI notation has no value to chat UI; would force re-parsing of CLI strings to find segment boundaries). **Decisions**: snapshot semantics accepted (pet names move; best path may change between invocations); `--json` includes both locator and typed path so scripts can match on locator for stability. Bulk return is typed `RetentionPath`, not rendered strings — consumer flexibility wins over shared canonicality at daemon boundary. Merged groups render with `+mergeKind`, not count. **Open questions**: transient-root prefix length configurable (4 hex chars enough for diagnosability?); pet-name escaping syntax (quoted form recommended; percent-encoding alternative flagged). **Affected packages**: `packages/daemon` (surface `locator` + `mergeKind` + `rootKind` on RetentionPathSegment; add bulk host method; export updated types), `packages/cli` (new `retention-path-notation.js` renderer + parser; wire `endo workers` and `endo paths`), `packages/chat` (tenant chip with typed-value rendering, copy yields CLI notation). **Test plan**: unit daemon (positional preservation, transient/unreachable, merged-group, locator match), unit CLI (notation round-trip on representative paths including quoted pet names), integration (two-daemon best-path selection picks persistent over retention), CLI smoke (workers renders notation; --json typed path), chat (all four segment kinds rendered, copy round-trips).

## Alternatives considered

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

## Decisions

- **Path stability across formulations.** Snapshot semantics are accepted for this iteration. Pet names move; a tenant's best path may change between two `endo workers` invocations. The `--json` payload includes both the locator and the typed `RetentionPath`, so a script that wants stability across snapshots matches on the locator. Followers and subscribers (a `followRetentionPaths`-style subscription for the bulk return) are deferred to a later design.
- **Bulk return shape.** The host returns typed `RetentionPath`, not rendered strings. Consumer flexibility wins over shared canonicality at the daemon boundary. The CLI owns its string notation; the chat UI owns its markup rendering; the typed shape is the contract that keeps them consistent.
- **Group rendering.** Merged groups render with the merge kind (`+resolver`, `+handle`) rather than just a count. The `mergeKind` field on `RetentionPathSegment` carries this information from `graph.js`'s union-find.

## Open questions

- **Root-name dictionary scope.** Transient roots render as `*<root-id-prefix>` (e.g., `*7a3f`). Should the prefix length be configurable, or is 4 hex chars enough? The current `endo workers` use case does not need to distinguish individual transient roots, but the inspector panel might.
- **Pet-name escaping syntax choice.** Quoted-form `"..."` with backslash-escapes vs percent-encoding (familiar from URLs; parses with off-the-shelf libraries). Quoted form recommended; flagged for review.

## Affected packages

- `packages/daemon`: surface the `locator`, `mergeKind`, and `rootKind` fields on `RetentionPathSegment`; add the bulk `listRetentionPaths(targetIds)` host method; export updated types.
- `packages/cli`: new `retention-path-notation.js` (renderer + parser); `endo workers` calls the bulk method and renders with the notation; `endo paths` prints using the new renderer.
- `packages/chat`: tenant chip component renders the typed `RetentionPath` directly with markup; copy yields the CLI notation rendered on the client.

## Test plan

- Unit (daemon): bulk method positional preservation; transient-only and unreachable cases; merged-group segments expose `mergeKind`; per-segment `locator` matches the group representative.
- Unit (CLI): notation render + parse round-trip on representative paths (single-pet-name, multi-segment with field edges, with retention edge, with merged group, transient-rooted, root-only, pet name with `:` and spaces requiring quoting).
- Integration: two-daemon test asserting `listRetentionPaths` for a peer-shared target picks the local persistent-rooted path over the cross-peer retention path per the best-path rule.
- CLI: smoke test `endo workers` renders notation strings; `--json` payload includes typed `retentionPath`.
- Chat: tenant chip renders all four segment kinds from the typed shape; copy yields the CLI notation string verbatim.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
