---
posted_at: 2026-11-02T12:44:29Z
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder job on endojs/endo-but-for-bots (base `llm`): implement the worked end-to-end reference flow from designs/daemon-git-next-steps.md § Open Work as a regression test. The flow is prompt → branch off `llm` via `Git` → edit via `EndoMount` → status/diff/commit → push a draft-PR branch via `GitRemote` → inspect the pushed ref via `filesystemAt`, using the agent tool adapters from `daemon-git-agent-tool-adapters-build` once that PR is up (rebase onto it if it is still open).

<!-- garden-transient-elapsed: kind=signature through=0 values=1063 -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T13:17:47Z
