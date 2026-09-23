---
title: Nested null makes the raw MSPE difference degenerate
source: "Approximately Normal Tests for Equal Predictive Accuracy in Nested Models"
source_kind: paper
source_authors: [Todd E. Clark, Kenneth D. West]
source_year: 2007
source_venue: "Journal of Econometrics 138(1):291-311 (2007); ingested from NBER Technical Working Paper 326 (August 2006)"
source_url: https://doi.org/10.1016/j.jeconom.2006.05.023
source_pdf_sha256: 69d6c6c90399b12ebc33bf683b564506745f95943a57cefac9ebddf4ffa90362
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: In a two-model nested forecast comparison, the ordinary squared-error loss difference is biased against the larger model under the null. The extra coefficients are zero in population, but estimating them adds forecast noise, so the raw MSPE difference is not centered at zero and the usual Diebold-Mariano normal test degenerates toward non-rejection.

Clark and West compare a parsimonious model 1 with a larger model 2 that contains model 1 plus predictors `Z`. Under the no-incremental-predictability null, the `Z` coefficients equal zero and the population forecasts have equal MSPE. The fitted forecasts do not behave as if those coefficients were known: model 2 estimates useless parameters and therefore adds noise. Consequently the observed raw difference `MSPE_1 - MSPE_2` has a negative term `-(yhat_1 - yhat_2)^2` and tends to favor the small model even when the population null says equal accuracy.

That is why a conventional pairwise loss-difference statistic is not the right nested-model test. Treating raw MSPE as an ordinary Diebold-Mariano differential and comparing its t statistic with normal critical values is miscentered. The paper's simulations call this route `MSPE-normal` and find it severely undersized. Its one-sided alternative is specifically that the larger model has lower MSPE after allowing for its estimation noise, not a generic claim that a model selected from a search has predictive skill.

The motivation includes a constant-mean expected-return benchmark augmented with a dividend-price ratio and a univariate inflation autoregression augmented with other variables. Those are point-forecast examples. The argument is equally about the evaluation target: a nested comparison scored with a conditional-variance loss is evidence about relative risk-forecast accuracy, while a comparison scored on returns or directions is evidence about that directional target. Neither target licenses an inference about the other.

Source: Clark and West, sections 1 and 3, working-paper version: [NBER Technical Working Paper 326 (August 2006)](https://www.nber.org/system/files/working_papers/t0326/t0326.pdf), published version DOI [10.1016/j.jeconom.2006.05.023](https://doi.org/10.1016/j.jeconom.2006.05.023), sha256 `69d6c6c90399`.
