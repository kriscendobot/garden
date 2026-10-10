---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/self-deploy.sh
self-deploy.sh:149 logs "deploy deferred but could not publish the deferred status" (seen 2026-10-07T16:56Z and 16:59Z, back to back). The publish is a single attempt, so a transient journal CAS or fetch failure leaves the leader unaware that the canary is deferred. Wrap the publish in a bounded retry with a fresh journal sync before each attempt, the way other journal writers do. If it still fails, write a host-local pending-status marker and republish it on the next tick, with a test for the retry path.
