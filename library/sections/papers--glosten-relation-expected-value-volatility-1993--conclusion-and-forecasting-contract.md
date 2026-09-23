---
title: Conclusion and forecasting contract
source: "On the Relation between the Expected Value and the Volatility of the Nominal Excess Return on Stocks"
source_kind: paper
source_authors: [Lawrence R. Glosten, Ravi Jagannathan, David E. Runkle]
source_year: 1993
source_venue: "Journal of Finance 48(5):1779-1801"
source_url: https://doi.org/10.1111/j.1540-6261.1993.tb05128.x
source_pdf_sha256: 45b59e57d2f8801cc1f956fde7d78f5e8e6c1e7f68e9f3e9d81ee72423391317
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The GJR paper concludes that a standard symmetric GARCH-M can conceal economically relevant asymmetry and that the conditional risk-return relation is weakly negative in its monthly sample. Its durable lesson for forecasting is methodological: compare competing variance recursions on the decision-relevant horizon before interpreting a fitted mean or variance parameter.

The result does not settle whether expected returns rise with risk in every setting. It relies on a particular information set, monthly market-index data, and a collection of parametric conditional-variance assumptions. The authors explicitly contrast their evidence with results from daily data and with competing estimates in the literature.

An implementation should keep the distinction intact: use GJR-GARCH as a leverage-aware volatility candidate, compare it with symmetric GARCH, EGARCH, and simpler baselines on held-out data, and treat a variance forecast as input to risk sizing unless a separate first-moment evaluation demonstrates dependable directional value.

Source: Glosten, Jagannathan, and Runkle 1993, section IV, canonical DOI [10.1111/j.1540-6261.1993.tb05128.x](https://doi.org/10.1111/j.1540-6261.1993.tb05128.x); readable PDF [University of Washington course copy](https://faculty.washington.edu/ezivot/econ589/GJRJOF1993.pdf), sha256 `45b59e57d2f8`.
