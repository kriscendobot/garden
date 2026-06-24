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
kind: index
section_count: 5
---

> Abstract: **Alternatives considered**: (1) formula id `{number}:{node}` — unambiguous + type-able but two 64-char hex strings; carries no "why is this alive" info; rejected as primary surface, retained as `--full-ids` secondary form. (2) Pet-name path verbatim `alice/inbox/2026-05` — familiar but only describes one reachability, can't express field edges or peer retention or non-pet-named intermediaries; a worker held by `:worker` field on a guest has no pet-name path at all; rejected, retained as substrate for `/<name>` segments. (3) JSON shape inline `{"root":"endo",...}` — unambiguous + renderable but not type-able + reads poorly inline; rejected as default, retained for `--json`. (4) Unix-path-style throughout (`/endo/pins/shared-file`) — natural to Unix users but loses pet-name-vs-field distinction (both `/`-segments); rejected, `:` prefix is load-bearing. (5) Render on the daemon (`describeRetentionPaths`) — earlier draft proposed daemon-side string method for canonicality; rejected because rendering is a consumer concern (CLI notation has no value to chat UI; would force re-parsing of CLI strings to find segment boundaries). **Decisions**: snapshot semantics accepted (pet names move; best path may change between invocations); `--json` includes both locator and typed path so scripts can match on locator for stability. Bulk return is typed `RetentionPath`, not rendered strings — consumer flexibility wins over shared canonicality at daemon boundary. Merged groups render with `+mergeKind`, not count. **Open questions**: transient-root prefix length configurable (4 hex chars enough for diagnosability?); pet-name escaping syntax (quoted form recommended; percent-encoding alternative flagged). **Affected packages**: `packages/daemon` (surface `locator` + `mergeKind` + `rootKind` on RetentionPathSegment; add bulk host method; export updated types), `packages/cli` (new `retention-path-notation.js` renderer + parser; wire `endo workers` and `endo paths`), `packages/chat` (tenant chip with typed-value rendering, copy yields CLI notation). **Test plan**: unit daemon (positional preservation, transient/unreachable, merged-group, locator match), unit CLI (notation round-trip on representative paths including quoted pet names), integration (two-daemon best-path selection picks persistent over retention), CLI smoke (workers renders notation; --json typed path), chat (all four segment kinds rendered, copy round-trips).

Sections:

- [Alternatives considered](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions--alternatives-considered.md)
- [Decisions](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions--decisions.md)
- [Open questions](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions--open-questions.md)
- [Affected packages](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions--affected-packages.md)
- [Test plan](endo-but-for-bots--llm-designs-rpn--alternatives-and-decisions--test-plan.md)

Source: [designs/retention-path-notation.md](https://github.com/endojs/endo-but-for-bots/blob/dea3e7186cb482a5fc9c368d0cc95355e3f0271d/designs/retention-path-notation.md) at commit `dea3e718` on branch `llm`.
