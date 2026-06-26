<!-- garden-promoted-from-plan: gate=deferred priority=high at=2026-06-26T05:30:19Z -->

# GOAL: richer ensemble forecasting + the visual histogram projection

## Context
`packages/simulator/forecast.js` runs an independent-walk GBM Monte Carlo and
returns quantiles + a binned histogram; `packages/pipeline/forecaster.js` wraps it
for the OODA cycle. The forecaster role brief and `designs/ensemble-forecasting.md`
call for more: correlated multi-asset walks, volatility-surface sampling, path
statistics, bootstrap confidence bands, and a deterministic SVG/PNG projection
(`skills/histogram-projection-render`). Today there is NO visual output.

## Build
- Cholesky-factored covariance so multi-asset walks are correlated (the GBM feed
  notes this as a future cut).
- Sample volatility from an empirical surface; add gas-cost / slippage noise.
- Bootstrap confidence bands on tail quantiles (1st/99th are noisy at N=10k).
- Path statistics: max-drawdown distribution, time-to-recovery distribution.
- Deterministic SVG (and optional PNG) histogram-projection render given the seed.

## Safety bounds
Determinism is the contract: same inputs+seed => byte-identical output; never call
Math.random (use the seeded sfc32). No agoric-sdk work. Dry-run only.

## Done
Correlated multi-asset forecasts with confidence-banded tails and a deterministic
visual projection artifact; forecaster role brief's output shape (histogram_path +
projection_path) honored; tests green incl. a determinism test.
