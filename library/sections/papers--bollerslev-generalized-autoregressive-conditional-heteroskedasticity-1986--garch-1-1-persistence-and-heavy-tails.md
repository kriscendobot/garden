---
title: GARCH(1,1), persistence, and heavy tails
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

Abstract: The parsimonious GARCH(1,1) recursion combines yesterday's squared shock with yesterday's variance estimate. Its alpha-plus-beta persistence controls how quickly uncertainty decays, while its moment conditions explain how conditionally normal shocks can still produce unconditional fat tails. This makes the model a credible baseline, not a presumption that its persistence parameter will forecast every market.

For GARCH(1,1), h_t = alpha_0 + alpha_1 epsilon^2_{t-1} + beta_1 h_{t-1}. The paper shows alpha_1 + beta_1 below one is sufficient for finite variance and derives stronger conditions for higher moments. Lagged h gives a geometric, adaptive-learning response: a large shock raises the state, then beta governs its decay. The resulting unconditional distribution can be leptokurtic even with normal conditional innovations.

This division is operationally useful. A GARCH forecast says uncertainty is state-dependent; it does not assert a conditional expected return, an efficient directional signal, or a guaranteed tail model. In forecast evaluation, retain GARCH(1,1) as a low-complexity benchmark and test persistence, distributional choices, and asymmetric extensions against it on held-out variance proxies with a predeclared robust loss. See [[garch-volatility-models]] and [[efficient-market-hypothesis]].

Source: Bollerslev 1986, section 3, doi:10.1016/0304-4076(86)90063-1; author-hosted PDF sha256 `60353d43`.
