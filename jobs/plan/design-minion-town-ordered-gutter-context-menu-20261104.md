---
gate: orchestrated
orchestrated_by: minion-town-new-clip-gutter-orchestration-20261104
priority: normal
posted_by: producer
posted_at: 2026-11-04T22:49:16Z
---

---
role: designer
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: designer.** **Design the empty-account gutter with ordered, named clips and a clip context menu** (maintainer, 2026-11-04). Land as `designs/` in kriscendobot/minion.town (a short design; note it carries open questions only if truly unresolved). Requirements as stated:
- A user whose account has NO clips (not even examples) sees the "+" add-clip button, and "+" creates new clips ONLY in the gutter.
- That may need pet names assigned to gutter clips and their ORDER tracked, possibly a special kind of directory that keeps a TOTAL ORDER of entries. Evaluate options against Endo's pet-store/directory facilities (ordered-directory formula vs a sidecar order list vs fractional indexing) and recommend one; state the ownership map (who owns the durable order, commit/discard, restart/replay).
- Context-click (right-click/long-press) on a gutter clip opens a menu of clip actions: delete, clone, freeze, and so on. Reconcile with the clip lifecycle authority design (#142), the governor-column ladder (#230), real clip names/icons in the gutter (#179), and New Clip (#201). Clone copies content+powers (plus the alternate-powers mode); destroying a governor releases its children.
- First-run: how the shell seeds nothing for a fresh or reset guest and what "New Clip" is on first use.
Score any new interface REST-vs-CapTP with skills/api-transport-rubric (default CapTP; #231 adds the authenticated CapTP session). Make the design buildable in increments, smallest first. Repo: kriscendobot/minion.town (base: current main; if an open draft PR already covers part of this, build on it or stack on it rather than duplicating). Maintainer interactive-evaluation session, kriskowal, 2026-11-04: get as much as possible DEPLOYED for incremental evaluation; the maintainer will evaluate production results, not diffs (review inversion). Frame against the chrome vision: a dock/gutter of clips, a New Clip zygote, an API-key agent. Deploy through the normal CD path and verify in production with the real-daemon + Playwright recipe (see memory/skills for minion-town-clip browser testing). Do not touch production account data; account resets are a separate maintainer-authorized step.

