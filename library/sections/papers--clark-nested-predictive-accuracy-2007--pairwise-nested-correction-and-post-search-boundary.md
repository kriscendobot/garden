---
title: Pairwise nested correction and the post-search boundary
source: "Approximately Normal Tests for Equal Predictive Accuracy in Nested Models"
source_kind: paper
source_authors: [Todd E. Clark, Kenneth D. West]
source_year: 2007
source_venue: "Journal of Econometrics 138(1):291-311 (2007); ingested from NBER Technical Working Paper 326 (August 2006)"
source_url: https://doi.org/10.1016/j.jeconom.2006.05.023
source_pdf_sha256: 69d6c6c90399b12ebc33bf683b564506745f95943a57cefac9ebddf4ffa90362
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: Clark-West is a correction for one pre-specified nested pair with fitted parameters. It belongs beside, rather than in place of, finite-window method comparison and post-search multiple-testing procedures: Giacomini-White addresses a pre-specified pair of methods, Romano-Wolf identifies benchmark beaters under FWER control, SPA asks whether any searched alternative beats a benchmark, and MCS returns a benchmark-free survivor set.

The scope begins with a supplied small model and one supplied larger model that nests it. Clark-West corrects the pairwise nesting pathology, while the West (1996) route addresses forecast-parameter estimation. It does not repair the selection event that occurs when an analyst tries many predictors, specifications, windows, or losses and reports the pair that happened to win.

Giacomini-White changes a different dimension: with a fixed or rolling estimation window, it evaluates two pre-specified forecasting methods and can test conditional predictive ability using origin-time instruments. That method-level, finite-window interpretation can be valuable when parameter estimation is part of the object being compared, but it does not create post-search validity. A Clark-West result is likewise not a license to choose its nesting pair after inspecting many candidates.

For that search problem, Romano-Wolf StepM uses dependence-aware stepdown bootstrap testing to make named benchmark-relative discoveries under strong familywise-error-rate control. Hansen's SPA asks the global benchmark-relative question whether any model in a searched family has superior predictive ability, using studentization and a power-improving null construction. The Model Confidence Set makes neither model a privileged benchmark and returns the models not statistically distinguishable from the best. These procedures answer different reporting questions. A sound workflow first specifies the forecast target, loss, windows, and nesting relationship; applies a fitted/nested correction where that pair needs one; and applies a search correction when declarations follow a model search.

Source: Clark and West, sections 1-5, working-paper version: [NBER Technical Working Paper 326 (August 2006)](https://www.nber.org/system/files/working_papers/t0326/t0326.pdf), published version DOI [10.1016/j.jeconom.2006.05.023](https://doi.org/10.1016/j.jeconom.2006.05.023), sha256 `69d6c6c90399`; method-boundary context links to the corpus's Giacomini-White, Romano-Wolf, SPA, and MCS sources.
