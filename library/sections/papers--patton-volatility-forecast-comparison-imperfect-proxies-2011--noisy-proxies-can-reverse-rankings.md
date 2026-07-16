---
title: Volatility Forecast Comparison Using Imperfect Volatility Proxies (noisy proxies can reverse rankings)
source: "Volatility Forecast Comparison Using Imperfect Volatility Proxies"
source_kind: paper
source_authors: [Andrew J. Patton]
source_year: 2011
source_venue: "Journal of Econometrics 160(1):246-256"
source_url: https://doi.org/10.1016/j.jeconom.2010.03.034
source_pdf_sha256: 2b85bc30f188dc19d0ac7dbfe854929148d27c42e3f73d2b16605558daf60cee
ingested: 2026-07-16
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: Section 2 shows why a conditionally unbiased volatility proxy does not make every score safe. Against squared returns, MSE preserves the latent-variance optimum, while common alternatives such as squared error on standard deviations, logarithmic squared error, proportional squared error, and absolute proportional error target distorted quantities and can reverse forecast rankings. Better proxies reduce noise but do not repair a non-robust loss; realized variance and range remain imperfect in finite samples. The takeaway is that "more robust to outliers" is not a sufficient reason to change the loss function.

## Squared returns are not a complete answer

Under a zero conditional mean, r_t^2 is conditionally unbiased for sigma_t^2. That fact supports familiar forecast-comparison tests, but it does not mean every loss evaluated on r_t^2 ranks forecasts as the corresponding latent-variance loss would. Patton derives the optimal forecast implied by several commonly used losses and finds that some are systematically too low or too high even under favorable distributional assumptions. Therefore a loss chosen to reduce the influence of extreme observations can answer a different forecasting question from conditional-variance forecasting.

MSE is a useful exception: it has conditional variance as its optimum and satisfies the robustness condition under the stated proxy assumptions. The paper treats this as a property to prove, not a default to assume from squared-error familiarity.

## Better proxies reduce error, not the need for a proper loss

An intraday range and realized variance usually contain more information about a day's volatility than one squared daily return. Patton's calculations show that they can sharply reduce measurement error. But neither is exact: range adjustments rely on modeling assumptions, and realized variance is affected by sampling and market microstructure. With a non-robust loss, the ranking distortion therefore remains possible even when the proxy is much more precise.

For an implementation, this means realized variance is a valuable target when intraday data exists, but it is not a license to score with arbitrary percentage, log, or standard-deviation losses. Pair the proxy with a loss whose ranking property has been established.

Source: Andrew J. Patton, *Volatility Forecast Comparison Using Imperfect Volatility Proxies*, section 2, doi:10.1016/j.jeconom.2010.03.034; open author PDF sha256 `2b85bc30`.
