---
title: Inverse-variance volatility-managed rule
source: "Volatility-Managed Portfolios"
source_kind: paper
source_authors: [Alan Moreira, Tyler Muir]
source_year: 2017
source_venue: "Journal of Finance 72(4):1611-1644"
source_url: https://doi.org/10.1111/jofi.12513
source_pdf_sha256: 679361ac28d0ca70b2530f4f621b56eaea44427cec65a44baf436dd40c049d8a
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The implementable baseline sets next month's factor exposure proportional to the inverse of variance realized during the prior month, then chooses a constant so the managed and unmanaged factor have equal unconditional standard deviation. This clean timing boundary prevents future information from entering the rule.

For factor return `f[t+1]` and information known at month end `t`, the basic managed return is `c / RV[t]^2 * f[t+1]`, where `RV[t]^2` is variance estimated from the factor's daily returns in month `t` and `c` equalizes unconditional volatility. The deliberately simple primary specification uses lagged realized variance rather than a fitted conditional-variance equation. The authors also test forecasted variance and lower-turnover variants, but the simple rule matters because it is reproducible in real time without selecting a complex volatility model.

This is exposure scaling, not a signal to go short after volatility rises. It can require leverage in tranquil periods and deleveraging after a shock, so a deployment must state leverage, turnover, rebalance, and funding constraints. A GARCH, HAR, or EWMA forecast can replace the crude lagged realization only if it improves the entire held-out policy after those costs.

Source: [Volatility-Managed Portfolios](https://doi.org/10.1111/jofi.12513), sections 3.1-3.2, author-university PDF version.
