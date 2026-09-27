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

<!-- garden-transient-elapsed: kind=signature through=0 values=14 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-09-27T09:43:08Z -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T09:55:08Z
