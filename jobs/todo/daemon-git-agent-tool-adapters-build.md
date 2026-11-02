---
posted_at: 2026-11-02T10:34:48Z
arc: minion-town-git-remote
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step in endojs/endo-but-for-bots (base `llm`): implement the agent tool adapters over `Git` and `GitRemote`, which is the first open item in the `daemon-git-next-steps` roadmap (wired through PR #416's agent-tools design). They expose `status`/`diff`/`add`/`commit`/`fetch`/`pull`/`push` as tool calls over a host-chosen mount, endpoint and credential, converting path inputs to `EndoMountEntry` at the boundary. Open a DRAFT PR with tests. If an equivalent adapter already exists on `llm`, build only the remaining gap.
