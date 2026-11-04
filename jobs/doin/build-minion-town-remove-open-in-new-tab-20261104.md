---
role: builder
tier: mentor
posted_at: 2026-11-04T22:49:15Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T22:50:36Z cleared=none -->

---
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Remove the "Open in new tab" links** (maintainer ask). They appear in two places: inside the clip (`#clip-caption` / `#clip-caption-link`, "Clip not loading? Open it in a new tab") and in the bottom bar (`#clip-open`, "Open in new tab"), in `deploy/aws/www/index.html` (lines ~467 and ~476), with the matching text at `deploy/aws/www/shell.js:220` ("Use “Open in new tab”…") and any JS that wires them. Remove the links and their now-dead handlers/CSS/tests, and reword the not-loaded message so it no longer points at a removed control. Small, ship it first. Repo: kriscendobot/minion.town (base: current main; if an open draft PR already covers part of this, build on it or stack on it rather than duplicating). Maintainer interactive-evaluation session, kriskowal, 2026-11-04: get as much as possible DEPLOYED for incremental evaluation; the maintainer will evaluate production results, not diffs (review inversion). Frame against the chrome vision: a dock/gutter of clips, a New Clip zygote, an API-key agent. Deploy through the normal CD path and verify in production with the real-daemon + Playwright recipe (see memory/skills for minion-town-clip browser testing). Do not touch production account data; account resets are a separate maintainer-authorized step.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-04T22:51:15Z
