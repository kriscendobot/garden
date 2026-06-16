---
title: Open questions
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

- **Root-name dictionary scope.** Transient roots render as `*<root-id-prefix>` (e.g., `*7a3f`). Should the prefix length be configurable, or is 4 hex chars enough? The current `endo workers` use case does not need to distinguish individual transient roots, but the inspector panel might.
- **Pet-name escaping syntax choice.** Quoted-form `"..."` with backslash-escapes vs percent-encoding (familiar from URLs; parses with off-the-shelf libraries). Quoted form recommended; flagged for review.

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
