---
title: Information set and GARCH-M identification
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

Abstract: The paper identifies the hidden-information problem in estimating a mean-variance relation: the econometrician's information set can be smaller than investors' information set, so a regression on an estimated variance need not recover the structural risk-return coefficient. GARCH-M is a strong identifying assumption, not merely a convenient forecasting algorithm.

The conditional-mean equation relates next-period excess return to variance assessed at the forecast origin. But if the econometrician observes only a coarser information set, the projected variance includes measurement error. Unless that error behaves suitably, the mean equation's coefficient cannot be consistently interpreted as the underlying risk-return coefficient. The paper contrasts an instrumental-variable approach, which imposes a particular restriction on the unobserved variance error, with GARCH-M, which assumes the variance-relevant state can be estimated from its chosen information set.

For a forecaster this means that a fitted conditional-variance series is not automatically an observed target or an identified economic quantity. State the origin-time inputs, the variance proxy used for evaluation, and the loss function. Otherwise a statistically tidy GARCH-M estimate may be answering a different question from the trading or risk-control decision it is used to justify.

Source: Glosten, Jagannathan, and Runkle 1993, sections I-II, canonical DOI [10.1111/j.1540-6261.1993.tb05128.x](https://doi.org/10.1111/j.1540-6261.1993.tb05128.x); readable PDF [University of Washington course copy](https://faculty.washington.edu/ezivot/econ589/GJRJOF1993.pdf), sha256 `45b59e57d2f8`.
