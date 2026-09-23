---
title: Measuring realized volatility from intraday returns (sampling and microstructure)
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

Abstract: How realized volatility is actually built from tick data, and the central practical tension: the continuous-record theory wants the finest possible sampling, but real markets have microstructure frictions (bid/ask bounce, discrete/indicative quotes, strategic quote positioning) that contaminate returns sampled too finely. The paper resolves this by sampling at **thirty-minute** intervals, a frequency preliminary analysis showed strikes a satisfactory balance between the accuracy of the continuous-record asymptotics and the confounding influence of microstructure noise. Realized daily volatility is then the sum of the outer products of the intraday 30-minute return vectors within the day. This sampling-frequency trade-off is the practical caveat every realized-volatility / HAR implementation inherits, and the reason naive "use the finest ticks" is wrong.

## The data and the construction

The empirical work uses all interbank DM/$ and yen/$ bid/ask quotes on the Reuters FXFX screen from December 1986 through June 1999 (several million quotes). Thirty-minute prices are computed as the linearly-interpolated log average of the bid and ask for the two ticks bracketing each thirty-minute stamp across the global 24-hour trading day; thirty-minute returns are first differences of those log prices. Weekend returns (Friday 21:00 GMT to Sunday 21:00 GMT) and a number of low-activity holiday days are excluded to avoid modeling calendar effects, leaving 3,045 daily observations, partitioned into a 2,449-day in-sample estimation period (Dec 1986 to Dec 1996) and a 596-day out-of-sample forecast-evaluation period (Dec 1996 to Jun 1999).

The h-day realized volatility is defined as V(t,h) = R'R, where R stacks the intraday 30-minute return vectors over the h-day window: the sum of outer products of the high-frequency returns. For the daily horizon this is just the sum, over a day's 48 half-hour intervals, of the return outer products. This yields realized variances on the diagonal and realized covariances off-diagonal, so the whole covariance matrix is measured directly, which is what makes the multivariate extension cheap.

## The sampling-frequency trade-off (the load-bearing caveat)

Indicative interbank quotes are non-binding and carry microstructure frictions: strategic quote positioning and a standardized bid/ask spread size. These are immaterial at longer horizons but distort the statistical properties of very-high-frequency returns. The frequency at which they start to matter depends on market activity. For these liquid exchange rates, thirty minutes was found to balance two competing errors: sampling more finely sharpens the continuous-record asymptotics that make realized volatility an accurate estimator, but also lets microstructure noise dominate; sampling more coarsely throws away the intraday information that is the entire point. The paper deliberately avoids the alternative of explicitly modeling the microstructure at the tick level, calling that far more complicated and subject to its own pitfalls. Any realized-volatility or HAR-style model applied to a less liquid instrument must re-derive this balance for its own data; there is no universal sampling frequency.

Source: Andersen, Bollerslev, Diebold & Labys, *Modeling and Forecasting Realized Volatility*, Econometrica 71(2):579-625 (2003), Section 3; ingested from the open NBER Working Paper No. 8160 ([nber.org/papers/w8160](https://www.nber.org/papers/w8160)), sha256 `a14e0e5d`.
