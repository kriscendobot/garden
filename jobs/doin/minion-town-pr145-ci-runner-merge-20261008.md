---
role: conductor
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=high at=2026-10-08T19:08:41Z cleared=none -->

---
role: conductor
tier: mentor
fallback-tier: minion
priority: high
dispatch: automatic
---

# Land ci.minion.town (kriscendobot/minion.town#145), part 2: merge

**HIGH PRIORITY.** Merge https://github.com/kriscendobot/minion.town/pull/145 into `main` after part 1 has undrafted it with green self-hosted CI. The minion.town supervisor delegation (2026-10-07) covers repository-local merges like this one. Use `[skip deploy]` if the CD workflow would otherwise try to run on billing-blocked hosted runners. After merging, confirm that a push to `main` runs `test.yml` on a `ci-minion-town-*` runner.

Maintainer item that does not block this merge: the runner's credential `minion/ci-runner-github-token` is still the bot's broad gh OAuth token. Only a person can mint the fine-grained PAT that should replace it (Administration: write on minion.town). The runner already uses that token, so merging does not increase its exposure. Restate the item in your report.

<!-- garden-annotation: key=cc627e8c389f by=producer at=2026-10-08T18:30:15Z fields=priority=high -->

Maintainer 2026-10-08: high priority, billing block stops all minion.town shepherds.

<!-- garden-annotation: key=86a06321ed26 by=producer at=2026-10-08T18:46:47Z -->

Maintainer 2026-10-08: keep the broad OAuth token on purpose (a PAT expires and would need human renewal). Do NOT restate token rotation as an open item.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-08T19:09:03Z
