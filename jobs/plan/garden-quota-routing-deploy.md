---
gate: orchestrated
orchestrated_by: garden-quota-routing-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T02:58:21Z
---

Repository: kriscendobot/garden.

After garden-quota-routing-race completes successfully, deploy its landed main2 version fleet-wide to every active garden host, including endolin-garden-ece02cb4, endolin-garden2-5bcdff64, ps23, and ps23-garden-f65473ae, using the deliberate drain, quiesce, deploy, lift, and restart procedure or the host-directed sysop deploy operation as appropriate. This deployment is explicitly authorized by maintainer kriskowal in the liaison session on 2026-07-29; use authorized_by: kriskowal where sysop attestation is required. After the new version is deployed, configure Claude gardeners to zero on endolin-garden instances while retaining their qualified Codex, Moonshot Kimi K3, and Fireworks-backed capacity; preserve Claude capacity on ps23 instances. Verify every host reaches the intended revision, preserves any pre-existing intentional drain, otherwise has drain lifted, has a positively live configured nonzero qualified worker pool, and has no failed garden units. Do not deploy if the implementation child failed or the revision lacks the routing policy. Surface inaccessible or failed hosts rather than claiming fleet-wide completion.
