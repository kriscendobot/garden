# Evolve finbot: richer instrument models (yield curves, dividend dynamics, fees, reinvestment)

Follow-on to `finbot-forecast-evaluation-fixtures` and the parked `finbot-additional-instruments`. The landed
slice (`packages/simulator/instruments.js`) models three return shapes — growth / yield / dividend — as simple
overlays on a price series. This job deepens them.

## Scope
- **Yield**: variable/stochastic yield rates (a short-rate or yield-curve process), compounding vs simple,
  utilization-driven DeFi-style APY; accrual into either cash or position (DRIP/reinvestment).
- **Dividend**: dividend growth and cuts, ex-dividend price adjustment wired through the oracle, irregular
  payout schedules, payout-ratio-driven dividends.
- **Growth/general**: transaction fees, taxes on payouts vs capital gains, slippage on rebalances into the mix.
- **Mixing**: a target-allocation rebalancer across an instrument mix (tie into `rebalance.js`/`planner.js`).
- Drive everything from **real historical data ingestion** (a loader for user-supplied CSV/price history) in
  addition to the synthetic fixtures, per the parent job's historical-or-speculated input requirement.
- Tested (cash-flow accounting invariants); simulation only.

## Done when
finbot models yield/dividend/growth instruments with realistic dynamics + fees/taxes/reinvestment, drivable
from ingested historical data, mixable under a rebalancer; tested and green.
