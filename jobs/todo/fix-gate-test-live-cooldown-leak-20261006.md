---
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Deploy-gate test leaks the live gh-api cooldown, so the leader's self-deploy is rejected** (kriscendobot/garden, main2).

On 2026-10-06 at 04:04Z, the leader endolin-garden2-5bcdff64 rejected its own deploy of `1574472ecab2`. The candidate test gate failed `scripts/jobs/test/triager-pacing-test.sh` on both attempts. Every failure is the projector never being called: "gate did not collapse the herd (projector calls=0)", "disabled gate did not refresh every tick: calls=0", and so on. Diagnostics are in `$GARDEN_STATE/deploy/candidate-gate-diagnostics/1574472ecab2…/`. The canary endolin-garden-ece02cb4 passed the same suite.

Cause: at that moment this host's real host-shared gh-api cooldown was live (the mirror-closer had armed 3600s on GitHub primary-quota exhaustion). `GARDEN_API_COOLDOWN_DIR` defaults to `$GARDEN_ROOT/.garden-state/gh-api-cooldown` (`scripts/jobs/common.sh:983`). The test isolates `GARDEN_STATE` but not that directory, so it read the live latch.

Fix:
1. Isolate `GARDEN_API_COOLDOWN_DIR` (and any similar live `$GARDEN_ROOT/.garden-state` defaults) in this test.
2. Better, isolate it in the candidate gate's environment for every suite, so that no gate test can see a host's live latches.
3. Add a regression test: arm a fake live cooldown under the real-root path and assert the suite still passes.

Land on main2. Once a new sha is available, the leader's rejected marker clears by itself.
