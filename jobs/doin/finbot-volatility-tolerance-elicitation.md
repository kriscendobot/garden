# Evolve finbot: volatility-tolerance elicitation UX (infer/calibrate the user's risk appetite)

Follow-on to `finbot-forecast-evaluation-fixtures` (landed on finbot main: `packages/simulator/risk-reward.js`,
`evaluation.js`). That slice represents a user **volatility tolerance** `tau in [0,1]` as a mean-variance
certainty-equivalent and drives the risk/reward frontier from it, with two deterministic elicitation **sketches**
(`inferToleranceFromMaxDrawdown`, `inferToleranceFromLottery`). This job builds the real elicitation UX.

## Goal
Turn the sketches into a usable elicitation/calibration flow that yields a calibrated `tau` (and a confidence
band on it) to drive the planner's risk/reward optimization.

## Scope
- A short adaptive **lottery-ladder** interaction (sequence of 50/50 gamble-vs-certain choices) that bisects the
  user's risk-aversion `lambda` and converges to a `tau` with a stated uncertainty; reuse `toleranceFromRiskAversion`.
- Alternative inputs: stated worst-acceptable drawdown, target Sharpe, or a direct slider — reconcile multiple
  signals into one posterior `tau`.
- Persist the elicited profile (per-user) and let the planner read it; re-calibration cadence.
- Keep deterministic + tested; simulation only, no funds. Sketch the actual terminal/chat UX surface (liaison
  interaction) but the harness-level inference is the deliverable.

## Done when
finbot can elicit a calibrated volatility tolerance from a bounded interaction, persist it, and the planner
consumes it; tested and green.

---
claim:
  host: endolinbot
  gardener: 56
  claimed_at: 2026-06-26T06:01:13Z
