---
role: builder
tier: mentor
handler-budget-role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-27T09:19:04Z cleared=none -->

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Wear the builder role: build the design `designs/daemon-guest-bot-incarnation.md` from endojs/endo-but-for-bots PR #1227 (merged into `llm` by the preceding conductor child), per kriskowal's "Please conduct and build" (review https://github.com/endojs/endo-but-for-bots/pull/1227#pullrequestreview-5329319726). Implement the design's bounded first increment on top of what already exists on `origin/llm` (guestPins/hostPins, `planes` in MakeAgentOptions): mailbox-delivery reincarnation of pinned values with single-flight, restart recovery, backoff/breaker and the fake-bot tests the design calls for. Open a DRAFT PR against `llm` via ensure-pr.sh, referencing #1227 and kriskowal/garden#89 item 6. Stop at the draft PR (no gauntlet).

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-27T09:28:53Z
