---
tier: mentor
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-17T01:47:00Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Explore reconciling the #282 compartment-mapper resolution path with the endor registry cache, per the maintainer's explicit follow-up request.

Maintainer review 2026-08-16T06:28Z on https://github.com/endojs/endo-but-for-bots/pull/282, verbatim intent: the #282 changes effectively use compartment-mapper logic to emulate Node's behavior for loading modules. Reconcile that with the new semantics that use the endor registry cache to load non-workspace dependencies WITHOUT consulting the node_modules tree — which SHOULD BECOME A DEFAULT. A flag would then specify the legacy resolution behavior here. "Please post a follow-up job to explore that option and either go to design or build immediately."

So: assess the reconciliation, then EXERCISE YOUR JUDGMENT and either open a design PR or build immediately — do not stop at a recommendation and wait. State plainly in your report which you chose and why.

Note the sibling decision already taken: the pin-the-merge-base child gates #282's node_modules walker behind an explicit `--node-modules` flag with the registry path as default, which is the same shape as the legacy-resolution flag described above. Reconcile with that rather than proposing a competing flag surface.

Relevant prior art on llm: rust/endo/src/assemble.rs + cmd_run_entry, delivered by designs/endor-npm-registry-proxy.md Phases 4/5 in merged PRs #799 #800 #803 #805 #812 #818 #862.

handler-timeout: 7200

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T01:47:12Z
