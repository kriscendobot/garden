---
role: builder
---

Build Phase 4 (Host Integration) of the `endoclaw-timer` design on `endojs/endo-but-for-bots` (base `llm`): add `makeIntervalScheduler()` to `HostInterface` and implement it in `host.js`, add `pause()`/`resume()`/`revoke()` to `IntervalControl`, and wire the `endo interval list|pause|resume <agent>` CLI commands — completing the daemon-graduated scheduler (Phases 1–3 already landed via PRs #609/#619) so agents gain the scheduled-execution capability M3's exit criterion requires.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 15
  claimed_at: 2026-07-11T19:46:33Z
