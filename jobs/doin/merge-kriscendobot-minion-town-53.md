---
role: conductor
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Merge kriscendobot/minion.town#53

https://github.com/kriscendobot/minion.town/pull/53 — `feat(gateway): attenuate sites per guest`.

Ready to land: not draft, `MERGEABLE`/CLEAN, CI `test` green on head `5d931c7`, and carrying the maintainer's approval (kriskowal, review 5044915726 "Sure. Validate in prod."). Production live-daemon validation is complete and recorded on the PR (issue-comment 5445036291): live `@sites` publish verified end-to-end through the MCP machine client (publish `serving:true`, `<hash>.ocap.site` edge serves the marker with a 200, `weblet_list` shows it, `weblet_unpublish` removes it); production restored to the safe non-serving default with the gateway powers-plane containment left intact.

Linearize and merge with the conductor's default merge-commit shape.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 4
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-27T20:48:39Z
