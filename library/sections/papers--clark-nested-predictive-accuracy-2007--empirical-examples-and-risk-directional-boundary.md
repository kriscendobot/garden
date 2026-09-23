---
title: Empirical examples and the risk-directional boundary
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

Abstract: The stock-return and GDP-growth illustrations show the operational effect of the adjustment: a larger model can have a worse raw MSPE yet evidence of incremental predictive content after its fitting penalty is removed. These examples are conditional-mean point forecasts, so they must not be relabeled as volatility, risk, or directional-return results.

For one-month excess stock returns, the null is a constant mean and the nested alternative adds the dividend-price ratio. For one-quarter GDP growth, the null is an AR(1) and the alternative adds lags of a national activity index. In both applications the larger model pays an observable raw-MSPE cost. The adjusted statistic is near zero for rolling stock-return forecasts and 1.17 for recursive forecasts, while GDP growth produces adjusted t statistics around 2.07. The results illustrate why raw MSPE can overstate the case for the parsimonious benchmark.

The paper's target is squared error for a point forecast of returns or growth. A finding about the return conditional mean is not a direction-of-return trading claim unless direction is the declared loss or decision objective, and it is not a conditional-volatility claim. Conversely, a Clark-West comparison of nested GARCH-family variance forecasts, scored with an appropriate variance loss and proxy, would concern relative conditional-risk forecast accuracy, not whether returns are predictable in sign. The correction changes nested-model inference; it does not collapse distinct forecast objects or losses into one notion of "better prediction."

Source: Clark and West, sections 7-8, working-paper version: [NBER Technical Working Paper 326 (August 2006)](https://www.nber.org/system/files/working_papers/t0326/t0326.pdf), published version DOI [10.1016/j.jeconom.2006.05.023](https://doi.org/10.1016/j.jeconom.2006.05.023), sha256 `69d6c6c90399`.
