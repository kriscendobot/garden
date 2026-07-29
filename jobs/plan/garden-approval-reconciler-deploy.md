---
gate: orchestrated
orchestrated_by: garden-approval-reconciler-rollout
priority: normal
posted_by: producer
posted_at: 2026-07-29T23:54:27Z
---

---
tier: mentor
role: gardener
fallback-tier: minion
dispatch: automatic
---
# Deploy and verify the approval reconciler

After garden-approval-reconciler-build completes successfully, deliberately deploy its landed main2 revision fleet-wide. Maintainer kriskowal explicitly authorized this operational watcher fix on 2026-07-29; use authorized_by: kriskowal for host-directed deploy operations. Verify the approval reconciler runs only on the leader, followers skip cleanly, every host reaches the intended revision without failed garden units, and drains are restored appropriately.

Run one leader-side reconciliation pass in observation/normal mode. Confirm that approvals missed by the event watcher are discovered, but that the conductor jobs manually requested by the maintainer are recognized and not duplicated. Report any approved PR still lacking a live or completed conductor/shepherd path, with fully qualified URLs, rather than silently posting duplicates.
