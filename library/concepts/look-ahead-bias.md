---
id: look-ahead-bias
aliases: [look-ahead bias, lookahead bias, information leakage, future leakage, data leakage, survivorship bias, point-in-time, restatement bias, peeking]
topics: [forecast-evaluation, financial-forecasting]
---

# look-ahead-bias

Using, at a decision point, any information that would not actually have been available then — the most insidious way a backtest overstates live performance, because the code often looks correct. Common forms: a rolling statistic that includes a future value; trading a bar at a price only known at that bar's close; parameters fit on the whole sample (including the "future") rather than only-prior data; a "realized" volatility or label that peeks past the decision time; and using restated/revised fundamentals instead of the values known point-in-time. A close cousin is **survivorship bias** — backtesting only on assets/tokens that still exist today silently deletes the failures (delistings, defaults, rug-pulls) and inflates returns; use point-in-time universes. The structural defense is [[walk-forward-validation]], whose defining invariant (FPP3 §5.10) is that "no future observations can be used in constructing the forecast." For finbot specifically, a volatility surface rolled forward for a "regime read" must condition only on information available at the decision time — the exact place leakage tends to creep in.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [time-series-cross-validation](../sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md) | States the no-future-data invariant: the training set consists only of observations prior to the test observation. |

## See also

- [[walk-forward-validation]] — the protocol that structurally prevents look-ahead.
- [[data-snooping-bias]] — the other major backtest-inflating bias (multiple testing rather than leakage).
