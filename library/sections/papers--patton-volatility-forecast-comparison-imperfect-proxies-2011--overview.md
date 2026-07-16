---
title: Volatility Forecast Comparison Using Imperfect Volatility Proxies (overview)
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

Abstract: Patton 2011 establishes the evaluation rule that turns the library's recommendation to use **QLIKE** for volatility forecasts into a robustness result. Volatility is latent even after the forecast period, so a comparison substitutes a noisy proxy such as a squared return, intraday range, or realized variance. Conditional unbiasedness of that proxy alone does not preserve a ranking under arbitrary losses. Patton defines proxy-robust losses as those whose expected-loss ordering matches the ordering against latent conditional variance, derives their general form, and identifies MSE and QLIKE as especially useful cases. The practical implication is narrow but consequential: compare GARCH, HAR, EWMA, or volatility-managed forecasts in a walk-forward test using QLIKE (or MSE where its stronger assumptions fit), not whichever error transform happens to look benign on a noisy target.

## The latent-target problem

For a return r_t with information available at t-1, the target is conditional variance sigma_t^2 = E_{t-1}[r_t^2]. A forecast h_t is compared using a loss L(sigma_t^2, h_t), but sigma_t^2 cannot be observed. Squared daily returns, an intraday high-low range, and realized variance are feasible proxies. They can be conditionally unbiased yet noisy, so the forecast preferred by average feasible loss need not be the forecast that would be preferred against the latent variance.

Patton defines a loss as robust when the ranking of any two forecasts is unchanged by replacing the latent variance with an imperfect proxy. This separates two questions often conflated in a backtest: whether the proxy is a sensible estimate of realized risk, and whether the loss preserves the model ranking under that proxy's noise. It also explains why published volatility horse races can disagree when they use different loss functions.

## Why this matters to a forecasting harness

The result does not select a volatility model. It selects an evaluation protocol. A system may generate forecasts from GARCH, GJR-GARCH, EGARCH, HAR-RV, EWMA, or a learned model, but its model selection is reliable only when the scored proxy and loss answer the same latent-variance question. The correct operational sequence is: use an out-of-sample rolling origin, compute a feasible variance proxy available ex post, score every candidate with QLIKE, and test the loss differences rather than treating one average score as decisive. See [[walk-forward-validation]] for the time ordering and [[mean-absolute-scaled-error]] for the broader baseline-relative evaluation discipline.

Source: Andrew J. Patton, *Volatility Forecast Comparison Using Imperfect Volatility Proxies*, Journal of Econometrics 160(1):246-256 (2011), doi:10.1016/j.jeconom.2010.03.034; ingested from the author's Duke-hosted open PDF, sha256 `2b85bc30`.
