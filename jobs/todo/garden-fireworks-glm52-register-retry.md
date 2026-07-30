---
role: gardener
handler-timeout: 7200
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-30T00:13:05Z cleared=none -->

# Resume and finish Fireworks GLM 5.2 mentor registration

Repository: https://github.com/kriscendobot/garden. Land directly on main2, no PR.
Prior attempt: garden-fireworks-glm52-register, which exceeded the default 2400-second handler budget and was swept back to plan when garden-fireworks-glm52-rollout halted.

Resume the intended work without depending on the retired orchestration. Inspect any landed commits or resumable worktree evidence from the prior attempt before redoing work. Replace the placeholder Fireworks inventory entry with the live selector accounts/fireworks/models/glm-5p2 in the garden routing namespace and classify it as mentor. Reconcile the closed tier inventory, routing defaults, operations guide, provider catalog, resolver, provider-constrained tier canary mechanism, and tests. Automatic jobs remain tier-pinned; a canary may constrain provider=fireworks but must not name a concrete model in its job body. Unknown provider/tier combinations fail closed. Verify with hermetic tests, shell syntax, and a secret-safe live availability probe. Land on main2 and report the revision and exact deploy/activation steps.

<!-- garden-reaped: 0 -->
