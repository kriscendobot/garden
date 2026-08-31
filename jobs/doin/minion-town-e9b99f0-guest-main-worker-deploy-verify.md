---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repo: kriscendobot/minion.town. Range dd4c216..e9b99f0 merged PR #62 ("make @main the indelible guest worker" + "bridge guest main worker provisioning"). Commit 9c4e408 switched the `@sites` registry evaluate call in `src/endo/gateway/daemon-site-registry.ts` from the legacy `MAIN` worker to `@main`, which the pinned production daemon does not expose; commit 1aafcbe bridged it back with `const workerName = (await guest.has?.("@main")) ? "@main" : "MAIN"` pending upstream endojs/endo-but-for-bots#982 (open, filed by kriscendobot).
Task: deploy the merged `origin/main` (e9b99f0) to the live EC2 host and verify weblet publishing still works end to end against the pinned daemon, following the recipe recorded in the completed job report `jobs/tada/minion-town-199a061-guest-backend-deploy-verify.md` (SSM Run Command, restart `minion-mcp`, `WEBLET_SITES_LIVE=1`, authenticated `/mcp` via the `minion-mcp-test-cc` Cognito client).
Specifically confirm the new bridge does not regress the live `@sites` path: the unit tests only exercise fake guests whose `has` RESOLVES (`true` or `false`), never one that REJECTS. On the real daemon `guest.has("@main")` is an eventual send to the guest exo for a SPECIAL name that is not bound; if that call rejects instead of returning false, the rejection propagates out of `evaluateRegister` and breaks `weblet_publish` in production (the live `@sites` serving path proven working on 2026-08-31). Determine the pinned daemon's actual behavior for `has` on an unbound `@`-prefixed special name.
If it rejects (or if publishing fails for any reason after deploy), harden the bridge in `src/endo/gateway/daemon-site-registry.ts` to treat a rejected or non-boolean `has` as "no `@main`" (fall back to `MAIN`), add a regression test with a rejecting `has` double alongside the existing `uses the legacy MAIN worker...` test in `test/gateway/daemon-site-registry.test.ts`, and open a PR on kriscendobot/minion.town.
If publishing verifies clean, report the observed `has("@main")` result and leave the code as is.
Do not remove the `MAIN` fallback: that cleanup is blocked on endojs/endo-but-for-bots#982 landing and the deployment pin advancing.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-31T23:26:04Z
