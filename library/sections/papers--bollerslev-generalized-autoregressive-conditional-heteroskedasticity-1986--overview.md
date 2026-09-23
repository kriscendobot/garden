---
title: GARCH turns conditional variance into a parsimonious forecasting state
source: "Generalized Autoregressive Conditional Heteroskedasticity"
source_kind: paper
source_authors: [Tim Bollerslev]
source_year: 1986
source_venue: "Journal of Econometrics 31(3):307-327"
source_url: https://doi.org/10.1016/0304-4076(86)90063-1
source_mirror_url: https://public.econ.duke.edu/~boller/Published_Papers/joe_86.pdf
source_pdf_sha256: 60353d437aadda9179df4e7cfcc55f0dd343840b04c6ee7d83285eb33fa17e1a
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: Bollerslev's original GARCH paper makes conditional variance a dynamic state rather than a constant nuisance parameter. By adding lagged conditional variance to Engle's ARCH equation, it gives financial forecasting a compact way to represent clustered shocks and persistent uncertainty. The model forecasts dispersion, not return direction, so its practical claim belongs alongside an explicit out-of-sample scoring protocol.

ARCH lets the variance conditional on the information available at time t-1 depend on previous squared innovations. GARCH(p,q) adds previous conditional variances. This is analogous to extending an AR process to ARMA: a long declining influence of old shocks need not require a separately fitted coefficient at every lag.

The paper develops the class for economic time series and illustrates it with inflation uncertainty. Later finance work made GARCH a baseline for return-volatility forecasts, density forecasts, risk limits, and volatility-scaled exposure. That history does not convert an in-sample fit into a trading result. A production system must compare a predeclared GARCH forecast with simple alternatives using future observations and a loss appropriate to a positive variance target. See [[garch-volatility-models]] and [[walk-forward-validation]].

Source: Tim Bollerslev, *Generalized Autoregressive Conditional Heteroskedasticity*, Journal of Econometrics 31(3):307-327 (1986), doi:10.1016/0304-4076(86)90063-1; ingested from the author's Duke University PDF, sha256 `60353d43`.
