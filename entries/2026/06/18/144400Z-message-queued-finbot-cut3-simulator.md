---
ts: 2026-06-18T14:44:00Z
kind: message
role: liaison
host: endolinbot
refs:
  - entries/2026/06/18/143200Z-dispatch-architect-e00710.md
---

# queued: finbot cut 3 (self-improvement simulator + meta-circular framework)

User directive (verbatim): "For the next cut, we need a
self-improvement feedback loop. To that end, we need a
simulator, to run the loop continuously using a combination of
automation and inference. For that we need a simulated
portfolio, simulated price feed, and we need to empower the
agent to run simulations with simulated portfolios and price
feeds so it can make forecasts and so that we as an outside
observer can measure the efficacy. There is simulation and
meta simulation. The framework for these can be meta-circular.
Please dispatch a subagent to implement this third cut, chained
on the completion of the second."

Chained on architect `e00710` (cut 2 harness). When `e00710`
returns, the liaison dispatches a new architect agent with the
following brief.

## Cut 3 brief

Implement a self-improvement simulator built on top of the cut-2
harness, with a meta-circular framework that supports both
simulation (at one level) and meta-simulation (sims-of-sims).

### Requirements

1. **Simulated portfolio**: a deterministic in-memory portfolio
   data structure. Balance state, history of trades, P&L,
   risk metrics. No on-chain calls; fed by simulated prices.
2. **Simulated price feed**: a deterministic price-generation
   process (geometric Brownian motion + seeded RNG; or replay
   from a fixture CSV). Provides a `tick()` API the simulator
   advances.
3. **Simulator runner**: drives the OODA loop continuously
   against the simulated portfolio + price feed. Each tick:
   - Advance the price feed
   - Let the harness run one OODA iteration
   - Record observations
   - Compute efficacy metrics (P&L, drawdown, Sharpe,
     etc. — best-guess metrics; user can refine later)
4. **Forecasting empowerment**: the agent itself can spawn a
   *nested* simulation to forecast a proposed action. The
   nested simulator runs N futures under the price-feed
   model + seeded RNG variants, aggregates the histogram of
   outcomes (the cut-1 "ensemble forecasting" + Monte Carlo
   skill), and returns the distribution to the planner.
5. **Meta-circular framework**: the same `runSimulator(world)`
   primitive should be usable at both levels — the outer
   simulator runs the harness against simulated reality; an
   inner simulator (spawned by the planner) runs the harness
   against a simulated future. The shape:
   ```js
   const { tick, observe, fork } = runSimulator(world);
   // world: { portfolio, priceFeed, harnessConfig }
   // tick(): advances one OODA cycle
   // observe(): returns current state + metrics
   // fork(seed): clones world with new RNG seed for nested
   //   simulation
   ```
6. **External observer**: emit a stream of metrics suitable
   for plotting (CSV or JSONL). The cut-1
   `histogram-projection-render` skill consumes this to
   produce the visual outputs.
7. **Self-improvement loop**: at the end of each
   batch-of-ticks, the harness reflects on the recorded
   observations + efficacy metrics and produces a
   `journal/entries/.../self-improvement-*.md` note proposing
   one or more rule/skill changes. The next batch picks up
   the changes (via journal-sync). Bound the proposals to
   small, testable changes (e.g., "the analyzer should
   weigh momentum signal at 0.7 not 0.5" rather than
   wholesale rewrites).

### Files to land

```
packages/simulator/
  package.json (@finbot/simulator)
  README.md
  index.js
  world.js                — World shape (portfolio + price feed + harness config)
  portfolio.js            — Simulated portfolio impl
  price-feed.js           — Deterministic GBM + replay impl
  runner.js               — runSimulator(world) primitive (meta-circular)
  metrics.js              — efficacy metrics (P&L, drawdown, Sharpe)
  forecast.js             — nested simulation for forecasting (Monte Carlo over fork())
  self-improvement.js     — reflection + proposal generator
  test/
    portfolio.test.js
    price-feed.test.js
    runner.test.js
    forecast.test.js
    self-improvement.test.js
    integration.test.js   — long-running sim (100 ticks); efficacy metrics emit

bin/finbot-sim          — entry script: bin/finbot-sim --ticks=1000 --seed=42
```

### Commit shape (one per logical unit, checkpoint + push each)

1. `feat(simulator): World + Portfolio + PriceFeed primitives`
2. `feat(simulator): runSimulator with tick/observe/fork (meta-circular)`
3. `feat(simulator): efficacy metrics (P&L, drawdown, Sharpe)`
4. `feat(simulator): Monte Carlo forecast via nested fork`
5. `feat(simulator): self-improvement reflection + proposal generator`
6. `test(simulator): integration test for 100-tick sim with metrics emit`
7. `feat: bin/finbot-sim entry script`

### CRITICAL: checkpoint discipline

Push after each commit. If approaching budget ceiling, STOP
and write partial result.

### Out of scope

- Real on-chain wallet operations.
- Live RPC URLs.
- Real RNG entropy (everything is seeded).
- Touching garden, endo-but-for-bots, or other repos.

### Deliverable

A `result` entry in the GARDEN's journal with:
- Per-commit substance.
- Meta-circular framework shape (the `runSimulator` API).
- Self-improvement loop shape (what's observed → what's
  proposed → how it lands).
- Integration test results (sim ran N ticks, emitted M
  metric rows, generated K self-improvement proposals).
- `Self-improvement: ...` line.
- Recommended next stage.

## Trigger condition

When the orchestrator sees architect `e00710` (cut 2)
complete, it dispatches a new architect with the brief above.
Use the cut-2 harness primitives (tool registry, OODA loop,
spawn, message bus, observation recorder) as the foundation;
the simulator wraps them.
