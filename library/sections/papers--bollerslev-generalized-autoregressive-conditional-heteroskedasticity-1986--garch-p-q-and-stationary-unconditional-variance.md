---
title: GARCH(p,q) and stationary unconditional variance
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

Abstract: GARCH(p,q) forecasts the next conditional variance as a positive constant plus q past squared innovations and p past conditional variances. The stationarity condition, the total ARCH and GARCH weight below one, makes its unconditional variance finite. This is both a model constraint and an evaluation guardrail: a forecast system must reject parameterizations whose implied long-run risk is undefined.

Writing h_t for conditional variance and epsilon_t for an innovation, the model is h_t = alpha_0 + sum(alpha_i epsilon^2_{t-i}) + sum(beta_j h_{t-j}), with nonnegative coefficients. ARCH(q) is the special case with no lagged h term. Under the stated root condition, the model has an ARCH(infinity) representation with declining weights, explaining why it can express a long memory-like shock response using few coefficients.

Bollerslev proves wide-sense stationarity when A(1)+B(1) is below one, yielding unconditional variance alpha_0 divided by one minus that sum. This condition should be checked after fitting, not merely assumed. It ensures the variance forecast mean-reverts instead of silently carrying an explosive risk state into a backtest or position-sizing rule. See [[garch-volatility-models]].

Source: Bollerslev 1986, sections 2 and appendix, doi:10.1016/0304-4076(86)90063-1; author-hosted PDF sha256 `60353d43`.
