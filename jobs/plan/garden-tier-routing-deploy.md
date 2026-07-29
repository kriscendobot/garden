---
gate: orchestrated
orchestrated_by: garden-mentor-tier-kimi-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T16:30:22Z
---

Repository: kriscendobot/garden.

After garden-tier-vocabulary-kimi-routing completes successfully, deliberately deploy its landed main2 revision to every active garden host. This fleet deployment is explicitly authorized by maintainer kriskowal in the liaison session on 2026-07-29; use authorized_by: kriskowal for host-directed sysop deploy operations. Use each host drain, quiesce, deploy, lift, restart sequence and preserve a pre-existing intentional drain. Verify every reachable host runs the intended revision, has zero failed units, and has a positively live qualified non-Claude worker pool. Endolin hosts must retain gardeners: 0. Do not proceed if the implementation child failed or the revision does not enforce mentor as the automatic ceiling and mentat as manual-only. Surface inaccessible hosts rather than claiming fleet-wide completion.
