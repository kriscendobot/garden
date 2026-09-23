---
title: Market-dependent results: GARCH survives FX but loses IBM to leverage models
source: "A Forecast Comparison of Volatility Models: Does Anything Beat a GARCH(1,1)?"
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde]
source_year: 2005
source_venue: "Journal of Applied Econometrics 20(7):873-889"
source_url: https://doi.org/10.1002/jae.800
source_pdf_sha256: 3eeed6014f705dc0a192cc47822921b1d59a062267ca96ee25c6ee24f54c8099
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The headline is deliberately two-sided. For DM-dollar exchange rates, the SPA evidence does not reject GARCH(1,1), which is among the best sample performers. For IBM stock returns, SPA finds GARCH(1,1) significantly inferior under nearly all losses; the successful specifications primarily accommodate the leverage effect, with A-PARCH(2,2) the strongest overall performer. Repeating the IBM comparison with six other realized-variance measures leaves the direction of the result intact.

The result reframes GARCH as a baseline that can be robust in one market and inadequate in another, not as a permanent winner or loser. A symmetric variance recursion misses a predictable return-sign asymmetry in the IBM sample. The authors also find less uniform evidence for Gaussian versus t innovations and nearly identical performance across their mean specifications.

For financial forecasting, evaluate the exact instrument class and use case. A GJR-GARCH or EGARCH candidate earns its place when a leverage-sensitive data set and selection-aware holdout test justify it. See [[garch-volatility-models]]; the paper's conditional conclusion is more useful than a one-size-fits-all model recommendation.
