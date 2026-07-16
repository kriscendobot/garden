---
source_kind: paper
source_authors: [Andrew J. Patton]
source_title: Volatility Forecast Comparison Using Imperfect Volatility Proxies
source_year: 2011
source_venue: "Journal of Econometrics 160(1):246-256"
source_url: https://doi.org/10.1016/j.jeconom.2010.03.034
source_mirror_url: https://public.econ.duke.edu/~ap172/Patton_robust_JoE_forthcoming.pdf
source_pdf_sha256: 2b85bc30f188dc19d0ac7dbfe854929148d27c42e3f73d2b16605558daf60cee
source_fetched_via: direct
ingested: 2026-07-16
ingested_by: scholar
section_count: 5
status: current
notes: |
  Canonical published venue is Journal of Econometrics, DOI in source_url. The
  bytes ingested and hashed are the author's open Duke-hosted article-in-press
  PDF at source_mirror_url, fetched direct via fetch-source.sh. The third
  financial-forecasting-corpus paper. It provides the theoretical basis for
  using QLIKE to compare volatility forecasts against imperfect variance
  proxies, including realized variance.
---

Abstract: The canonical source for **robust volatility-forecast evaluation**. Conditional variance is latent even after a return is observed, so a forecast comparison must use a noisy proxy such as a squared return, an intraday range, or realized variance. Patton proves that conditional unbiasedness of the proxy does not, by itself, preserve the ranking of competing forecasts for arbitrary losses: popular log, proportional, and standard-deviation error losses can select a forecast that is inferior for the latent variance. He derives the necessary and sufficient form of a proxy-robust loss and highlights **MSE** and **QLIKE** as useful special cases. QLIKE is scale invariant, asymmetric in under- versus over-prediction, and requires weaker proxy conditions than MSE, making it the natural default for a walk-forward comparison of GARCH, HAR, EWMA, or learned positive variance forecasts. An IBM case study shows that QLIKE can find a significant difference where MSE does not, because MSE is more sensitive to a few extremes.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--overview.md) | forecast-evaluation, financial-forecasting | current |
| [noisy-proxies-can-reverse-rankings](../sections/papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--noisy-proxies-can-reverse-rankings.md) | forecast-evaluation, financial-forecasting | current |
| [robust-loss-functions-and-qlike](../sections/papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--robust-loss-functions-and-qlike.md) | forecast-evaluation, financial-forecasting | current |
| [ibm-application-qlike-distinguishes-forecasts](../sections/papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--ibm-application-qlike-distinguishes-forecasts.md) | forecast-evaluation, financial-forecasting | current |
| [conclusion-evaluation-contract](../sections/papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--conclusion-evaluation-contract.md) | forecast-evaluation, financial-forecasting | current |
