Job complete. Here is my report.

---

## Completion report: PR #15 attention directive (kriscendobot/agoric-sdk)

**Directive** (dckc, comment 5005329711): interface guards should use the precise `Foo` shapes, not `FooExt`/loose ones — *especially* where a method already re-validated with `mustMatch`; the guard should replace that `mustMatch`, while staying careful about compatibility. "And do fix all the comments."

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (no peer had resolved it) → proceeded.

### What I did (commit `2ad39fff54`, pushed to `garden31-portfolio-exo-guards`)

Tightened the interface guards and removed the now-redundant internal `mustMatch` calls, in `portfolio.exo.ts` and `portfolio.contract.ts`:

- **Offer handlers** (`rebalanceHandler`/`depositHandler`/`simpleRebalanceHandler`): guards now pin `offerArgs` to the precise `offerArgsShapes.{rebalance,deposit}` (enforcing `TargetAllocationShape` + branded amount); the internal `mustMatch` is gone and the param is typed `OfferArgsFor[...]`.
- **`evmHandler.grant`/`setAutoFeatures`** and the **`manager`** methods they delegate to: pinned to `PortfolioPermissionsShape`/`PortfolioAutoFeaturesShape` (was `M.any()` + internal `mustMatch`).
- **`PortfolioKitI` → `makePortfolioKitInterface(offerArgsShapes)` factory**, because the offer-arg shapes are USDC-brand-dependent. Partial-powers callers (unit tests that omit `offerArgsShapes`) fall back to rebuilding them from `usdcBrand` — this fixed a prepare-time crash the eager version introduced.
- **Compatibility preserved** for results/evolving stored payloads (account info, published status, stored target allocations, positions, vows stay loose); `pos.exo`'s `getPoolKey`/`getYieldProtocol` keep the extensible `M.string()`.
- **The one remaining `mustMatch`** (`makeOpenPortfolioInvitation`) legitimately stays — its offer handler is a plain function, not an exo method, so `zcf.makeInvitation` gives it no `offerArgs` guard; I added a comment explaining that. All surrounding doc comments updated.

### Verification
- `yarn test` for `packages/portfolio-contract`: **345 passed**, 0 failed (11 skipped, 8 todo) — confirmed against a stashed-baseline run (43/43 on `portfolio.exo.test.ts` both before and after).
- Scoped type-check (`lint:types`): no errors in touched `src/` files (only pre-existing `@agoric/client-utils` unbuilt-sibling noise in test/tools).
- `prettier --check` and eslint: clean on all touched files.

### Follow-ups
- None required. Full ava + type CI on the PR remains authoritative.
- Posted a reply on the PR (comment 5005553222) summarizing the resolution and citing dckc's comment.
