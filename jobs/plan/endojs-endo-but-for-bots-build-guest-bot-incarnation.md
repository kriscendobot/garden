---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr1227-review-5329319726-chain
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-27T08:30:30Z
---

---
handler-budget-role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

Wear the builder role: build the design `designs/daemon-guest-bot-incarnation.md` from endojs/endo-but-for-bots PR #1227 (merged into `llm` by the preceding conductor child), per kriskowal's "Please conduct and build" (review https://github.com/endojs/endo-but-for-bots/pull/1227#pullrequestreview-5329319726). Implement the design's bounded first increment on top of what already exists on `origin/llm` (guestPins/hostPins, `planes` in MakeAgentOptions): mailbox-delivery reincarnation of pinned values with single-flight, restart recovery, backoff/breaker and the fake-bot tests the design calls for. Open a DRAFT PR against `llm` via ensure-pr.sh, referencing #1227 and kriskowal/garden#89 item 6. Stop at the draft PR (no gauntlet).
