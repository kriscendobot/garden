Everything is confirmed and green. Here's my completion report.

---

## Completion report — review directive on kriscendobot/agoric-sdk PR #15 (@dckc, review 4726532241)

**Preflight:** `pr-feedback-preflight.sh` returned PROCEED (no peer resolution at claim time).

**The ask (single inline comment on `portfolio.exo.ts`):** `returns(M.any())` suggests missing the point — guards are the *runtime* enforcement (static types are advisory), so each exo guard should match its static type, with exceptions carefully designed and documented (per CONTRIBUTING § `TypedPattern`s). "Do a focused panel review on this aspect." (Review body itself was empty.)

**What I did:** Ran a method-by-method audit of `makePortfolioKitInterface` (and the sibling exos) mapping each static signature to its guard, then tightened every guard where a stable exported shape exists:
- **Results** (were `M.any()`/`M.string()`): `evmHandler.deposit`/`rebalance`/`withdraw` + `delegationHelper.submitTargetAllocation`/`submitRebalance` → `FlowKeyShape`; `manager.providePosition` → `M.remotable('Position')`; `evmHandler.getReaderFacet` → `M.remotable()`.
- **Arguments** (were `M.any()`/`M.record()`): `reporter.publishFlowSteps` → `FlowStepsShape`; `manager.startFlow` → `FlowDetailShape`; `manager.setTargetAllocation` → `TargetAllocationShapeExt`; `delegationHelper.assertActive` → `PortfolioPermissionsShape`.
- Rewrote the docblock to lead with the guard-matches-type principle and **enumerate every remaining loose guard as a deliberate, reasoned exception** (durable read-back, watcher/upcall settled values, async-flow membrane, in-body re-validation, the merged `publishFlowStatus` payload, and genuinely opaque values), plus the `grant`/`setAutoFeatures` guards intentionally *stricter* than their `*Ext` type.

**Caught by verification (the point the reviewer was making):** I initially also pinned `publishFlowStatus` → `FlowStatusShape`; the ava suite failed 3 tests — the fail-flow path folds `...flowDetail`/`...reasons` into the status, making it a *superset* of `FlowStatus` that `FlowStatusShape`'s closed `fail` variant rejects, stranding flows in `run`. Established a stock-HEAD baseline (109/0) to confirm the regression was mine, reverted that one guard to `M.any()` with an explanatory comment, and documented it as an exception.

**Peer collision handled:** while I worked, a peer gardener pushed `c320d9340f` resolving a related dckc review (4726535732) — a subset (the same 5 flow-key pins + one docblock bullet). My `git fetch` had a stale tracking ref; `ls-remote` revealed the true tip. Rebased my superset commit onto the peer's, resolved the docblock conflict (kept my comprehensive rewrite, preserved the peer's `delegationHelper` comment), and re-verified.

**Verification:** `yarn lint:types` clean; `portfolio-contract` ava suite green (345 passing, 0 failing) on the rebased tree.

**Landed:**
- Commit `3619095547` pushed to PR head `garden31-portfolio-exo-guards` (atop the peer's `c320d9340f`).
- Threaded reply posted to dckc's review comment: `https://github.com/kriscendobot/agoric-sdk/pull/15#discussion_r3606761168`.

**Follow-ups / notes:** Left the review thread unresolved (reply documents the resolution and cites the commit; resolution left to reviewer/conductor). `FlowStatusShape`'s `fail` variant being a *closed* `splitRecord` while `done`/`run` are open is a latent asymmetry in `type-guards.ts` — out of scope here, but worth a look if anyone later wants `publishFlowStatus` pinnable.
