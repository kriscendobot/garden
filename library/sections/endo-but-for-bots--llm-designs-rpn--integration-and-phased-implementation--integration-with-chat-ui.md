---
title: Integration with chat UI
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

The chat tenant chip (rendered for each capability inside a worker tile, value tile, or inspector panel) consumes the same typed `RetentionPath` returned by `listRetentionPaths`. The chip renders the path as a sequence of sub-chips, each styled by edge kind and bound to its segment's `locator`:

- Root segments: bold, blue. Persistent vs transient distinguished by an icon, not by the `@` / `*` prefix used in the CLI string.
- Pet-name edges: bold, default text color.
- Field edges: gray, italic.
- Retention edges: gray, with a hover tooltip showing the full peer id and pet name (if any).
- Type suffix: small caps, muted.

Each sub-chip is clickable and opens the inspector for the segment's `locator`. The chat UI does not parse the CLI string notation; it walks the typed `RetentionPath` directly. The CLI string notation and the chat markup rendering are two independent renderings of the same typed value; the typed `RetentionPath` is the backbone that keeps them from drifting.

The user-facing copy operation in the chat UI yields the CLI string notation (rendered on the client from the typed value) so the chip text round-trips through copy and paste into a CLI invocation.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
