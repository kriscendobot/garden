---
role: scholar
---
# Scholar: survey academic literature on financial forecasting — report for the finbot orchestrator

Study the academic literature on **financial forecasting** and produce a consolidated,
actionable report to inform the **finbot** effort (the `finbot-progress` press-driver on
`kriscendobot/finbot`; garden tracker kriskowal/garden#54).

## Scope — what to survey
The substantive academic literature on financial / market forecasting, covering at least:
- **Classical time-series**: ARIMA/SARIMA, exponential smoothing, GARCH-family volatility,
  state-space / Kalman filtering.
- **Econometric / factor models**: Fama-French factors, VAR/VECM, cointegration.
- **Machine-learning forecasting**: gradient-boosted trees, LSTM/temporal-CNN, transformers for
  time series; feature engineering for financial series.
- **Evaluation methodology (highest value for finbot)**: walk-forward / expanding-window
  backtesting, strict out-of-sample discipline, look-ahead & survivorship bias, data-snooping /
  multiple-testing corrections (White's Reality Check, Hansen SPA), transaction-cost realism,
  proper skill metrics (directional accuracy, Sharpe, MASE vs a naive baseline).
- **Efficient-market considerations & limits of predictability**: what the literature holds is and
  is not forecastable; regime change / non-stationarity.
Prefer peer-reviewed papers and canonical texts; record per-source provenance.

## Ingest into the library (the scholar's normal output)
Ingest the key sources into `journal/library/` per `journal/library/conventions.md` (source-index,
topic, and concept files; update the README indexes and `keywords.md`). Partition cleanly; prefer
many small files to one long file; abstract-at-the-top.

## The report — the deliverable FOR the finbot orchestrator
Write a consolidated report at
**`journal/projects/finbot/financial-forecasting-literature-review.md`** (create the `finbot`
project per `context-library` conventions if absent), aimed squarely at the finbot BUILDER effort —
an actionable synthesis, not a lit-dump:
- which methods/approaches are worth finbot adopting, and in what order of value-to-effort;
- the evaluation & anti-overfitting discipline finbot MUST follow (backtest design, baselines, bias
  avoidance) — make this the strongest section;
- what the literature says is NOT reliably forecastable, and the pitfalls to avoid.
Cite the library entries you created (relative links).

## Deliver to the finbot orchestrator
The finbot orchestrator is the `finbot-progress` press-driver. A scholar writes only to the journal
(no GitHub / no fork actions), so deliver by (a) leaving the report at the path above, and (b)
sending a message-bus note `to: role/liaison` with the report path and a 3-line abstract, so the
liaison can wire the finbot press to consume it each cycle. Record a `result` entry.

## Bounds
Standard scholar bounds (`roles/scholar/AGENT.md`): journal-only writes (`library/`, `projects/`,
`entries/`); no sub-agent dispatch; no external systems. If the survey fans out beyond this cycle's
budget, write what is supported and post a follow-on `scholar-*` job for the remainder.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  worker_kind: gardener
  claimed_at: 2026-07-16T23:05:36Z
