---
role: builder
tier: mentor
posted_at: 2026-11-04T22:49:16Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T23:38:43Z cleared=none -->

---
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Build the empty-account gutter, ordered clips and context menu as designed** by the preceding design job (`designs/` in kriscendobot/minion.town; read it first; implement exactly what it specifies, increment by increment, smallest first, deploying each). Include: no example clips for an empty account; "+" creating clips only in the gutter; the ordered pet-name directory/order tracking; the context-click menu (delete, clone, freeze, …) wired to the lifecycle authority; tests including a real-daemon/Playwright proof in production-like conditions. If the design left a blocking open question, build the unblocked part and report the rest. Repo: kriscendobot/minion.town (base: current main; if an open draft PR already covers part of this, build on it or stack on it rather than duplicating). Maintainer interactive-evaluation session, kriskowal, 2026-11-04: get as much as possible DEPLOYED for incremental evaluation; the maintainer will evaluate production results, not diffs (review inversion). Frame against the chrome vision: a dock/gutter of clips, a New Clip zygote, an API-key agent. Deploy through the normal CD path and verify in production with the real-daemon + Playwright recipe (see memory/skills for minion-town-clip browser testing). Do not touch production account data; account resets are a separate maintainer-authorized step.

