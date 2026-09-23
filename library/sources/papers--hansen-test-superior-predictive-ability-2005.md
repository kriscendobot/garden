---
source_kind: paper
source_authors: [Peter R. Hansen]
source_title: "A Test for Superior Predictive Ability"
source_year: 2005
source_venue: "Journal of Business & Economic Statistics 23(4):365-380"
source_url: https://doi.org/10.1198/073500105000000063
source_mirror_url: https://cdr.lib.unc.edu/downloads/zp38wf793
source_pdf_sha256: e6f4585659d4453432c944e9b4dce340d68a7aa2f75076a8733c814c6c633a1d
source_fetched_via: direct
source_pdf_pages: 16
ingested: 2026-07-17
ingested_by: scholar
section_count: 5
status: current
notes: |
  Canonical citation: Peter R. Hansen, "A Test for Superior Predictive
  Ability", Journal of Business & Economic Statistics 23(4):365-380 (October
  2005), DOI 10.1198/073500105000000063. The readable full-text PDF ingested
  here is the author's postprint (accepted manuscript, carrying the published
  JBES running heads and pagination 365-380, Stanford University affiliation),
  deposited in the University of North Carolina's Carolina Digital Repository
  (record DOI 10.17615/wehz-da64, download `zp38wf793`); its text layer
  extracted cleanly and matches the published article. The JBES DOI is the
  canonical citation; the sha256 anchors the postprint bytes actually read.
  Provenance honesty parallels the MCS ingest (which read the CREATES 2010-76
  working-paper version): here the readable copy is a repository postprint of
  the published text rather than a working paper.
---

Abstract: Peter Hansen's Superior Predictive Ability (SPA) test is the power-improving successor to White's (2000) Reality Check and the missing middle link of the corpus's forecast-comparison lineage (pairwise Diebold-Mariano/West → best-of-N Reality Check → SPA → the Model Confidence Set). It keeps White's framework exactly — `m` alternative forecasts scored by any user-specified loss against a benchmark, the composite superior-predictive-ability null `H0: µ ≤ 0` where `µ = E(L_benchmark − L_k)` — but changes the *test construction* with two modifications. First, a **studentized** statistic `T^{SPA}_n = max[max_k n^{1/2} d̄_k / ω̂_k, 0]` divides each alternative's average relative performance by its own standard error, so an erratic high-variance junk forecast cannot dominate the maximum and conceal a genuine winner. Second, a **sample-dependent null distribution** centered on a data-dependent `µ̂^c` (a law-of-iterated-logarithm `√(2 log log n)` threshold) down-weights the poor and irrelevant benchmark-inferior alternatives instead of White's blanket least-favorable-configuration `µ = 0` — so an analyst cannot dilute a real result's significance by padding the model set with junk, the way the Reality Check's p-value can be pushed toward 1 by exactly that padding. Both feed a stationary-bootstrap implementation (Politis-Romano) that yields a **consistent p-value** (bracketed by liberal/conservative bounds whose gap diagnoses poor alternatives). Monte Carlo shows using the Reality Check instead of SPA throws away about 84% of the data; a US-inflation application makes the padding effect concrete — adding many poor forecasts drives the Reality Check p-value from .106 to .963 while SPA moves only .048 → .100, so the two reach opposite conclusions. SPA constrains the estimation scheme (fixed or rolling window, not recursive) to keep the West parameter-uncertainty problem out of its stationarity assumption rather than solving it, and being loss-agnostic it preserves the conditional-volatility/risk versus directional-return distinction. The corpus's worked volatility-side SPA example is Hansen & Lunde's 330-model GARCH horse race.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-the-spa-test-idea](../sections/papers--hansen-test-superior-predictive-ability-2005--overview-and-the-spa-test-idea.md) | financial-forecasting, forecast-evaluation | current |
| [studentized-statistic-and-sample-dependent-null](../sections/papers--hansen-test-superior-predictive-ability-2005--studentized-statistic-and-sample-dependent-null.md) | forecast-evaluation | current |
| [bootstrap-implementation-and-consistent-p-value](../sections/papers--hansen-test-superior-predictive-ability-2005--bootstrap-implementation-and-consistent-p-value.md) | forecast-evaluation | current |
| [monte-carlo-power-and-inflation-application](../sections/papers--hansen-test-superior-predictive-ability-2005--monte-carlo-power-and-inflation-application.md) | financial-forecasting, forecast-evaluation | current |
| [relation-to-reality-check-and-the-correction-lineage](../sections/papers--hansen-test-superior-predictive-ability-2005--relation-to-reality-check-and-the-correction-lineage.md) | financial-forecasting, forecast-evaluation | current |
