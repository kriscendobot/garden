---
title: GJR asymmetric variance recursion
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

Abstract: GJR-GARCH adds a sign indicator to the squared-shock term, allowing a negative innovation to revise next-period variance differently from an equally large positive innovation. This gives the leverage effect a directly estimable recursion while retaining the familiar conditional-variance forecasting state.

The modified GARCH-M model includes an intercept, lagged conditional variance, squared unanticipated return, and an interaction of that squared return with an indicator for a negative surprise. It may also include seasonal dummies and the lagged nominal interest rate. The indicator term is the central GJR move: it tests whether bad news changes the variance forecast more than good news of equal magnitude rather than forcing the symmetric GARCH response.

The model is valuable as a candidate specification, not as a default winner. Its added parameter changes the forecast curve and must be judged against an explicit out-of-sample benchmark. It also separates an asymmetric second-moment response from a claim that the first-moment return itself is predictably positive or negative.

Source: Glosten, Jagannathan, and Runkle 1993, sections II-III, canonical DOI [10.1111/j.1540-6261.1993.tb05128.x](https://doi.org/10.1111/j.1540-6261.1993.tb05128.x); readable PDF [University of Washington course copy](https://faculty.washington.edu/ezivot/econ589/GJRJOF1993.pdf), sha256 `45b59e57d2f8`.
