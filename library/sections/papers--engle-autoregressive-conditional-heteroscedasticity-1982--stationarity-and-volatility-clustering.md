---
title: Finite unconditional variance and volatility clustering
source: "Autoregressive Conditional Heteroscedasticity with Estimates of the Variance of United Kingdom Inflation"
source_kind: paper
source_authors: [Robert F. Engle]
source_year: 1982
source_venue: "Econometrica 50(4):987-1007"
source_url: https://www.jstor.org/stable/1912773
source_mirror_url: https://docslib.org/doc/3199579/autoregressive-conditional-heteroscedasticity-with-estimates-of-the-variance-of-united-kingdom-inflation-author-s-robert-f
source_content_sha256: 0a9966a2ac558e580b2bd5c03019b4bde476dfe2d510348a0101dea2c975075e
source_fetched_via: direct
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: ARCH reconciles locally changing forecast uncertainty with a finite long-run variance. Its squared innovations are serially dependent even when the innovations themselves are uncorrelated, formalizing volatility clustering and explaining why a mean model can pass ordinary autocorrelation checks while its uncertainty forecast remains inadequate.

Engle derives unconditional moments for the ARCH process and conditions under which variance is finite. The key operational point is that conditional variance may react sharply to recent shocks without becoming an unbounded state. This separates a legitimate persistent risk forecast from an unstable parameterization whose intervals keep growing.

The squared series has autocorrelation because past shocks drive h_t. A production volatility pipeline should therefore inspect both return residuals and standardized squared residuals, while also enforcing positivity and finite-moment constraints after each fit. GARCH generalizes this same discipline with a more parsimonious persistence term. See [[garch-volatility-models]].

Source: Engle 1982, section 3, canonical stable URL [JSTOR 1912773](https://www.jstor.org/stable/1912773); readable HTML transcription fetched from Docslib, sha256 `0a9966a2`.
