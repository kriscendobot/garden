---
source_kind: paper
source_authors: [Torben G. Andersen, Tim Bollerslev, Francis X. Diebold, Paul Labys]
source_title: Modeling and Forecasting Realized Volatility
source_year: 2003
source_venue: "Econometrica 71(2):579-625 (2003); NBER Working Paper No. 8160 (March 2001)"
source_url: https://doi.org/10.1111/1468-0262.00418
source_mirror_url: https://www.nber.org/papers/w8160
source_pdf_sha256: a14e0e5de7e8b13b9218dbe503041a78d9416c49d9a36eafc909333ebfdea7ea
source_fetched_via: direct
ingested: 2026-07-16
ingested_by: scholar
section_count: 6
status: current
notes: |
  Canonical published venue is Econometrica (paywalled, DOI in source_url). The
  bytes ingested and hashed are the open-access NBER Working Paper No. 8160
  (source_mirror_url), fetched direct via fetch-source.sh. The working-paper and
  published texts are substantively the same; page numbers cited are the
  Econometrica pagination where given.
---

Abstract: The founding paper of the **realized-volatility** research program. Its move is to treat return volatility as *observed* rather than *latent*: under an arbitrage-free semi-martingale price process, the sum of cross-products of high-frequency intraday returns over a day (realized volatility) converges to that day's quadratic variation, giving a nearly measurement-error-free ex-post volatility estimate. Volatility thereby becomes an ordinary observable time series, forecastable with simple standard tools. On nearly thirteen years of 30-minute DM/$ and yen/$ exchange-rate returns, a simple long-memory Gaussian VAR for daily realized log volatility produces one- and ten-day forecasts that dominate GARCH(1,1), RiskMetrics EWMA, and daily-absolute-return models out of sample, and yields well-calibrated return-density and Value-at-Risk forecasts. This is the canonical realized-volatility / HAR-lineage reference cited by [garch-volatility-models](../concepts/garch-volatility-models.md), and a clean demonstration that a superior estimate of *current* volatility is what drives superior volatility forecasts.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--overview.md) | financial-forecasting, forecast-evaluation | current |
| [quadratic-variation-and-realized-volatility](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--quadratic-variation-and-realized-volatility.md) | financial-forecasting | current |
| [measuring-realized-volatility-from-intraday-returns](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--measuring-realized-volatility-from-intraday-returns.md) | financial-forecasting | current |
| [gaussian-and-long-memory-regularities](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--gaussian-and-long-memory-regularities.md) | financial-forecasting, forecast-evaluation | current |
| [long-memory-var-beats-garch-out-of-sample](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--long-memory-var-beats-garch-out-of-sample.md) | financial-forecasting, forecast-evaluation | current |
| [density-forecasts-and-value-at-risk](../sections/papers--andersen-modeling-forecasting-realized-volatility-2003--density-forecasts-and-value-at-risk.md) | financial-forecasting | current |
