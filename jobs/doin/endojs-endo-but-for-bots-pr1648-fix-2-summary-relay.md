---
posted_at: 2026-11-05T03:36:53Z
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Post the fix-round-2 summary comment on endojs/endo-but-for-bots#1648

The fix-round-2 worker ran on oros-studio-garden-ce242c49, whose token gets a 403 writing PR comments on endojs. Do only these two things, then finish:

1. Post the text between the markers verbatim as a top-level comment on https://github.com/endojs/endo-but-for-bots/pull/1648 (`gh pr comment 1648 -R endojs/endo-but-for-bots --body-file <file>`). Check first that no comment with the heading "Fix round 2" already exists, so a requeue cannot post it twice.
2. In the PR body, replace the sentence "Additive. The registry gains `listGrants`, and `InferenceProviderUse` gains `describe`." with "Additive. The registry gains `listGrants`, `InferenceProviderUse` gains `describe`, and daemon name hubs gain `compareAndStoreIdentifier`." Change nothing else in the body, and keep its markers. Also in the body, replace "A provider capability from another owner is refused with `provider-owner-mismatch` before any effect," with "A provider capability from another owner is refused with `provider-owner-mismatch`, and one that does not designate the requested provider with `provider-use-mismatch`, before any effect,".

----- COMMENT START -----
**Fix round 2** · CI: 🟡 pending · next: panel re-review (panel-3)
Head `a7812852ae`. This also covers the earlier missing summary for `2176799b` and `9e3b22ab`, which addressed the review at `cb2db099`. All must-fix items are addressed; two are addressed partly by design, explained below.

<details><summary>What changed (`a6f19c3b`, `a7812852`)</summary>

- **Provider capability binding** (assessor, breaker, purist, locksmith): `createWithUse` and `reattachWithUse` now require the capability to designate the requested provider, and to be the registry's own facet rather than a look-alike. The new refusal code is `provider-use-mismatch`.
- **Name races** (saboteur): `a6f19c3b` adds an atomic `compareAndStoreIdentifier` to daemon name hubs, and the inventory participant now uses it. An owner's concurrent rebinding is no longer overwritten or deleted.
- **Prior grant during reattach** (wire-watcher): `priorGrantId` is recorded at intent, so the reconciler cannot revoke a grant whose reattachment is unfinished.
- **Idempotent retries** (corner-prober, breaker): retries compare canonical data, so field order no longer conflicts.
- **Inference facet leak** (engine-realist): deleting an agent evicts its facet, and a deleted agent's facet is never cached again.
- **Timer configuration** (spec-keeper, saboteur): `AGENT_FACTORY_RECONCILE_MS` must be an integer from 1 to 2147483647, and an invalid value fails at start.
- **Types** (typist): `wake` and `endowments` are required in `AgentCreateRequest`.
- **Exports and docs** (curator, surfacer, integrator): `./agent-factory-module.js` is exported, the README lists every caplet setting including `AGENT_FACTORY_PROVIDER_REGISTRY`, and the changeset and README describe provisioning rather than running a harness.
- **Should-fix items also taken**: `limits` and `harnessConfig` type confusion now gets fixed refusals, and `listGrants` indexes active turns in one pass.
</details>

<details><summary>Addressed differently, or declined</summary>

- **Lal's `adopt`** (breaker, must-fix): kept. The design's confinement table gives both harnesses mail `adopt` and reserves dynamic tool adoption for Fae, so I revised the catalog description to say that, as the finding allowed.
- **Root `directoryFor(ownerId)`** (locksmith, must-fix, first half): kept. The design has the web tier obtain a directory from a registry capability using the owner key the account gate establishes. The root facet stays root-private, and the capability half of this finding is fixed above.
- **`listGrants` on the registry root** (locksmith, should-fix): not changed in this round. An attenuated reconciliation facet is worth a follow-up.
- **Typedefs in a types module** (typist, should-fix): not changed. They are local to this file for now.
- **Catalog vs. roadmap** (integrator, should-fix): not changed. `designs/README.md` still needs reconciling with the Lal and Fae catalog.
</details>

Verification: local `agent-factory`, `agent-factory-module`, registry, store-controller, pet-sitter, help-text and real-daemon `agent-factory-restart` tests pass. `tsc` is clean in both packages and eslint reports no errors on the changed JavaScript files. The full daemon suite was not run locally; CI is pending.
----- COMMENT END -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-05T04:42:14Z
