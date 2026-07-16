---
title: Quadratic return variation and realized volatility (the theory)
source: "Modeling and Forecasting Realized Volatility"
source_kind: paper
source_authors: [Torben G. Andersen, Tim Bollerslev, Francis X. Diebold, Paul Labys]
source_year: 2003
source_venue: "Econometrica 71(2):579-625 (2003); NBER Working Paper No. 8160 (March 2001)"
source_url: https://doi.org/10.1111/1468-0262.00418
source_pdf_sha256: a14e0e5de7e8b13b9218dbe503041a78d9416c49d9a36eafc909333ebfdea7ea
ingested: 2026-07-16
ingested_by: scholar
topics: [financial-forecasting]
status: current
---

Abstract: The theoretical core that makes realized volatility a legitimate volatility measure rather than a heuristic. Under the assumption that log prices follow an arbitrage-free semi-martingale, the return process has a **quadratic variation** process, and cumulating cross-products of ever-finer high-frequency returns converges (in probability, uniformly) to it. The paper's Theorem 1 shows the conditional return covariance matrix is dominated by the expected quadratic variation, because over a short horizon h the return-innovation (martingale) variation is order h while the mean's contribution is order h-squared and so negligible. Consequently the ex-post realized quadratic variation is an (essentially) unbiased, asymptotically error-free estimator of the conditional return covariance. For the continuous-sample-path case, Theorem 2 further shows returns are conditionally Gaussian given the volatility path, so daily returns follow a Gaussian mixture governed by the realized daily quadratic variation. This is the justification for treating volatility as *observed*.

## Semi-martingale prices and quadratic variation

Assume an n-dimensional arbitrage-free log-price vector process with finite mean. Modern stochastic-integration theory (the paper's Proposition 1) gives it a unique canonical decomposition into a predictable finite-variation component A (the mean drift) and a local martingale M (the return innovation), which may be split further into a continuous part and a compensated jump part. The cumulative return process inherits this decomposition.

Because the return process is a semi-martingale it has an associated **quadratic variation** matrix process [r,r] (Proposition 2). Its i-th diagonal element is the quadratic variation of asset i's return; the ij-th off-diagonal element is the quadratic covariation. The defining property: for an increasingly fine sequence of partitions of the trading interval, the sum of outer products of the partition-increment returns converges to [r,r]. This is exactly the recipe for **realized volatility**: measures obtained by cumulating cross-products of actual high-frequency returns. Two consequences matter: finite-variation (mean) components contribute zero quadratic variation, and jumps contribute their squared size one-for-one (and to covariation only when two assets jump simultaneously).

## Why the mean drift is negligible over short horizons

Theorem 1 decomposes the conditional return covariance over [t, t+h] into the expected quadratic variation plus terms involving the mean process. The key scaling argument: locally, the mean return is of order h and the variance of the mean of order h-squared, while the quadratic variation is of order h. So as the horizon shrinks the quadratic variation dominates. A worked illustration: for an asset with 1% daily standard deviation (about 15.8% annualized) and even a large 0.1% daily mean, the squared mean is only one-hundredth of the variance, and the within-day variation of the expected return is smaller still. Hence for daily or weekly returns the realized quadratic variation is the critical determinant of volatility, and equation (6) of the paper reduces the conditional covariance matrix to the conditional expectation of the quadratic variation. This holds even in the presence of a leverage effect (correlation between return innovations and future-volatility innovations), because leverage acts through the innovation-to-volatility channel, not through a contemporaneous mean-innovation correlation.

## Conditional normality given the volatility path

For a continuous-sample-path price process (no jumps), Theorem 2 gives a distributional result: conditional on the realized volatility (integrated-variance) path, the return over the horizon is multivariate normal with mean equal to the integrated drift and covariance equal to the integrated volatility. Since realized volatility can be approximated arbitrarily well from high-frequency data and the mean is negligible at daily/weekly horizons, daily returns follow a **Gaussian mixture** distribution with the realized daily quadratic variation governing the mixture. This is the theoretical anchor for the empirically observed approximate normality of realized-volatility-standardized returns, and hence for the lognormal-normal mixture used later for density and VaR forecasts. If standardized returns were *not* normal, it would signal the importance of jumps or contemporaneous return-volatility interactions.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003), Section 2; ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
