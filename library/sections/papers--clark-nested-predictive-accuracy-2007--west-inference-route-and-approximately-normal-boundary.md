---
title: West inference route and the approximately normal boundary
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

Abstract: The paper recommends the familiar West (1996) estimated-forecast inference route for the adjusted loss differential, but calls the resulting normal test only approximately normal. With growing estimation and evaluation samples, the nested statistic has a nonstandard limit; tabulated Clark-McCracken quantiles and simulations support conservative normal critical values in the specified settings, not a universal normality claim.

The recommended standard error follows the West (1996) route for forecast losses produced by estimated models: account for the time-series dependence in the adjusted loss and for the fact that forecasts are repeatedly refitted. This is the fitted-forecast complement to the ordinary Diebold-Mariano calculation. It is not enough to form a raw error-difference series and pretend the coefficients were fixed.

The qualification in the title matters. When both the estimation window `R` and evaluation window `P` grow with a finite nonzero ratio, the adjusted t statistic has a nonstandard Clark-McCracken limiting distribution. For one-step, conditionally homoskedastic forecasts, its quantiles depend on the number of extra predictors, `P/R`, and rolling versus recursive refitting. The authors inspect simulated critical-value tables and argue that normal critical values are a useful conservative approximation: 1.282 for a nominal one-sided 10 percent test generally delivers an actual size between about 5 and 10 percent; 1.645 for nominal 5 percent is also usually conservative. This is numerical and simulation support, not a theorem that the statistic is standard normal.

For fixed rolling `R` and growing `P`, the relevant object instead has an ordinary central-limit interpretation for the expectation of the adjusted encompassing-style moment. For multistep or conditionally heteroskedastic forecasts with several added predictors, the paper points to simulation critical values for the nonstandard distribution and examines bootstrap methods. The analyst must therefore record horizon, refitting scheme, window sizes, heteroskedasticity assumptions, and the critical-value route. Calling every adjusted comparison "Clark-West normal" hides the boundary the paper works to expose.

Source: Clark and West, sections 4-6, working-paper version: [NBER Technical Working Paper 326 (August 2006)](https://www.nber.org/system/files/working_papers/t0326/t0326.pdf), published version DOI [10.1016/j.jeconom.2006.05.023](https://doi.org/10.1016/j.jeconom.2006.05.023), sha256 `69d6c6c90399`.
