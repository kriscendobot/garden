<!-- garden-promoted-from-plan: gate=deferred priority=normal at=2026-06-26T06:41:50Z -->

# GOAL: multi-instrument portfolios and yield-bearing instruments

## Context
The cycle is proven on a single risk asset (ATOM) vs cash (USDC). The analyzer,
planner, and rebalance solver are written multi-asset but only exercised on one.
The README/roles describe "analyzing opportunities with other instruments".

## Build
- Multi-asset target allocations (e.g. {ATOM, OSMO, stATOM}) end to end through
  oracle-watcher -> analyzer -> forecaster -> planner -> auditor -> executor.
- Yield/APR-bearing instruments (a position that accrues over ticks); analyzer
  scoring that weighs APR vs price risk; the simulator world models accrual.
- Correlation-aware analyzer scoring (penalize adding to a correlated cluster).

## Safety bounds
Dry-run only; no agoric-sdk work; borrow instrument shapes from public references.

## Done
A >=3-instrument dry-run cycle with at least one yield instrument; analyzer scores
account for correlation and APR; tests green for the multi-asset path.
