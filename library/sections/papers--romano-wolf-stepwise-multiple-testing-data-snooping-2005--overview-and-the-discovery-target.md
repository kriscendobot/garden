---
title: "Overview and the discovery target"
source: "Stepwise Multiple Testing as Formalized Data Snooping"
source_kind: paper
source_authors: [Joseph P. Romano, Michael Wolf]
source_year: 2005
source_venue: "Econometrica 73(4):1237-1282"
source_url: https://doi.org/10.1111/j.1468-0262.2005.00615.x
source_pdf_sha256: ef3ed6fa9c91e2e2bb1f0c8b6bec84d2627941274f92c913e5a9e2f6cebe60ee
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Romano and Wolf turn data snooping from the single question "did the best searched strategy beat a benchmark?" into the decision problem an analyst actually faces: **which** of the searched strategies can be declared better than that benchmark while protecting the whole family of declarations. For each strategy `k`, they test `H0,k: theta_k <= 0` against `theta_k > 0`, where `theta_k` is a declared performance contrast with a common benchmark. Their target is strong familywise-error control: at level `alpha`, the chance of falsely calling even one non-beating strategy a winner is at most `alpha` for every configuration of true and false nulls.

This is deliberately more informative than White's original Bootstrap Reality Check, which asks only whether the sample-best strategy beats the benchmark. The paper's financial-advisor example makes the difference concrete: an efficient-markets question needs an existence result, while someone choosing funds needs the set of funds that survive multiplicity control. It is not a generic claim that the surviving strategies produce directional alpha. `theta_k` can be a mean-return contrast, a Sharpe-ratio contrast, CAPM alpha, or a loss-based risk criterion. The target and score decide whether the conclusion concerns return direction, risk-adjusted return, or conditional-volatility / VaR calibration.

Source: Romano and Wolf 2005, pp. 1237-1241, canonical DOI [10.1111/j.1468-0262.2005.00615.x](https://doi.org/10.1111/j.1468-0262.2005.00615.x); ingested text is the October 2003 UPF working-paper copy, recovered from the Internet Archive original-bytes capture of [UPF Working Paper 712](https://econ-papers.upf.edu/papers/712.pdf), sha256 `ef3ed6fa9c91`.
