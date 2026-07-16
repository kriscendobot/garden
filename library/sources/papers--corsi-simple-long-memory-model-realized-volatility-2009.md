---
source_kind: paper
source_authors: [Fulvio Corsi]
source_title: A Simple Approximate Long-Memory Model of Realized Volatility
source_year: 2009
source_venue: "Journal of Financial Econometrics 7(2):174-196 (2009)"
source_url: https://doi.org/10.1093/jjfinec/nbp001
source_mirror_url: https://statmath.wu.ac.at/~hauser/LVs/FinEtricsQF/References/Corsi2009JFinEtrics_LMmodelRealizedVola.pdf
source_pdf_sha256: 18c305635feefc152a0522791de67677b5db037dd10958a09134c7d55cf222e5
source_fetched_via: direct
ingested: 2026-07-16
ingested_by: scholar
section_count: 4
status: current
notes: |
  Canonical published venue is the Journal of Financial Econometrics (paywalled
  at Oxford Academic, DOI in source_url). The bytes ingested and hashed are an
  open-access copy of the published article hosted on a university course page
  (source_mirror_url), fetched direct via fetch-source.sh. Earlier versions
  circulated under the title "A Simple Long Memory Model of Realized Volatility."
  The second paper of the financial-forecasting-corpus (follows the Andersen et
  al. 2003 realized-volatility founding paper); introduces the HAR-RV model, the
  standard realized-volatility forecasting baseline.
---

Abstract: The paper that introduced **HAR-RV** (Heterogeneous Autoregressive model of Realized Volatility), the workhorse realized-volatility forecaster and the baseline any newer volatility model must beat. Building on the realized-volatility measurement of Andersen-Bollerslev-Diebold-Labys 2003 (volatility as an observable series; see [garch-volatility-models](../concepts/garch-volatility-models.md)), Corsi replaces fragile true-long-memory machinery (ARFIMA/FIGARCH, fractional integration) with an economically-motivated **additive volatility cascade**: traders act on daily, weekly, and monthly horizons, and long-horizon volatility drives short-horizon volatility asymmetrically. Recursive substitution collapses this cascade into a single ordinary-least-squares regression of tomorrow's daily realized volatility on the past daily, weekly (5-day), and monthly (22-day) averages of realized volatility -- exactly a *restricted AR(22)* with three free coefficients. Though formally a short-memory model, HAR reproduces the long-memory autocorrelation decay, fat tails, and self-similarity of financial data, and out of sample (rolling 1000-observation re-estimation on USD/CHF, S&P500, and T-Bond futures) it steadily beats short-memory AR models and matches the far more cumbersome ARFIMA. Its one-line OLS estimability is why HAR became the realized-volatility standard.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--corsi-simple-long-memory-model-realized-volatility-2009--overview.md) | financial-forecasting, forecast-evaluation | current |
| [heterogeneous-market-hypothesis-and-volatility-cascade](../sections/papers--corsi-simple-long-memory-model-realized-volatility-2009--heterogeneous-market-hypothesis-and-volatility-cascade.md) | financial-forecasting | current |
| [har-rv-model-as-restricted-ar](../sections/papers--corsi-simple-long-memory-model-realized-volatility-2009--har-rv-model-as-restricted-ar.md) | financial-forecasting | current |
| [out-of-sample-forecast-performance](../sections/papers--corsi-simple-long-memory-model-realized-volatility-2009--out-of-sample-forecast-performance.md) | financial-forecasting, forecast-evaluation | current |
