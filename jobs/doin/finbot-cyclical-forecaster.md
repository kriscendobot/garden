# Evolve finbot: a forecaster that captures cyclical / mean-reverting structure (close the eval gap)

Follow-on to `finbot-forecast-evaluation-fixtures` and the parked `finbot-richer-forecasting`. The new
evaluation harness (`packages/simulator/forecast-eval.js`) demonstrated a concrete gap: finbot's GBM-fork
ensemble forecaster is **well calibrated on GBM processes** (cov90 ~0.90, PIT KS ~0.08) but **mis-covers
cyclic oracles** (PIT KS 0.5-1.0, coverage 0.0 or 1.0) because a random walk cannot represent mean-reverting
cyclical structure.

## Goal
Add a forecaster variant that models the structure the synthesis/cyclic fixtures contain, and show it beats the
GBM forecaster on those presets under the *same* evaluation harness.

## Scope
- Candidate models: Ornstein-Uhlenbeck (mean reversion), seasonal/cyclical decomposition + residual GBM, or a
  simple regime/AR model — fit from the training window the harness already provides.
- Plug into the existing ensemble `forecast()` shape (fork-based) so `evaluateForecast` scores it unchanged.
- Deliverable includes a before/after eval table over `test/fixtures/presets.js` showing improved CRPS /
  coverage / PIT on cyclic + synthesis presets without regressing the GBM presets.
- Tested; deterministic; simulation only.

## Done when
finbot has a cyclical-structure-aware forecaster that the evaluation harness scores as better-calibrated than
GBM on cyclic/synthesis fixtures, with the comparison table in the report; tested and green.

---
claim:
  host: endolinbot
  gardener: 79
  claimed_at: 2026-06-26T06:01:48Z
