Worktree removed, branch deleted, inbox empty. Work is complete and pushed.

---

# Completion report: `finbot-richer-instrument-models`

**Done.** Deepened finbot's three instrument return shapes from simple price overlays into realistic dynamics, drivable from ingested historical data and mixable under a rebalancer. Tested and green; pushed to `kriscendobot/finbot` `main` (`343a4d5..c3d304b`).

## What changed (packages/simulator)

**`instruments.js`** — rewrote as a stateful-but-pure walk over a new single-source-of-truth `stepInstrument` primitive (shared with the mix rebalancer):
- **Yield**: constant rate, yield-curve / short-rate path (array sampled per tick), stochastic short-rate (seeded function), or DeFi utilization-driven APY via new `kinkedUtilizationApy` (Aave/Compound two-slope model); `compounding` vs simple; accrual into cash or DRIP into the position (`reinvest: 'position'`).
- **Dividend**: dividend growth and cuts (`dividendGrowth` or explicit per-payout schedule), irregular schedules (`payoutTicks` / `scheduleAt`), payout-ratio dividends over an earnings series, and ex-dividend price adjustment wired through the marked price — plus `exDividendAdjustedSeries` to materialize the drop onto the oracle.
- **All shapes**: per-payout/per-reinvest **fees** and **income/capital-gains taxes**; returns reported gross and net.

**`instrument-mix.js`** (new, `rebalanceMix`) — target-allocation rebalancer over an instrument mix: periodically trades legs back to target weights charging slippage/gas/fees (`costs.js`); leg payouts flow to a shared cash account it redeploys; mirrors `@finbot/pipeline`'s `rebalance.js` protocol shape.

**`history.js`** (new) — real CSV/price-history ingestion: `parsePriceSeriesCsv` (one-price-per-line / `t,price` / named column), `seriesFromFrames`, `validateSeries`, and read-only file loaders `loadPriceSeries` / `loadPriceFrames`.

Wired new exports into `index.js` + `package.json`; documented all of it in the README.

## Tests
Added 3 test files (44 new cases) covering cash-flow accounting invariants, compounding/DRIP equivalence to `(1+r)^N`, yield-curve/stochastic/utilization behavior, dividend growth/cuts/irregular/payout-ratio/ex-div conservation, fee/income-tax/cap-gains accounting, and rebalancer cost-drag / weight-restoration / determinism / cash-non-negativity. **Backward compatible**: existing `instruments.test.js` unchanged and passing.

Final suite (post-rebase, full workspace install): **harness 37 · pipeline 62 · simulator 235 — all green.**

## Notes / follow-ups
- `origin/main` advanced under me mid-job (a peer's volatility-elicitation slice); rebased onto it, resolved a one-line `package.json` exports conflict by keeping both sides, and re-verified green.
- The repo has no lockfile by convention; `npm install` generated a `package-lock.json` locally which I did **not** commit (it lived only in the now-removed worktree). Workspace cross-package tests require an install to resolve `@finbot/simulator` — worth noting for CI.
- Capital-gains tax in the mix rebalancer is intentionally not realized (basis is tracked and reduced proportionally on sells, but no terminal cap-gains tax is applied to a rebalanced mix); single-instrument walks do realize it. A future job could add lot-level realized-gain taxation across rebalances if desired.
