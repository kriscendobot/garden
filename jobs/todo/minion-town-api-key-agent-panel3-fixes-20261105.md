---
posted_at: 2026-11-05T00:22:29Z
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Build: fix the API-key agent findings that reached main from closed PR #244

Repo: kriscendobot/minion.town. Open a NEW draft PR off current `main`; do not push to `feat/api-key-agent-ui`.

PR https://github.com/kriscendobot/minion.town/pull/244 was closed unmerged at 2026-11-05T00:15:46Z after its head `e66e75a257` was integrated into `main` by merge commit `7e98920208`, and it still had a must-fix panel verdict open: https://github.com/kriscendobot/minion.town/pull/244#pullrequestreview-5777291018. The gauntlet's fix round 3 could not apply it, because a closed PR has no working head. The surfaces are behind default-off flags (`API_KEY_GUEST_AGENTS`), so nothing here is reachable in production yet.

Read that review in full. Each item below was checked against `main` at `7a0bcc9030` and was still present. Re-verify each one against current `main` before changing it.

## Must-fix

1. `src/auth/inference-provider-endpoint.ts`, `/replace` route. `grantIds` and `agentIds` are not validated against the replaced provider's server-side attachments, so a crafted or stale request can move an unrelated same-owner agent. A factory agent's grant sent in `grantIds` moves through the registry directly and strands the factory's record, and sending both its grant and agent id runs two separately keyed moves. Validate against the attachment set and canonicalize factory-owned grants to the factory move, before `providers.supersede` commits. Test with the real join, including `grant-helper` plus `agent-helper` (saboteur, breaker, corner-prober).
2. `src/auth/agent-endpoint.ts`, agent create. Arbitrary browser-supplied `endowments` strings are forwarded through the factory capability. Accept an exact allowlist or a boolean and build the list on the server (locksmith).
3. `src/endo/agent-service.ts`. `OwnerAgents.delete()` returns `Promise<AgentSummary>`, but the factory reports only `agentId`, `name` and `lifecycle` for a deleted agent. Model the sparse tombstone as a discriminated union, make `publicAgent` handle it, and make the fake return the sparse shape. The JSDoc recording this contract was also displaced onto `DeferredMessage` during integration, so restore it (typist, spec-keeper).
4. `src/auth/agent-endpoint.ts`, `publicAgent` and `publicOption`. Nested remote values (`limits`, `usage`, `models`, `effectiveLimits`, `lowered`) cross into browser JSON unprojected. Project them onto explicit schemas and test with sentinel fields (purist).
5. `deploy/aws/www/provider-ui.js`, `sendWake`. Every attempt mints a new idempotency key, and an unknown outcome reads as failure. Retain the key across unknown outcomes, as create and reattach do (assessor).
6. `deploy/aws/www/provider-ui.js`, create and reattach retries. The retained key is resent with a payload rebuilt from editable controls. Bind the key to an immutable copy of the original payload until reconciled (saboteur).

## Needs a maintainer decision, do not build it unasked

`src/auth/inference-provider-endpoint.ts` `directoryFor(ownerKey)` derives the owner from `iss`/`sub` and authorizes every agent action through the factory's broad facet (locksmith's second must-fix). Replacing that with attenuated per-agent capabilities is an architecture change and it may conflict with the merged workbench design. Check `designs/api-key-agent-workbench.md`, and record the question with `message-user.sh` and in the PR body.

## Should-fix, take when cheap

Stylist `d` rename, warden CapTP lockdown test, purist/corner-prober safe-integer bounds in `agentLimits`, fast-checker join property, releaser changeset rewrite, pruner JSDoc cut. Spec-keeper's immutable-revision citation applies if the interface is pinned.

Name the review link above in the PR body so the findings trace back to it.
