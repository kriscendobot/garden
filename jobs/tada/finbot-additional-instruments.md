Job complete. Completion report follows.

---

# Completion report: `finbot-additional-instruments`

**Goal:** carry the finbot OODA cycle past a single risk asset to multi-instrument portfolios with yield-bearing instruments, with correlation- and APR-aware analyzer scoring.

**Landed on `kriscendobot/finbot` branch `feat/additional-instruments` (commit `4d61ff1`, pushed to origin).** Dry-run only; no agoric-sdk work; the wallet capability is never constructed.

## What I built

**1. Yield/APR-bearing instruments that accrue over ticks (the live world)**
- New `packages/simulator/yield-accrual.js` — `accruePortfolio()` accrues each held yield/dividend position into the portfolio's cash (or DRIP back into the position) every tick, the live complement to the existing series-based `instruments.js` walk. `aprOf` / `aprToPerPeriodRate` convert annualized rates; reuses the rate/dividend/payout resolvers (now exported from `instruments.js`).
- `portfolio.js` gained `creditCash()` + an `accruedIncome`/`accruals` trail, folded into total P&L and the snapshot and carried through `clone()`.
- The world now carries an optional `instruments` registry; `runner.js` accrues each tick **before** the agent reacts, and `cloneWorld` carries the registry so accrual threads through every forecaster fork (a yield leg compounds inside the Monte Carlo projection, not just the live walk). A world with no registry accrues nothing → prior price-only behaviour is byte-for-byte unchanged.

**2. Multi-asset target allocations end to end**
- `analyzer.js` score is now `(price edge + APR carry) / price risk − correlated-cluster penalty`. APR carry is weighed per unit of price risk (high-APR low-vol outscores high-APR high-vol); the correlation penalty discounts adding to a position correlated with the held book (`correlationLookup` handles pair-spec / nested-map / matrix forms). New `maxPositions > 1` mode emits a bounded multi-leg allocation, folding in registry yield legs that didn't themselves deviate. **Default `maxPositions: 1` keeps the legacy single-asset path identical.**
- `ooda-cycle.js` feeds the world's instrument registry and the price feed's correlation spec into the analyzer. The rebalance solver, planner, forecaster, auditor, and executor were already multi-asset, so the allocation flows through unchanged.

**3. Runnable demonstration** — `bin/finbot-ooda --multi` runs a 3-instrument world (ATOM + OSMO correlated growth + stATOM yield) end to end in dry-run, reporting warm-up accrual. Verified: 3-leg allocation, audit approved, wallet untouched, accrual occurring.

## Verification
- Full suite **356 passing, 0 failing** (was 334; +22 new across `yield-accrual.test.js` and `multi-instrument.test.js`).
- New tests cover: live accrual into cash, DRIP, dividends, fees/tax, accrual-period gating, determinism, fork-carried registry, the fast path; APR-carry candidacy, correlation-penalty ordering, multi-leg allocation budgets, and a deterministic ≥3-instrument dry-run cycle with a yield leg in the allocation.
- Legacy single-asset CLI output byte-identical (post-equity 1098.04).
- Docs updated to match: both package READMEs and the analyzer role brief.

## Follow-ups (not blocking)
- **Landing decision:** I pushed to a feature branch rather than `main`. finbot's convention is to push `main` directly (no PRs against itself), so the maintainer/liaison can fast-forward `main` to `4d61ff1` in one step — I left it on the branch because this is multi-hundred-line feature work that warrants a glance first.
- The dividend ex-dividend price mark is modeled only in the offline series walk, not the live GBM feed (live dividends are discrete cash payouts) — fine for "accrues over ticks," but a future cut could wire ex-div marking into the live price for total-wealth conservation at the payout instant.
- The analyzer's correlation source is the GBM feed's `correlations`; a replay/real-history world must pass `config.correlations` explicitly (the OODA cycle already supports this).
