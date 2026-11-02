---
posted_at: 2026-11-02T09:54:32Z
arc: minion-town-git-remote
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Designer step for endojs/endo-but-for-bots (base branch `llm`): write the new `designs/daemon-git-clone.md` named in `designs/daemon-git-next-steps.md` § Open Work. It covers `provideGitClone` repository bootstrap (mount creation, endpoint policy, sealed credential authority, and clone into the new mount, returning `EndoMount` + `Git`) and the commit-author / identity boundary as a capability shape. It builds on `daemon-git-remotes` § Repository Bootstrap, and it should put any unresolved questions in an Open questions section.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T10:30:23Z
