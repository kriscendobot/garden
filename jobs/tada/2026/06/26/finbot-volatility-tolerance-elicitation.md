Inbox empty, worktree torn down, work pushed. Done.

---

## Completion report: `finbot-volatility-tolerance-elicitation`

Built the real volatility-tolerance elicitation/calibration flow on top of the prior `risk-reward.js` sketches. Pushed to **finbot `main`** as `343a4d5` (fast-forward from `ce2ee29`). All **301 package tests green**; no lint/CI config exists in the repo, so "green" = the test suite.

### What I built
- **`packages/simulator/elicitation.js`** (new, pure — no clock/I/O/RNG):
  - **Adaptive lottery ladder** — a sequence of 50/50 gamble-vs-certain choices that *bisects* the user's mean-variance risk-aversion `lambda` and maps it to `tau` via the existing `toleranceFromRiskAversion`, with a confidence band from the residual bracket. Exposed both as a step-wise state machine (`startLotteryLadder`/`nextLotteryQuestion`/`answerLotteryQuestion`/`ladderEstimate`) and a `runLotteryLadder` driver. Payoffs are **fractional returns** so `lambda` shares `risk-reward.js`'s units and every rung's certain amount stays inside the gamble's own range (fixed an absurd "guaranteed −$2900" artifact the naïve dollar framing produced).
  - **Multi-signal reconciliation** (`reconcileSignals`) — folds the ladder, a stated worst-acceptable drawdown, a target Sharpe hurdle, a direct slider, and a one-shot lottery into **one posterior `tau`** by inverse-variance (precision) weighting; agreeing signals tighten the band, a confident signal dominates a vague one.
  - **Re-calibration cadence** (`recalibrationStatus`) — due on elapsed cadence or too-wide confidence band.
- **`packages/simulator/risk-reward.js`** — added `inferToleranceFromTargetSharpe` to the inference family.
- **`packages/simulator/profile-store.js`** (new) — per-user profile shape + JSON codec + fs-backed `ProfileStore` (injected clock for determinism; userId path-traversal sanitized).
- **`packages/simulator/elicitation-ui.js`** (new) — pure render/parse helpers sketching the **terminal/chat (liaison) surface**.
- **`packages/pipeline/profile-allocation.js`** (new) — **the planner consumes the profile**: `selectAllocationForProfile` picks among frontier candidates by the profile's `tau`; `planForProfile` formalizes it through the existing deterministic `plan()` (hash-stable, untouched core).
- **`bin/finbot-elicit`** (new) — the usable end-to-end flow: interactive ladder + optional signals, persists the profile; `--auto=LAMBDA` non-interactive simulated user; `--show`.
- Wired exports/`package.json` for both packages; documented a new **"Volatility-tolerance elicitation"** section in the simulator README.

### Verification
- Truthful-simulated-user test recovers a known `lambda` (the bisection invariant); `--auto=3.0` → `tau≈0.25` as designed.
- 47 new tests across 4 files (ladder, signals, reconciliation, recalibration, store round-trip/traversal-safety, UI render/parse, profile-driven planning, proposal-hash determinism).

### Notes / follow-ups
- Committed explicit pathspecs only; `package-lock.json` (created by a local `npm install` to resolve workspace symlinks) is untracked upstream and was deliberately not committed.
- The pipeline seam takes allocation **candidates carrying `targetWeights`**; today's `instrumentCandidates` emit `{id, reward, risk}` without weights. A natural next slice is to have the analyzer/forecaster annotate each candidate allocation with its realizing weights so `planForProfile` can drive the live OODA cycle directly.
