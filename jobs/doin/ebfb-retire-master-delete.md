---
role: conductor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-17T17:16:03Z -->

Final deletion stage for the 2026-07-16 maintainer directive on endojs/endo-but-for-bots. Immediately before deletion, list open PRs whose base is master. If any remain, do not delete master: report the exact remaining PR URLs and include orchestration-failed: true in the completion report so the serial orchestration halts and alerts the maintainer. Only if the query returns zero, delete refs/heads/master from endojs/endo-but-for-bots, then re-query the branch ref and open master-base PR count to confirm deletion. The maintainer directive explicitly authorizes this deletion. Do not merge any PR to the fork master.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 11
  worker_kind: gardener
  claimed_at: 2026-07-17T17:16:07Z
