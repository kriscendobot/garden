---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1371
priority: normal
posted_by: builder
posted_at: 2026-10-01T05:24:56Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: kernel bwrap sandbox slice around claudePath (@endo/claude-sandbox)

Repo: endojs/endo-but-for-bots, base `llm` (after #1371 merges).
Requested by kriskowal's approving review on #1371 ("conduct and build"):
https://github.com/endojs/endo-but-for-bots/pull/1371#pullrequestreview-5375148317 — this builds a named follow-up from
#1371's live-turn evidence comment (https://github.com/endojs/endo-but-for-bots/pull/1371, "Named follow-ups", item 3).

The daemon socket is still reachable by path from the confined claude tree. Build the `@endo/claude-sandbox` / `@endo/sandbox` slice that wraps `claudePath` in bwrap, binding only the broker socket dir and per-spawn files dir and supplying a scratch HOME, so the daemon socket is structurally unreachable. Tests should skip cleanly where bwrap is absent and assert unreachability where present.

Open a DRAFT PR via ensure-pr.sh; cross-link #1371.
