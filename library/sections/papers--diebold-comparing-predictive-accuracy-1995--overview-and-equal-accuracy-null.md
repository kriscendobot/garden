---
title: Overview and the equal-accuracy null
source: "Comparing Predictive Accuracy"
source_kind: paper
source_authors: [Francis X. Diebold, Roberto S. Mariano]
source_year: 1995
source_venue: "Journal of Business & Economic Statistics 13(3):253-263"
source_url: https://doi.org/10.1080/07350015.1995.10524599
source_pdf_sha256: 93aadf7294c50788584384b4806f6bf7d58b959da550405ea6db431d7330bcd5
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Diebold and Mariano frame forecast comparison around a single object — the loss differential `d_t = g(e_1t) − g(e_2t)` between two competing forecasts of the same series — and reduce "the two forecasts are equally accurate" to the null `E[d_t] = 0`. The test is agnostic about *what* is forecast and about which loss is used, so it applies equally to a return forecast, a variance forecast, or a direction-of-change forecast. It is a test of *equal expected loss between two forecasts*, not a test that either forecast has any skill: it takes two out-of-sample error series as given and asks only whether one loses less than the other on average.

Comparisons of forecast accuracy matter to users of forecasts (who act on them), to producers of forecasts (whose reputations track accuracy), and to economists discriminating among competing models — "predictive failure implies model inadequacy." Yet the literature carries thousands of accuracy comparisons in which point estimates of accuracy are examined with no attempt to assess their sampling uncertainty. The reason for that casual approach is that correlation of forecast errors across space and time makes a formal comparison genuinely difficult, and earlier assessments (Dhrymes et al. 1972; Howrey, Klein, and McCarthy 1974) were pessimistic about the possibility of formal testing.

The paper's move is to test predictive performance *directly* while admitting a wide class of accuracy measures the user tailors to the decision at hand. This matters because realistic economic loss functions frequently do not conform to textbook favorites like mean squared prediction error (MSPE): different literatures had already stressed direction-of-change (Leitch and Tanner 1991; Chinn and Meese 1991), market and country timing (Cumby and Modest 1987), utility-based criteria (McCulloch and Rossi 1990; West, Edison, and Cho 1993), and other bespoke measures. The economic loss of a forecast error of a given sign and size is induced by the decision problem, so the time-`t` loss is allowed to be an arbitrary function `g(y_t, ŷ_it)` of the realization and prediction. In many applications loss is a direct function of the error, `g(e_it)`, but some losses (direction-of-change) do not collapse to `g(e_it)` form, in which case the full `g(y_t, ŷ_it)` form is used.

Given that setup, the null hypothesis of equal forecast accuracy for two forecasts is `E[g(e_1t)] = E[g(e_2t)]`, equivalently `E[d_t] = 0`: the population mean of the loss-differential series is zero. Everything that follows — an asymptotic test on the sample mean loss differential, and exact finite-sample sign and signed-rank tests — is an inference procedure about that one scalar. Crucially, the forecast errors are permitted to be non-Gaussian, nonzero-mean, serially correlated, and contemporaneously correlated, which are exactly the features that broke the earlier tests.

For this corpus the framing preserves the load-bearing distinction between risk forecasts and directional-return claims: the Diebold–Mariano machinery answers "is forecast A significantly more accurate than forecast B, under the loss I actually care about?" It does *not* answer "is A accurate enough to trade," and it makes no directional claim by itself. A DM comparison of two conditional-variance forecasts (scored by [QLIKE](papers--patton-volatility-forecast-comparison-imperfect-proxies-2011--robust-loss-functions-and-qlike.md), say) is evidence about relative risk-forecast quality; a DM comparison of two return forecasts is evidence about relative directional quality; the two must not be conflated.

Source: Diebold and Mariano 1995, introduction and section 1, canonical DOI [10.1080/07350015.1995.10524599](https://doi.org/10.1080/07350015.1995.10524599); readable PDF [author copy (F. Diebold, U. Penn)](https://www.sas.upenn.edu/~fdiebold/papers/paper68/pa.dm.pdf), sha256 `93aadf7294c5`.
