Completion report below.

---

# Job complete: finbot-forecast-evaluation-fixtures

Evolved **kriscendobot/finbot** (bot repo, bot identity, simulation-only) to add seeded synthetic-oracle fixtures, a forecast-evaluation harness, a risk/reward sweep parameterized by user volatility tolerance, and yield/dividend/growth instrument types. **Landed on `origin/main` (`ce2ee29`)**, fast-forwarded cleanly from the base. Full suite **270 tests green** (131 baseline + **45 new**, 0 failures).

## What I built (all under `packages/simulator/`)
1. **`fixtures.js`** — seeded, reproducible generators with *known* parameters: `cyclicSeries` (frequency/amplitude/phase/drift), `gbmSeries` (GBM with drift μ / volatility σ, log-normal steps), `synthesisSeries` (superposed cycles of differing period+amplitude atop a GBM trend, so volatility and cyclicality dial independently), and `blockBootstrapSeries` (resample a **user-supplied historical / speculated** series). Named presets in `test/fixtures/presets.js`.
2. **`forecast-eval.js`** — scores the ensemble forecaster against the realized distribution the *same* known process produces: **CRPS**, **pinball loss**, **interval coverage / hit-rate**, **PIT uniformity (KS)**, **point error**. `fitGbm` → `evaluateForecast` → `evalTableOverPresets`.
3. **`risk-reward.js`** — user **volatility tolerance** `τ∈[0,1]` as a mean-variance certainty-equivalent; `chooseStrategy` / `toleranceFrontier`; two tolerance-elicitation sketches (worst-acceptable drawdown; single lottery choice).
4. **`instruments.js`** — growth / yield / dividend return shapes over a price series, `mixReturns`, `instrumentReturnDistribution` (driven from synthetic *or* user/historical series).
5. **`evaluation.js`** + **`bin/finbot-eval`** — the core deliverable wiring the forecast-eval table and the risk/reward frontier over the three instrument types; `renderEvaluationText` formats it. Exports + `package.json` subpaths + README updated; root `npm run finbot-eval` added.

## What the evaluation shows
- **Forecaster recovers the GBM distribution it should** — given adequate history: cov90 ≈ **0.90**, PIT-KS ≈ **0.08**, relPointError < 1%.
- **Honest gap surfaced**: the GBM-fork forecaster **mis-covers cyclic oracles** (PIT-KS 0.5–1.0, coverage 0.0 or 1.0) — a random walk can't represent mean-reverting cyclical structure. Synthesis presets sit in between. Also surfaced: GBM **drift** is hard to estimate from a short window (sampling error dominates calibration), so the harness fits from a longer training window by default.
- **Risk/reward frontier**: growth is highest-risk (σ≈0.26, worst-drawdown −0.50); yield lowest (σ≈0.07); a **diversified growth+yield mix dominates** either alone (best reward ≈0.089 at moderate risk). The tolerance sweep picks yield at low appetite and the mix from τ≥0.2 upward — growth-alone is inadmissible (dominated).

## Follow-on jobs posted (to the board)
- `finbot-volatility-tolerance-elicitation` — real elicitation/calibration UX from the sketches.
- `finbot-richer-instrument-models` — yield curves, dividend dynamics, fees/taxes/reinvestment, historical-data ingestion (relates to parked `finbot-additional-instruments`).
- `finbot-cyclical-forecaster` — an OU/seasonal/regime forecaster to close the cyclic-coverage gap, scored by this same harness (relates to parked `finbot-richer-forecasting`).

## Notes / follow-ups
- Cross-referenced both parked plans in the README and the follow-on jobs.
- The fresh worktree needed `npm install` to link the `@finbot/*` workspace (pipeline imports by package name); `package-lock.json` left untracked per finbot convention. Dispatch worktree torn down; only the bare clone remains. No agoric-sdk, no funds/keys touched.
