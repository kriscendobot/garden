---
role: weaver
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-08-22T13:56:07Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Restack endojs/endo-but-for-bots PR #394 (phase-6) onto its rewritten parent

Part of the gateway phase-2..12 restack cascade (maintainer inbox
20260816T062734Z-322a21, following review 4945543700 on PR #388). PR #388
(phase-2) and #389 (phase-3) are already reopened/restacked onto `llm` with
green local-verify; each phase branch below still builds on the *pre-rewrite*
parent and needs the same treatment, in order.

**This job restacks PR #394** onto the phase-5 branch's new rebased head (restacked by the prior step in this chain, a bare branch with no PR), which this orchestration
already restacked as an earlier step — confirm its new head before rebasing,
don't assume the stale one.

## What to do

1. Rebase this PR's branch onto its parent's new head (`git rebase --onto`,
   same technique the #388/#389 reports used).
2. **Port, don't just conflict-resolve, any moved type usage.** `llm`
   relocated the gateway type layout into `packages/gateway/src/types.ts`;
   `llm` also renamed `uds*` -> `sock*` throughout. If this phase's diff
   still adds inline `Gateway`/`GatewayPowers` `@typedef`s, or imports
   types from `config.js`/`vhost.js`, move those additions onto
   `types.ts`/`types.js` the way #388 and #389 did — do not just resolve
   the textual conflict and leave a duplicate/stale type definition. If this
   phase's diff does not touch the moved types, the restack should be a plain
   clean rebase; say so in the report rather than doing unneeded porting work.
3. Local-verify `packages/gateway`: `tsc` clean, `eslint` 0 new errors,
   full test suite passing (match or exceed the prior phase's count).
4. Force-push the rebased branch. Confirm the PR still reports its expected
   base and is mergeable (conflicts resolved, not just deferred).
5. Report the new head SHA and test count, matching the shape of the #388/
   #389 completion reports so the next child in this chain can cite it.

Do not restack any PR beyond #394 — the next step in the chain is a separate
orchestrated job.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-22T13:56:21Z
