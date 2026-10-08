---
child-minion-town-ci-runner-redeploy-verify-50aa690-host: endolin-garden2-5bcdff64
child-minion-town-ci-runner-redeploy-verify-50aa690-reap-count: 0
child-minion-town-ci-runner-host-sync-50aa690-reap-count: 0
child-minion-town-ci-runner-lambda-sync-50aa690-reap-count: 0
order: serial
children: minion-town-ci-runner-lambda-sync-50aa690 minion-town-ci-runner-host-sync-50aa690 minion-town-ci-runner-redeploy-verify-50aa690
on-child-failure: halt
state: running
created_by: orchestrator
created_at: 2026-10-08T21:36:35Z
---

# Redeploy and validate the ci.minion.town self-hosted runner at 50aa690f87

The original operation is genuinely divisible into three ordered, independently
verifiable phases: synchronize the JIT-minter Lambda first, synchronize and
possibly reboot the runner host second, then run the failure-path selftest and
post-prune GitHub registration validation. Serial order preserves the deployment
dependency, and `halt` prevents validation against a partially updated system.

The campaign makes no source-code changes. It reports whether each deployed
component was already in sync or redeployed, the selftest run URL, residue and
timestamp-stamp evidence, runner registration cleanup, and any maintainer-owned
authentication or operator follow-up.
