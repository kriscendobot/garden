---
role: builder
---

Builder job on `endojs/endo-but-for-bots`: implement daemon-agent-tools **Phase 2 — Shell capability** per the reconciled design (`designs/daemon-agent-tools.md`, PR #611 phasing) on base `llm`. Add the net-new `provideShell(mountCap, petName, policy)` daemon formula mirroring `provideGit` (writable-mount-only, cwd via `EndoHost.provideHostPath`, formula-owned allowlist/env/timeout policy, argv-array `exec` through genie's existing `Spawner`/`makeHostSpawner` seam), plus `makeShellTool` in `endo-agent-tools` and hardening tests; open a DRAFT PR.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 12
  claimed_at: 2026-07-06T15:06:37Z
