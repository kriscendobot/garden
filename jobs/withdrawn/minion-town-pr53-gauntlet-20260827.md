---
withdrawn: true
withdrawn_reason: target kriscendobot/minion.town#53 is MERGED; the gauntlet has no PR left to drive (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:05:27Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
tier: mentor
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-27T22:13:05Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-27T22:13:05Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Run the full gauntlet (clean → panel review → fix-loop → un-draft) on kriscendobot/minion.town PR #53 (branch feat/weblet-attenuated-sites-facet).

Context: five fixup commits landed since the PR's initial build, all addressing production failures found during live @sites end-to-end validation under the powers-plane containment (deploy/aws/systemd/endo-gateway.service.d/zz-containment-*.conf): fully-qualified daemon formula ids, daemon registration surviving vhost-write failure, live guest reprovisioning, TasksMax headroom for the daemon service, and — the final commit — serving live weblets from record.contentRoot (content plane) instead of the disabled CapTP powers path. The last two commits report "verified end to end against production" directly, but the PR itself has not been re-panel-reviewed since these fixes landed, and the change touches the containment boundary described in memory minion-town-gateway-powers-containment (never bypass GATEWAY_ENDO_SOCK containment — these commits correctly avoid it by serving from the content plane, confirm that invariant holds under panel review).

Verify tests pass locally (test/gateway/gateway.test.ts, test/endo-daemon-integration.test.ts, test/gateway/daemon-site-registry.test.ts, test/gateway/site-registry-exo.test.ts, test/endo-root-host-socket.test.ts) before/alongside the gauntlet's clean phase, then proceed through panel review, fix-loop on any findings, and un-draft.
