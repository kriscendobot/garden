---
title: Placement in the corpus and the correction lineage
source: "A Reality Check for Data Snooping"
source_kind: paper
source_authors: [Halbert White]
source_year: 2000
source_venue: "Econometrica 68(5):1097-1126"
source_url: https://doi.org/10.1111/1468-0262.00152
source_pdf_sha256: 675eb3226dee3af4dfa8089410f9bbf0a2798c7b58985c8334c42fb4983a9743
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: This section situates White's Reality Check within the corpus's forecast-comparison lineage. The Reality Check is the **first multiple-model correction** — the correction the [Diebold–Mariano test](papers--diebold-comparing-predictive-accuracy-1995--overview-and-equal-accuracy-null.md) does *not* make. Diebold–Mariano tests exactly two given forecasts and applies no search correction, so using it to pick a winner out of many models is itself a data-snooping error; White generalizes the pairwise comparison to "the best of `N` searched models beats the benchmark" while accounting for the search. It is the direct ancestor of Hansen's Superior Predictive Ability (SPA) test and the Model Confidence Set, and it is the concrete significance test that the model-search literature — from [Meese and Rogoff](papers--meese-rogoff-exchange-rate-models-seventies-1983--random-walk-benchmark-survives-the-horse-race.md) to [Welch and Goyal](papers--welch-comprehensive-look-equity-premium-prediction-2008--monthly-horizons-and-specification-search.md) — was missing.

**The lineage: pairwise → best-of-N → the model set.** The corpus's [[data-snooping-bias]] concept collects the corrections in increasing everyday usefulness, and White is the hinge between the first two rungs:
- **Diebold–Mariano 1995** (pairwise). Tests `E[d_t] = 0` for the loss differential between *two* forecasts; loss-agnostic, silent about skill, and search-blind. See [[diebold-mariano-test]].
- **White 2000, the Reality Check** (best-of-N). Tests `H0: max_k E[f_k*] ≤ 0`, correcting inference for the fact that `l` models were searched — White explicitly builds on Diebold–Mariano 1995 and West 1996. Its weakness, later addressed, is *power*: the maximum statistic can be dragged down by including many poor, irrelevant models against the benchmark, so a good model can be masked.
- **Hansen's SPA 2005 / Hansen, Lunde & Nason MCS 2011.** SPA studentizes the statistic and recenters, making it robust to poor and irrelevant models where the Reality Check may lack power; the [Hansen and Lunde 2005](papers--hansen-lunde-forecast-comparison-volatility-models-2005--spa-corrects-the-330-model-search.md) volatility horse race is the corpus's worked SPA example, and its overview section notes exactly the case where a naive best-model p-value and even the Reality Check can mislead. The Model Confidence Set returns the *set* of models statistically indistinguishable from the best.

**Estimated-parameter uncertainty (West 1996).** White's framework rests on West 1996's asymptotic-inference results for predictive ability: when the forecasts depend on estimated parameters, the out-of-sample loss average inherits extra variance, and the covariance `V` must (in general) account for it. White inherits West's regularity conditions and shows the estimation contribution often vanishes (when the moment's expected gradient is zero, or `n/R → 0`), which is what lets the bootstrap skip recomputing coefficients. West 1996 is the corpus's natural next node on estimated-parameter inference and remains an un-ingested follow-on.

**The conditional-volatility versus directional-return distinction is preserved — and illustrated.** The Reality Check inherits Diebold–Mariano's loss-agnosticism, so *what a significant Reality Check result speaks to depends entirely on the performance measure searched*. White's own two experiments make the point concretely: the mean-squared-prediction-error search and the *directional-accuracy* search select **different** indicators and reach different naive verdicts, and *neither* is a variance-forecast comparison. Run the Reality Check on a variance-forecast loss such as [QLIKE](papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--robust-loss-functions-and-qlike.md) and it speaks to relative *risk-forecast* quality; run it on a return or direction-of-change loss (as White's directional-accuracy experiment does) and it speaks to relative *directional* quality. A search-corrected result about one is not evidence about the other — the corpus's core caution against conflating conditional-volatility/risk forecasts with directional-return claims. And because the benchmark here is the constant-only [[efficient-market-hypothesis]] model, White's failure to reject in *both* experiments is a search-corrected restatement of the difficulty of beating the martingale-difference null with technical indicators.

Source: White 2000, sections 1–2 (framework and lineage to Diebold–Mariano 1995 and West 1996), section 4 (the two experiments), and section 5 (Summary and Concluding Remarks), canonical DOI [10.1111/1468-0262.00152](https://doi.org/10.1111/1468-0262.00152); readable PDF [Wisconsin Econ 718 course copy](https://www.ssc.wisc.edu/~bhansen/718/White2000.pdf), sha256 `675eb3226dee`.
