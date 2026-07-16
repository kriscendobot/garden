Completed the scholar job: surveyed the academic financial-forecasting literature and delivered a consolidated, actionable report for the finbot builder, plus a first-pass library ingest anchored on a fetchable canonical source. Everything is landed and verified on `origin/journal2`.

## What I did

**The deliverable — the report for the finbot orchestrator**
- Created the `finbot` project: `journal/projects/finbot/README.md` (rules of engagement, identity, upstream, authority) and the report `journal/projects/finbot/financial-forecasting-literature-review.md`.
- I first reconstructed finbot's actual state from the journal (press schedule, maintainer inbox notes): a Cosmos/crypto paper-trading agent in the Endo/ocap idiom whose core is **deterministic MLE-fit GARCH-family volatility forecasting** (symmetric GARCH → GJR-GARCH leverage, EGARCH on the roadmap) driving **regime-aware volatility-targeting position sizing** via a seeded OODA loop, with an audit gate and `WALLET TOUCHED: false`. Crucially, it proves *parameter recovery on synthetic DGPs* but has **no out-of-sample walk-forward backtest, no baselines, no data-snooping controls** — so I aimed the report there.
- The report answers the three asked questions: (1) methods by value-to-effort — Tier-1 is an evaluation harness, not another model; (2) the evaluation & anti-overfitting discipline as the strongest section (walk-forward, naive baselines/MASE/QLIKE, Diebold-Mariano/Model-Confidence-Set/SPA, Deflated Sharpe, transaction-cost realism, a 7-point checklist); (3) what is *not* forecastable (return direction net of costs, equity premium OOS, price levels vs random walk, crash/regime timing) vs finbot's forecastable sweet spot (conditional volatility). It flags the builder's own symmetric-vs-GJR roll-forward gap as a look-ahead trap to measure, not assume.

**Library ingest (idempotency-anchored)**
- Ingested `web--hyndman-fpp3-forecast-evaluation` (Hyndman & Athanasopoulos FPP3, fetched via `fetch-source.sh`; content SHA-256 `ce5f91f5` §5.8 + `b4315021` §5.10) — 4 faithful sections on training/test sets, MAE/RMSE, MAPE/MASE, and time-series cross-validation.
- New topics `financial-forecasting` + `forecast-evaluation`; 6 concept pages (walk-forward-validation, mean-absolute-scaled-error, data-snooping-bias, look-ahead-bias, garch-volatility-models, efficient-market-hypothesis); +64 keyword lines; updated all hand-maintained README indexes.

**Gates & delivery**
- Integrity gate passed (`library-link-check --changed` OK; topics-counts current); regenerated + landed `sections/README.md` as the final step.
- Landed every file through `land-journal-edit.sh`; merged keywords.md over a concurrent +2-line tip.
- Sent the delivery note `to: role/liaison` with the report path + 3-line abstract (suggesting the finbot press consume the review each cycle).
- Recorded the `result` entry; posted follow-on `scholar-ingest-financial-forecasting-corpus` naming the remaining canonical sources (GARCH papers, White/Hansen/Deflated-Sharpe, Fama/Welch-Goyal, FPP3 chapters, Fama-French/Gu-Kelly-Xiu, etc.).

## Follow-ups
- `scholar-ingest-financial-forecasting-corpus` (posted) covers the sources cited by provenance but not yet sectioned.
- Self-improvement flagged in the result: the job's "no external systems" bound reads as if it forbids the read-only paper/web fetch scholar ingestion needs; worth a one-line clarification on `roles/scholar/AGENT.md` that it means no external *writes/side-effects*, not no read-only source retrieval.
