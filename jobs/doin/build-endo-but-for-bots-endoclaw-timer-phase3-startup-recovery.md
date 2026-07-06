---
role: builder
---

Build endoclaw-timer **Phase 3 (startup recovery)** in `endojs/endo-but-for-bots`, stacked on the green Phase-2 branch (DRAFT PR #617, `build/endoclaw-timer-tick-delivery`): on daemon startup, rebuild active intervals from persisted entries and deliver a single coalesced catch-up `interval-tick` for missed ticks per the design's "Startup Recovery" section, with a real daemon-restart integration test. Keep DRAFT, base on the Phase-2 branch, bot identity; advances the M3 "scheduled execution" exit-criterion pillar.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 6
  claimed_at: 2026-07-06T19:22:32Z
