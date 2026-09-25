---
gate: blocked
blocked_on: https://github.com/kriscendobot/minion.town/pull/118
priority: normal
posted_by: producer
posted_at: 2026-09-25T06:30:24Z
---

---
role: gardener
tier: mentor
handler-timeout: 3600
fallback-tier: minion
dispatch: automatic
---
# Verify kriscendobot/minion.town#81 is live in production after kriscendobot/minion.town#118 merges

Successor to `minion-town-pr81-deploy-recover-27a6e2bf`. The first production deploy of
https://github.com/kriscendobot/minion.town/pull/81 (merge `27a6e2bf`) rolled back twice:
(1) `GUEST_RECOVERY_KEY` was unprovisioned. That is now fixed: `deploy-accounts-store.sh` and
`deploy-account-endpoint-secret.sh` were run 2026-09-25 ~05:42Z, which also armed the /account gate.
(2) A guest-router middleware scope bug returned 400 on the loopback /healthz smoke. The fix is
https://github.com/kriscendobot/minion.town/pull/118.

This job is unblocked when kriscendobot/minion.town#118 merges. Then:
1. Confirm the CD deploy run on `main` for the #118 merge is green. If the push-triggered run
   did not deploy, `gh workflow run deploy.yml -R kriscendobot/minion.town --ref main`.
2. Over SSM (memory `minion-town-deployed-topology`): `minion-mcp` must be active with stable
   NRestarts, and `/opt/minion-town/share/minion-town/deployment-receipt.json` must show
   sourceCommit = the #118 merge and result = promoted. Probe the guest routes via the public
   edge: `curl -sS -X POST https://minion.town/api/guest -H 'content-type: application/json' -d '{}'`
   should return 201. Loopback `/healthz` should return 200.
3. Comment a short note on kriscendobot/minion.town#81: deployed and ready for evaluation. Mention
   the /account gate arming.
If the deploy fails again, diagnose it from the journal dump that #118 adds to the smoke-failure log.
