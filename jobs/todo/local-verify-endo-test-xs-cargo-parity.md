---
role: builder
tier: mentor
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T20:54:39Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Close the remaining local-verify environment parity exposed after `test:xs` coverage landed in commit 4c1c39ee15. A real run against endojs/endo-but-for-bots@llm used the CI-pinned Moddable 5.0.0 xst successfully, then `@endo/hardened262` failed before exercising Ironhorse because the garden image has no `cargo`; the isolated worktree also has the CI-required `c/moddable` submodule uninitialized. Mirror the `test-xs` workflow prerequisites generically, preserve silent-on-success, and add regression coverage. Evidence blob in project worktree at the originating job was deeb55ea4c940dbbd69335b23b48ed8cac441563.
