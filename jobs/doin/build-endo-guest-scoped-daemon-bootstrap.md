---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-01T08:46:17Z cleared=none -->

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: guest-scoped daemon bootstrap for the confined-turn harness

Repo: endojs/endo-but-for-bots, base `llm` (after #1371 merges).
Requested by kriskowal's approving review on #1371 ("conduct and build"):
https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317 — this builds a named follow-up from
#1371's live-turn evidence comment (https://github.com/endojs/endo-but-for-bots/pull/1371, "Named follow-ups", item 4).

The broker resolves the guest through the root host's `lookupById`, so the harness holds a host-level connection. Provide a daemon-issued bootstrap already scoped to one guest (e.g. ocapn offset-0 gateway over the UDS) and switch `runConfinedTurn`/`startGuestBroker` to it without changing the broker's contract. Design-first if the shape is unclear (designs/endo-guest-stdio-mcp.md).

Open a DRAFT PR via ensure-pr.sh; cross-link #1371.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T09:16:58Z
