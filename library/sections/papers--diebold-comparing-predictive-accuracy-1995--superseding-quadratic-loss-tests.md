---
title: Superseding the quadratic-loss tests (extant tests and Monte Carlo size)
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

Abstract: Diebold and Mariano review the three predecessors that tested equal forecast accuracy — the simple `F` test, the Morgan–Granger–Newbold (MGN) test, and the Meese–Rogoff (MR) test — and show all three are inextricably wed to **quadratic loss** and to distributional assumptions financial data routinely violate. A Monte Carlo experiment then confirms the payoff: under fat-tailed forecast errors, `F`, MGN, and MR are drastically mis-sized in large *and* small samples, while the loss-differential statistics `S1`, `S2a`, and `S3a` hold approximately correct size. This is the argument that the DM tests supersede the classical ones.

**The three extant tests.** (1) The **simple `F` test** treats equal accuracy as equal forecast-error variances: under quadratic loss with zero-mean, Gaussian, serially- and contemporaneously-uncorrelated errors, the ratio of sample error variances is `F(T, T)`. But the no-contemporaneous-correlation assumption is untenable — two forecasts *of the same series* built on largely overlapping information sets have strongly correlated errors — and its violation correlates the numerator and denominator so the `F` distribution fails. (2) The **Morgan–Granger–Newbold** test (Granger and Newbold 1977, using Morgan's 1939–40 orthogonalizing transform) removes the contemporaneous-correlation problem by testing zero correlation between the sum `x_t = e_1t + e_2t` and difference `z_t = e_1t − e_2t`, giving a Student-`t` statistic — but it still depends crucially on quadratic loss and (in its basic form) on no serial correlation. (3) The **Meese–Rogoff** test (Meese and Rogoff 1988) relaxes serial and contemporaneous correlation using a consistent long-run cross-covariance estimator, and is asymptotically `N(0, 1)` — but *any* procedure built on the MGN orthogonalizing transform "is inextricably wed to the assumption of quadratic loss."

**Monte Carlo size.** The design draws bivariate forecast errors with controlled contemporaneous correlation `ρ ∈ {0, .5, .9}` (via a Choleski factor) and MA(1) serial correlation `θ ∈ {0, .5, .9}`, at sample sizes `T = 8 … 512`, under both Gaussian and standardized-`t(6)` (fat-tailed) innovations; tests are run at the 10% level with ≥5,000 replications and truncation lag 1 (mimicking a two-step comparison). Findings: under **Gaussian** errors, `F` is correctly sized only with neither correlation and is badly mis-sized otherwise (contemporaneous correlation drives its size drastically below nominal); MGN stays correct only when `θ = 0`; MR and `S1` are robust in large samples but oversized in small samples with serial correlation (MR's asymptotics arrive a bit faster than `S1`'s); the Bonferroni-bounded `S2`/`S3` and the asymptotic `S2a`/`S3a` track nominal size closely throughout. Under **fat-tailed** errors, the striking result is that `F`, MGN, and MR are drastically mis-sized in large *as well as* small samples, whereas `S1`, `S2a`, and `S3a` keep approximately correct size for all but the smallest samples (where `S2`/`S3` still perform well).

The methodological lesson for this corpus is direct: a horse race scored under a non-quadratic loss (QLIKE for variance forecasts, an absolute or direction-of-change loss for returns) *cannot* use `F`/MGN/MR at all, and even under quadratic loss those tests distort inference once errors are correlated or heavy-tailed — precisely the regime of financial returns. The loss-agnostic DM statistics are what make a fat-tailed, correlated, non-quadratic comparison honest.

Source: Diebold and Mariano 1995, section 2 (extant tests) and section 3 (Monte Carlo analysis, Tables 1–6), canonical DOI [10.1080/07350015.1995.10524599](https://doi.org/10.1080/07350015.1995.10524599); readable PDF [author copy (F. Diebold, U. Penn)](https://www.sas.upenn.edu/~fdiebold/papers/paper68/pa.dm.pdf), sha256 `93aadf7294c5`.
