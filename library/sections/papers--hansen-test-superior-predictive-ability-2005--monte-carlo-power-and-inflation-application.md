---
title: Monte Carlo power gains and the US inflation forecasting application
source: "A Test for Superior Predictive Ability"
source_kind: paper
source_authors: [Peter R. Hansen]
source_year: 2005
source_venue: "Journal of Business & Economic Statistics 23(4):365-380"
source_url: https://doi.org/10.1198/073500105000000063
source_pdf_sha256: e6f4585659d4453432c944e9b4dce340d68a7aa2f75076a8733c814c6c633a1d
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The empirical case that the SPA modifications matter, and the worked demonstration that padding the candidate set with poor models can flip a conclusion. **Monte Carlo (§4).** Crossing the two statistics (`T^{RC}_n`, `T^{SPA}_n`) with the three null distributions (`µ̂^l`, `µ̂^c`, `µ̂^u`) gives six tests; `RC_u` is White's Reality Check and `SPA_c` is the test Hansen advocates. Losses are drawn `L_{k,t} ~ iid N(λ_k/√n, σ²_k)` with a good model given a smaller variance than a poor one (poor models are the erratic ones), `Λ_0` controlling how many inequalities bind and `Λ_1` the local alternative. The headline: under configurations with poor alternatives present, the Reality Check's power collapses while `SPA_c` holds up — e.g. for `(Λ_0, Λ_1) = (10, −3)` the RC almost never rejects a false null while `SPA_c` has about 84% power. In the design of Figure 4 (`m = 100`, `Λ_0 = 20`), applying the consistent null distribution alone (`RC_c`), or the studentization alone (`SPA_u`), each lifts power at `Λ_1 = −4` from about 5.5% to roughly 74% and 96% respectively, and both together (`SPA_c`) reach 99.7%. In relative-efficiency terms, using the LFC instead of the sample-dependent null throws away about 33% of the data, dropping studentization about 65%, and using the RC instead of `SPA_c` about **84%** of the data. The bootstrap even works when `m = 1,000` exceeds `n = 200` (where `Ω` cannot be sensibly estimated at all), with only slight over-rejection when every inequality binds.

**US inflation forecasting (§5).** Annual US inflation `Y_t = log(P_t/P_{t−4})` (GDP price deflator) is forecast by linear regressions of 1, 2, or 3 regressors drawn from a pool of 27, plus the equal-weighted average forecast, estimated on a 32-quarter **rolling window** (rolling-scheme estimation keeps the loss differentials stationary, honoring Assumption 1 — a recursive/expanding window would violate it). Forecasts are scored by **mean absolute error** against a **random-walk benchmark** (current inflation predicts future inflation), over `n = 160` quarters (1961:Q1–2000:Q4). The paper reports three candidate universes and it is the contrast between them that carries the lesson:

| Universe | `m` | `SPA_c` p-value | `RC` p-value (`RC_u`) | Reading |
|---|---|---|---|---|
| Large (all 1-to-3-regressor subsets) | 3,304 | .741 | .978 | No evidence any beats the random walk. |
| Small (all include lagged inflation, ridge-shrunk extras) | 352 | .048 | .106 | The benchmark *is* outperformed (Phillips-curve models best). |
| Full (large ∪ small) | 3,656 | **.100** | **.963** | SPA: borderline (10%) evidence; RC: no evidence — opposite conclusions. |

The full-universe row is the paper's punchline. Adding the large universe's many poor forecasts to the significant small universe drives the **Reality Check's p-value from .106 to .963** — a jump "most likely due to the RC's sensitivity to poor and irrelevant alternatives" — while `SPA_c` moves only from .048 to .100. So the RC and SPA "arrive at opposite conclusions" (no evidence vs weak evidence against `H0`) purely because the noisy alternatives conceal the real signal under the RC. The best and most significant forecasts have a **Phillips-curve structure** (inflation, employment, GDP-change regressors), supporting Stock & Watson (1999).

**But SPA is not immune, and the honesty it demands.** That `SPA_c` still rises from 4.8% to 10% when the poor models are added "reveals that the new test is not entirely immune to the inclusion of (a large number of) poor forecasts." The weaker full-universe evidence is "the price we have to pay for the data exploration that preceded" the small universe — reporting only the small-universe .048 would ignore that the large universe was searched first, and would itself be a data-mining error. The operational lesson for a forecasting system: **log every configuration ever evaluated against the data, run the search-corrected test over the full set, and — given scarce data — confine the candidate set to theoretically-motivated alternatives rather than a blind large search**, because excessive mining raises the bar at which any alternative can be called significantly better. This inflation application is the return/level-forecast twin of the corpus's volatility-side worked SPA example, [Hansen & Lunde 2005's 330-model GARCH horse race](papers--hansen-lunde-forecast-comparison-volatility-models-2005--spa-corrects-the-330-model-search.md), which Hansen cites here (as Hansen & Lunde 2005b) for the same RC-vs-SPA phenomenon.

Source: Hansen 2005, §4 (Size and Power Comparison by Monte Carlo Simulations — Tables 2-4, Figure 4) and §5 (Forecasting US Inflation Using Linear Regression Models — Table 6 large/small/full universes) with the §6 concluding synthesis, canonical DOI [10.1198/073500105000000063](https://doi.org/10.1198/073500105000000063); readable PDF is the author's postprint in the UNC Carolina Digital Repository ([`zp38wf793`](https://cdr.lib.unc.edu/downloads/zp38wf793), record DOI [10.17615/wehz-da64](https://doi.org/10.17615/wehz-da64)), sha256 `e6f4585659d4`.
