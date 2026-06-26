# Evolve finbot: synthetic oracle time-series fixtures to evaluate the ensemble forecaster (risk/reward, volatility tolerance, instrument types)

Wear the **builder** role (goal-oriented: build the core, decompose the rest). Evolve
**`kriscendobot/finbot`** (bot repo, bot identity) to add **test-oracle time-series fixtures** and
an **evaluation harness** for the **Monte Carlo ensemble forecaster** (`packages/simulator/`).
Everything here is **simulation only** — no real funds/wallet/keys; dry-run discipline; no
agoric-sdk. Relates to the parked finbot plans `finbot-richer-forecasting` and
`finbot-additional-instruments` (this is the concrete evaluation slice; cross-reference them).

## Goal

Measure how well finbot's **ensemble forecast system predicts outcomes** from **consistent but
random** input behaviors (seeded → reproducible), and use that to find strategies with a good
**balance of risk for reward** calibrated to the **user's tolerance for volatility**.

## 1. Synthetic oracle time-series fixtures (seeded, reproducible)

Add generators (in `simulator/price-feed.js` / a new `fixtures` module) producing test oracle
series, **consistent but random** (deterministic from a seed):
- **Cyclic** — sinusoidal with configurable **frequency, amplitude, phase** (and optional drift).
- **Brownian multiplicative motion** — geometric Brownian motion (GBM): configurable **drift μ**
  and **volatility σ** (multiplicative, log-normal steps).
- **Synthesis** — a composition of cyclic + GBM with **varying frequencies and amplitudes**
  (superposed cycles of different periods atop a GBM trend), parameterized so volatility and
  cyclicality can be dialed independently.
Fixtures live under the simulator's test/fixtures with named, parameterized presets.

## 2. Forecast-evaluation harness

Feed each synthetic series into the **ensemble forecaster**, then **score its predictions against
the realized outcome** the same generator produced: calibration / coverage of the histogram
projection, interval hit-rate, and error metrics (e.g. CRPS or pinball loss for the distribution,
plus point error). Because the generating process is known, you can measure whether the ensemble
**recovers the distribution it should**. Report a small eval table across the fixture presets.

## 3. Risk/reward balance + the user's volatility tolerance

- Represent a **user volatility-tolerance** parameter (risk appetite) and have the analyzer/planner
  optimize for a **good risk-for-reward balance** under it — not max return, not min risk, but the
  balance the user's tolerance implies. Evaluate strategy outcomes across a sweep of
  volatility-tolerance settings to show the trade-off frontier (risk vs reward).
- Sketch how finbot would **elicit / infer** the user's volatility tolerance (an input or a
  calibration interaction) — enough to drive the evaluation; full UX can be a follow-on.

## 4. Instrument types

Model instruments that produce different return shapes, so strategies yield various outcomes:
**yield-bearing** (periodic yield/interest), **dividend-paying** (discrete payouts), and **growth**
(capital appreciation only). Let a strategy mix them. Drive them from **historical data — either
provided by the user or the user's speculation about upcoming trends** for instruments of interest
(accept a user-supplied or user-speculated series as an input alongside the synthetic fixtures).

## Bounds & decomposition

- Simulation/dry-run only; bot repo; no agoric-sdk; no real funds. Keep finbot's tests green; add
  tests for the generators (statistical properties: GBM log-return mean/variance, cycle period/
  amplitude) and the evaluator. This is large — land the **fixtures + evaluation harness + a
  risk/reward sweep over the three instrument types** as the core, and **post follow-on
  `finbot-<area>` jobs** for the deeper pieces (volatility-tolerance elicitation UX, richer
  instrument models). Follow finbot's conventions (read its `CLAUDE.md`).

## Definition of done

finbot has seeded synthetic oracle fixtures (cyclic / GBM / synthesis with varying freq+amplitude),
an evaluation harness scoring the ensemble forecast against known-process outcomes, a risk/reward
sweep parameterized by user volatility tolerance, and yield/dividend/growth instrument types driven
by historical-or-speculated series — tested and green, with follow-on jobs posted for the rest.
Report what the eval shows about the forecaster and the risk/reward frontier.

Posted by the liaison on behalf of the maintainer.

---
claim:
  host: endolinbot
  gardener: 64
  claimed_at: 2026-06-26T05:44:12Z
