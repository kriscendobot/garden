Inbox empty. Work complete.

---

## Completion report: `finbot-richer-forecasting`

**Outcome:** Grew finbot's forecaster from an independent-walk GBM Monte Carlo into the richer ensemble engine the role brief + `designs/ensemble-forecasting.md` called for, and gave it the deterministic visual projection it never had. Landed on `kriscendobot/finbot` **`main`** as a clean fast-forward (commit `e9234ee`), per finbot's own "push directly to main, no PR against itself" convention. Full suite green: **225 passing, 0 failing**.

### What I built (all under the determinism contract — seeded sfc32 only, never `Math.random`)

New `@finbot/simulator` modules:
- **`correlation.js`** — Cholesky factorization (`L·Lᵀ=R`) + correlated-shock application. `GBMPriceFeed` now runs its per-tick shock vector through `L` when a `correlations` spec is supplied (sparse pair-map, nested-map, or full matrix; rejects non-positive-definite/inconsistent requests). The draw count per tick is unchanged, so **the uncorrelated path stays byte-for-byte identical** to the prior independent walk (proven by a test).
- **`vol-surface.js`** — empirical volatility surface (bootstrap of realized vol), sampled per tick from a *separate* seeded RNG stream so the price-shock schedule is undisturbed; `surfaceFromPriceHistory()` derives it from a price history.
- **`costs.js`** — size-aware slippage + jittered gas-cost noise, both seeded.
- **`bootstrap.js`** — bootstrap confidence bands (`{point, lo, hi, stderr}`) on the noisy tail quantiles (p01/p99).
- **`path-stats.js`** — per-trajectory max-drawdown + time-to-recovery; `forecast()` aggregates these into `pathStats` distributions + recovery rate.
- **`histogram-svg.js`** — dependency-free, byte-deterministic SVG renderer (`report` + `compact` styles) with p05–p95/p25–p75 quantile-band overlays, p50 line, and a drawdown panel.

`forecast()` now emits `quantileBands`, `pathStats`, and an optional `projectionSvg`.

Pipeline (`@finbot/pipeline/forecaster.js`):
- `project()` carries the new fields and attaches the SVG.
- **`writeForecastArtifacts()`** honors the role brief's output shape: `histogram_path` (`<id>.json`) + `projection_path` (`<id>.svg`), where `<id>` is a SHA-256 over the canonical artifact JSON — so the auditor can recompute the id and verify a cited projection. The fs surface is injected, never hard-imported.

### Verification
- 8 new test suites incl. realized-correlation convergence, vol-surface spread-widening, end-to-end render determinism, and artifact id stability.
- Confirmed the SVG is well-formed XML and re-renders byte-identically across runs.
- Recorded the chosen implementations in `designs/ensemble-forecasting.md` (§ Notes from the field) and `skills/histogram-projection-render/SKILL.md` (lifted out of "stub").

### Notes / follow-ups
- I excluded the `package-lock.json` my `npm install` generated — the repo intentionally ships none (all deps are local 0.0.0 workspaces); `npm install` re-creates the symlinks on demand.
- Deferred (left as open axes in the design): GARCH/implied vol surfaces, PNG rasterization of the SVG, and far-ref vending of large forecasts to the analyzer.
- The slippage/gas cost helpers are wired and tested but not yet threaded into the pipeline's `makeRebalanceAction` fills — a natural next build if the planner wants friction baked into the per-child rebalance.
