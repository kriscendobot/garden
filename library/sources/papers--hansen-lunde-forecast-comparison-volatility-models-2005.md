---
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde]
source_title: "A Forecast Comparison of Volatility Models: Does Anything Beat a GARCH(1,1)?"
source_year: 2005
source_venue: "Journal of Applied Econometrics 20(7):873-889"
source_url: https://doi.org/10.1002/jae.800
source_mirror_url: https://onlinelibrary.wiley.com/doi/full/10.1002/jae.800
source_pdf_sha256: 3eeed6014f705dc0a192cc47822921b1d59a062267ca96ee25c6ee24f54c8099
source_fetched_via: wayback
ingested: 2026-07-17
ingested_by: scholar
section_count: 5
status: current
notes: |
  Canonical published venue is the Journal of Applied Econometrics, DOI in
  source_url. The open full-text publisher HTML at source_mirror_url was fetched
  through fetch-source.sh's Internet Archive original-bytes fallback after the
  live publisher returned HTTP 403. source_pdf_sha256 is the prescribed
  paper-content idempotency anchor, over the faithfully full-text HTML bytes.
  Fifth financial-forecasting-corpus paper. It turns GARCH(1,1) from a default
  into a selection-aware benchmark, comparing 330 ARCH-type models and using
  SPA rather than a naive best-model p-value.
---

Abstract: Hansen and Lunde's 2005 330-model volatility horse race gives the financial-forecasting corpus its direct **GARCH benchmark test**. Each model makes one-day-ahead conditional-variance forecasts for a held-out sample, scored against realized variance under six losses and compared with a search-aware SPA test. The conclusion is market-dependent: GARCH(1,1) is not significantly beaten for DM-dollar exchange rates, but is inferior for IBM returns, where leverage-effect models do better. The paper is equally valuable as evaluation guidance: a naive comparison to the best of 330 candidates is invalid, and White's Reality Check can be so underpowered that it obscures an obvious weak control. A volatility system should retain GARCH as a baseline, test asymmetry where warranted, and correct the whole candidate search before reporting a winner.

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--overview.md) | financial-forecasting, forecast-evaluation | current |
| [model-universe-and-garch-benchmark](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--model-universe-and-garch-benchmark.md) | financial-forecasting, forecast-evaluation | current |
| [realized-variance-loss-and-holdout-protocol](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--realized-variance-loss-and-holdout-protocol.md) | financial-forecasting, forecast-evaluation | current |
| [spa-corrects-the-330-model-search](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--spa-corrects-the-330-model-search.md) | financial-forecasting, forecast-evaluation | current |
| [market-dependent-results-and-leverage-effect](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--market-dependent-results-and-leverage-effect.md) | financial-forecasting, forecast-evaluation | current |
