---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T05:19:04Z
---
Scholar cycle scholar-ingest-financial-forecasting-corpus-13: ingested White 2000, "A Reality Check for Data Snooping" (Econometrica 68(5):1097-1126), the twelfth financial-forecasting-corpus paper and the first multiple-model data-snooping correction — the correction the Diebold–Mariano test does not make.

Source ingested (5 sections):
- library/sources/papers--white-reality-check-data-snooping-2000.md (new; PDF sha256 675eb3226dee, fetched direct from the Wisconsin Econ 718 course copy of the Econometrica original; canonical DOI 10.1111/1468-0262.00152).
  1. overview-and-the-data-snooping-null — the data-snooping hazard (newsletter scam, single-history time series) and the search-aware null: the best model in a specification search has no predictive superiority over a benchmark; controls the simultaneous error rate.
  2. framework-and-the-max-statistic — builds on Diebold–Mariano 1995 and West 1996; the l-vector of relative-performance moments, the null max_k E[f_k*] <= 0, and the extreme-value statistic V_l = max_k sqrt(n) f_k enforced at the least-favorable configuration.
  3. monte-carlo-and-bootstrap-reality-checks — the Monte Carlo Reality Check (sample N(0,V-hat)) and the preferred Politis–Romano stationary-bootstrap Reality Check (coefficients need not be recomputed; Theorem 2.3); Sharpe/R^2 via the delta method.
  4. sp500-illustration-and-the-naive-p-value — 3,654 technical-indicator models vs a constant-only EMH benchmark; naive directional p=.0036 collapses to a search-corrected Reality Check p=.2040; the gap directly estimates the data-mining bias; EMH not rejected in either experiment.
  5. placement-and-the-correction-lineage — the pairwise (DM) -> best-of-N (Reality Check) -> model-set (SPA/MCS) lineage; the risk-forecast vs directional-return distinction preserved via White's own MSE and directional experiments; West 1996 flagged as the un-ingested estimated-parameter node.

Topic/concept pages touched:
- topics/forecast-evaluation.md, topics/financial-forecasting.md — 5 section rows each.
- concepts/data-snooping-bias.md — 4 section rows (overview, both Reality Checks, S&P 500 naive-p, lineage).
- concepts/diebold-mariano-test.md — 2 section rows (max-statistic generalization, correction lineage).
- sources/README.md — new paper row. keywords.md — added "bootstrap reality check", "Bootstrap Reality Check", "Monte Carlo Reality Check", "naive p-value", "data mining" -> data-snooping-bias.

Conditional-volatility/risk-forecast vs directional-return distinction preserved: the placement section makes it explicit that a Reality Check on a variance loss (QLIKE) speaks to risk-forecast quality while one on a return/direction loss speaks to directional quality, illustrated by White's own two experiments; neither is a variance-forecast comparison.

Integrity gate (step 8): library-link-check.sh --source-slug papers--white-reality-check-data-snooping-2000 -> OK (all 6 links resolve to committed files). regenerate-topics-counts.sh --check -> counts current after the step-9 regeneration.

Regenerated projected indexes (step 9): sections/README.md flat index regenerated and landed via regenerate-sections-index.sh (White cluster projected, 6 entries); topics/README.md Index Sections-count column reconciled current via regenerate-topics-counts.sh.

Follow-on posted: scholar-ingest-financial-forecasting-corpus-14 — prefers, in order, West 1996 "Asymptotic Inference About Predictive Ability" (the estimated-parameter-uncertainty pillar White builds on, referenced but unsourced), Hansen, Lunde & Nason 2011 "The Model Confidence Set" (completes the correction lineage), or Andersen & Bollerslev 1998 "Answering the Skeptics" (volatility alternative).

Deferred backlog: none beyond the corpus-14 follow-on; the White paper was a full one-cycle ingest.
