---
slug: endo-fetch
repository: endo-but-for-bots
status: In Progress
size: M
milestone: M3
depends_on: []
pr: endo-but-for-bots#1588
created: 2026-07-13
updated: 2026-11-02
source: reconciled from origin/llm designs/endo-fetch.md
---

# `@endo/fetch` and `@endo/confined-fetch`: Outbound HTTP Plugins

Supersedes [endoclaw-network-fetch](endoclaw-network-fetch.md). The design narrative
is `designs/endo-fetch.md` on `llm`.

## Implementation status (reconciled 2026-11-02)

- Landed: the capability in #566 and the first plugin (Phases 1-3) in #723.
- In flight: draft #1588 carries the split into unconfined and confined plugins and
  the confined-worker Timer (Phase 4). Do not build these again; a new build job
  would duplicate that PR.
- Blocking #1588: its gauntlet halted on 2026-10-31 at fix round 1 on an unrelated
  `packages/sandbox` failure on the Ubuntu 26.04 runner. The sandbox fixes are open
  as #1542, #1566, and #1591.
