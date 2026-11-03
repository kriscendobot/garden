I added the Phase 3 operation-management contract to endojs/endo-but-for-bots#1575 and pushed it to the PR's head as commit `1f08aaab73`. The hosted-agent tests pass (888). One fae test failed because its test daemon would not start; that test doesn't use the code I changed.

**New methods**

On the owner's provider directory:
1. **Check creation status:** `getOperationStatus(idempotencyKey)` answers `committed`, `in-progress`, `key-needed` or `not-found`. `in-progress` covers both the `secret-created` state and an `intent` whose secret is already stored, so no key is asked for again.
2. **List pending creations:** `listPendingOperations()` returns the owner's creations still at `intent` or `secret-created`, with an expiry time on each intent. Other owners' operations are not listed.
3. **Cancel:** `cancelOperation(idempotencyKey)` aborts a creation still at `intent`, and calling it again is harmless. It refuses with `operation-in-progress` if the secret is already stored, `operation-committed` if the creation finished, and `operation-not-found` otherwise.
4. **Reattach:** `reattach({ idempotencyKey, grantId, providerId, model? })` moves an agent to another of the owner's active providers of the same kind, and repeating it is safe.
   - It keeps the agent id, so the guest's name, mail, wake state and conversation are untouched.
   - Caps are clamped to the new provider's limits, and it returns the new grant with its `AgentInference` facet.
   - From the commit on, the old grant admits no new turns; a turn already running finishes there.
   - Errors: `provider-not-found` (foreign or retired target), `provider-kind-unsupported`, `agent-not-found`, `agent-deleted`, `idempotency-conflict`.
   - If a reattach is interrupted, the restart reconciler finishes it, or aborts it and leaves the agent on its old grant.
   - Replace key is `supersede` followed by `reattach` for each agent.

On the provider admin:
5. **Upstream revocation:** `assertUpstreamRevoked()` records `upstreamRevocationAssertedAt` once, writes one audit entry, and shows the field in provider summaries.

None of these returns key bytes or the registry's secret names, and a test checks that.

**Two choices for you to review**
- **An extra `aborted` status.** The design lists four status answers; I added this fifth for cancelled or expired creations. Reporting those as `not-found` would invite a fresh submission with the same key, which the registry refuses with `operation-aborted`.
- **`agent-deleted` on the old grant.** After a reattach, a call on the old grant's facet fails with this existing error code rather than a new one like `agent-reattached`. The caller has to switch to the facet `reattach` returns.

**Tests:** six new ones in `packages/hosted-agent/test/inference-provider-registry.test.js`. They cover each status during lost responses, recovery after a restart, cancel (including a crash mid-cancel and the refusals), reattach (including the replace-key path and lost responses), a reattach interrupted after intent and resumed on restart, and the upstream-revocation assertion persisting across restart. Prettier, eslint (no new warnings) and `lint:types` are clean. I added a changeset, `.changeset/hosted-agent-provider-operation-management.md`.

**Done after the push**
- I commented on kriscendobot/minion.town#229 (https://github.com/kriscendobot/minion.town/pull/229#issuecomment-6612702999) that its Endo prerequisite is met and the rollout gate can be evaluated.
- The gauntlet for #1575 is left to run automatically when this job completes.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endo-1575-operation-management-20261103.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1612284 cached reads)
- Output: 23345 tokens
- Cost: $1.5713968
- Wall-clock: 291s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
