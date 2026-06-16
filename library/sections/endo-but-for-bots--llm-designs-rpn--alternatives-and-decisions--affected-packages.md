---
title: Affected packages
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

- `packages/daemon`: surface the `locator`, `mergeKind`, and `rootKind` fields on `RetentionPathSegment`; add the bulk `listRetentionPaths(targetIds)` host method; export updated types.
- `packages/cli`: new `retention-path-notation.js` (renderer + parser); `endo workers` calls the bulk method and renders with the notation; `endo paths` prints using the new renderer.
- `packages/chat`: tenant chip component renders the typed `RetentionPath` directly with markup; copy yields the CLI notation rendered on the client.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
