---
title: The asymptotic test and the serial-correlation correction
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

Abstract: The large-sample Diebold–Mariano statistic is the sample mean loss differential divided by a consistent estimate of its standard error: `S1 = d̄ / sqrt(2π f̂_d(0) / T)`, asymptotically `N(0, 1)` under the equal-accuracy null. Its defining feature is that the standard error is built from the *long-run* variance of the loss-differential series, so it stays valid when the loss differential is serially correlated — the normal case for multi-step forecasts. This is the workhorse form practitioners mean by "the DM test."

If the loss-differential series `{d_t}` is covariance-stationary and short-memory, standard results give the asymptotic distribution of the sample mean loss differential:

```
sqrt(T) (d̄ − μ)  →  N(0, 2π f_d(0)),
```

where `d̄` is the sample mean loss differential, `f_d(0) = (1 / 2π) Σ_{τ=−∞}^{∞} γ_d(τ)` is the spectral density of the loss differential at frequency zero, `γ_d(τ) = E[(d_t − μ)(d_{t−τ} − μ)]` is the autocovariance at displacement `τ`, and `μ` is the population mean loss differential. The `f_d(0)` formula shows why the correction for serial correlation can be substantial even when the loss differential is only weakly serially correlated: the whole autocovariance function cumulates into the frequency-zero density.

Because in large samples `d̄` is approximately `N(μ, 2π f_d(0) / T)`, the obvious `N(0, 1)` statistic for the equal-accuracy null is `S1 = d̄ / sqrt(2π f̂_d(0) / T)`, where `f̂_d(0)` is a consistent estimate of `f_d(0)`. Following standard practice, `2π f̂_d(0)` is a weighted sum of the sample autocovariances, `2π f̂_d(0) = Σ_τ 1(τ / S(T)) γ̂_d(τ)`, with `1(·)` a lag window and `S(T)` the truncation lag.

To motivate a practical window and truncation lag, recall that optimal `k`-step-ahead forecast errors are at most `(k − 1)`-dependent. Taking `(k − 1)`-dependence as a benchmark (and checking it empirically), only `(k − 1)` sample autocovariances need enter `f̂_d(0)` because the rest are zero. This suggests a **uniform (rectangular) lag window** with **truncation lag `S(T) = k − 1`** for a `k`-step forecast comparison: the uniform window assigns unit weight to every included autocovariance, which keeps the estimator consistent under `(k − 1)`-dependence. (For a one-step comparison, `k − 1 = 0`, so no autocovariance correction is needed and `S1` reduces to the mean over its ordinary standard error.)

Two caveats the paper flags. First, the Dirichlet spectral window associated with the rectangular lag window dips below zero at some frequencies, so the resulting spectral-density estimate is not guaranteed non-negative; in the rare event of a negative estimate, treat it as zero and automatically reject the null. If non-negativity must be imposed, use a Bartlett lag window (with the non-negative Fejér spectral window, as in Newey and West 1987), at the cost of growing the truncation lag with the sample size. Andrews (1991)'s quadratic-spectral window with plug-in bandwidth is another option. The practical, widely-used finite-sample refinement — Harvey, Leybourne, and Newbold's (1997) bias correction and Student-`t` reference distribution, which the corpus's [[data-snooping-bias]] page cites — is later work, not part of the 1995 paper, but is what most software now applies on top of `S1`.

For this corpus, `S1` is the significance test that converts a bare "model A's out-of-sample RMSE is lower than model B's" — the kind of point comparison [Meese and Rogoff 1983](papers--meese-rogoff-exchange-rate-models-seventies-1983--random-walk-benchmark-survives-the-horse-race.md) reported without a formal test — into a testable claim, while correctly accounting for the serial correlation multi-step forecast errors carry.

Source: Diebold and Mariano 1995, section 1.1, canonical DOI [10.1080/07350015.1995.10524599](https://doi.org/10.1080/07350015.1995.10524599); readable PDF [author copy (F. Diebold, U. Penn)](https://www.sas.upenn.edu/~fdiebold/papers/paper68/pa.dm.pdf), sha256 `93aadf7294c5`.
