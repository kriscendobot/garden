---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Close the remaining local-verify environment parity exposed after `test:xs` coverage landed in commit 4c1c39ee15. A real run against endojs/endo-but-for-bots@llm used the CI-pinned Moddable 5.0.0 xst successfully, then `@endo/hardened262` failed before exercising Ironhorse because the garden image has no `cargo`; the isolated worktree also has the CI-required `c/moddable` submodule uninitialized. Mirror the `test-xs` workflow prerequisites generically, preserve silent-on-success, and add regression coverage. Evidence blob in project worktree at the originating job was deeb55ea4c940dbbd69335b23b48ed8cac441563.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-28T14:48:46Z
