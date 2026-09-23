---
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde, James M. Nason]
source_title: "The Model Confidence Set"
source_year: 2011
source_venue: "Econometrica 79(2):453-497"
source_url: https://doi.org/10.3982/ECTA5771
source_mirror_url: https://repec.econ.au.dk/repec/creates/rp/10/rp10_76.pdf
source_pdf_sha256: c4abc4759af8a10ab68dbca077bafb51db3ad2b7142b280f5151eadddabfed00
source_fetched_via: direct
source_pdf_pages: 35
ingested: 2026-07-17
ingested_by: scholar
section_count: 5
status: current
notes: |
  The published article is Econometrica 79(2):453-497 (DOI 10.3982/ECTA5771),
  which is paywalled. The readable full-text PDF ingested here is the
  authors' freely-available working-paper version, CREATES Research Paper
  2010-76 (Aarhus University, March 2010), hosted on the CREATES/RePEc
  archive; its text layer extracted cleanly. Section numbering and the two
  empirical applications match the published paper; the working paper carries
  the same theory (equivalence test, elimination rule, MCS p-values, bootstrap
  T_R/T_max statistics) and the same Stock-Watson inflation and Taylor-rule
  applications. The DOI is the canonical citation; the sha256 anchors the
  working-paper bytes actually read.
---

Abstract: The Model Confidence Set (MCS) is the natural continuation of the forecast-comparison lineage this corpus has been building — pairwise Diebold-Mariano, then best-of-N White Reality Check and Hansen SPA, now the model *set*. Given a collection of models `M0` scored by any user-specified loss, the MCS procedure returns a data-dependent subset `M̂*_{1−α}` that contains the best model(s) with confidence `1 − α`, analogous to a confidence interval for a parameter: informative data returns a small set, uninformative data a large one, so the set size itself reports what the data can say. It is built from an equivalence test and an elimination rule applied sequentially, halting at the first acceptance so the familywise error is bounded by the test level; it needs no benchmark, assumes no true model, and admits ties. The feasible tests use exactly the loss-differential t-statistic of DM and West, aggregated over a set via range (`T_R`) and max (`T_max`) statistics with a block bootstrap for the nuisance correlation. Relative to Reality Check/SPA it adds benchmark-freedom and genuine model selection while avoiding SPA's composite-null nuisance problem, and it inherits West's parameter-uncertainty caveat for nested/estimated forecasts. Being loss-agnostic, an MCS speaks to conditional-volatility/risk-forecast quality under a variance loss and to mean/directional quality under a return loss; the two must not be conflated.

| Section | Topics | Status |
|---------|--------|--------|
| [overview-and-the-model-confidence-set-idea](../sections/papers--hansen-lunde-nason-model-confidence-set-2011--overview-and-the-model-confidence-set-idea.md) | financial-forecasting, forecast-evaluation | current |
| [algorithm-equivalence-test-and-mcs-p-values](../sections/papers--hansen-lunde-nason-model-confidence-set-2011--algorithm-equivalence-test-and-mcs-p-values.md) | forecast-evaluation | current |
| [bootstrap-tests-and-loss-differential-t-statistics](../sections/papers--hansen-lunde-nason-model-confidence-set-2011--bootstrap-tests-and-loss-differential-t-statistics.md) | forecast-evaluation | current |
| [relation-to-reality-check-spa-and-parameter-uncertainty](../sections/papers--hansen-lunde-nason-model-confidence-set-2011--relation-to-reality-check-spa-and-parameter-uncertainty.md) | forecast-evaluation | current |
| [empirical-applications-and-forecasting-boundary](../sections/papers--hansen-lunde-nason-model-confidence-set-2011--empirical-applications-and-forecasting-boundary.md) | financial-forecasting, forecast-evaluation | current |
