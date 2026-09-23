---
title: Testing and the inflation-uncertainty example
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

Abstract: The paper uses LM tests and an inflation-rate example to show the practical benefit of a compact GARCH(1,1): it captures changing forecast uncertainty with a less arbitrary lag shape than an ARCH(8) specification. The example is evidence for conditional-variance modeling, not an out-of-sample financial-performance claim, so it specifies what a later forecast-evaluation exercise must add.

Bollerslev derives an LM form for testing restrictions in a GARCH regression, while noting that a completely general GARCH test is not feasible because relevant regressors can be singular under white-noise or ARCH nulls. This is a useful warning against treating a single omnibus p-value as model selection. Nested alternatives, residual diagnostics, and order restrictions need an explicit candidate set.

For quarterly US GNP-deflator inflation, uncorrelated OLS residuals still had autocorrelated squares and significant ARCH tests. The fitted GARCH(1,1) had a modestly better fit than an ARCH(8) model with a hand-imposed declining lag, passed the reported standardized-residual checks, and gave a more plausible persistent uncertainty response. Its changing one-step-ahead intervals track high late-1940s uncertainty and quieter 1960s conditions. For financial use, reproduce this sequence without conflation: fit only information available at each origin, forecast variance, compare it against a simple benchmark using an appropriate proxy and loss, and account for model search. See [[garch-volatility-models]], [[walk-forward-validation]], and [[data-snooping-bias]].

Source: Bollerslev 1986, sections 6-7, doi:10.1016/0304-4076(86)90063-1; author-hosted PDF sha256 `60353d43`.
