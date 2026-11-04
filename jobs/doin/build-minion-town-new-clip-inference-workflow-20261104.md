---
role: builder
tier: mentor
posted_at: 2026-11-04T22:49:16Z
handler-timeout: 3600
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-11-04T23:50:39Z cleared=none -->

---
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Integrate New Clip with the inference workflow** (maintainer, 2026-11-04): from New Clip, (a) add an inference API key for a provider (user-level config: configuring once enables all future clips; build on #229 provider management UI and #244 API-key agent step, behind its flag until proven), (b) chat with the resulting AI in the presence of the caplet (build on #202 Chat and #228 agent chat Clip design), (c) view the virtual file system / pet-name tree (the New Clip pet-name inventory, #201), and (d) create a subagent with endowments chosen from the guest's pet store. A fresh agent must have NO implicit authority over the user's powerbox: endowments are delegated explicitly and limited. Unnamed agents can only mail @host. Use the dedicated low-budget API key flow (AWS secret minion/claude-api-canary-key; verify without printing it). Integrate and deploy the existing drafts' work where possible instead of rewriting it, in increments, each verified in production with Playwright. Report what is deployed, what is gated, and what is blocked, so the maintainer can evaluate. Repo: kriscendobot/minion.town (base: current main; if an open draft PR already covers part of this, build on it or stack on it rather than duplicating). Maintainer interactive-evaluation session, kriskowal, 2026-11-04: get as much as possible DEPLOYED for incremental evaluation; the maintainer will evaluate production results, not diffs (review inversion). Frame against the chrome vision: a dock/gutter of clips, a New Clip zygote, an API-key agent. Deploy through the normal CD path and verify in production with the real-daemon + Playwright recipe (see memory/skills for minion-town-clip browser testing). Do not touch production account data; account resets are a separate maintainer-authorized step.


---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-04T23:52:28Z
