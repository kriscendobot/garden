---
id: efficient-market-hypothesis
aliases: [efficient market hypothesis, EMH, market efficiency, limits of predictability, return predictability, random walk, adaptive markets, equity premium prediction, Meese-Rogoff, weak-form efficiency, semi-strong efficiency]
topics: [financial-forecasting, forecast-evaluation]
---

# efficient-market-hypothesis

The proposition that asset prices already reflect available information, so *predictable* excess returns are competed away (Fama 1970, *J. Finance*, "Efficient Capital Markets"). The modern, evidence-based reading is not "markets are perfectly efficient" but "**predictable return components are small, unstable, and hard to capture after transaction costs**" (Lo's Adaptive Markets framing; Timmermann & Granger 2004). The practical, well-documented limits of predictability a forecasting system must respect: the **direction/sign of returns at short horizons, net of costs, is largely not forecastable**; **equity-premium predictors fail out of sample** and are unstable (Welch & Goyal 2008, *Review of Financial Studies* — standard predictors do not beat a simple historical mean out of sample); **exchange-rate and price-level point forecasts do not beat the random walk out of sample** (Meese & Rogoff 1983); and **turning points, crashes, and regime-change timing are not reliably forecastable**. What *is* forecastable — the system's sweet spot — is the **second moment**: conditional volatility (clustering, persistence, leverage; see [[garch-volatility-models]]), fat tails, and negative skew, plus the risk-adjusted benefit of volatility-managed exposure. The discipline this implies: forecast risk and size to it; be humble about return direction; and treat any backtested return edge as a fragile sample statistic (non-stationarity means live performance is typically well below backtest).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| _(Fama 1970 and Meese & Rogoff 1983 remain queued for a financial-forecasting follow-on)_ | — |
| [Welch & Goyal overview](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--overview.md) | A comprehensive common-protocol re-test finds published equity-premium predictors generally fail to beat the historical mean out of sample. |
| [annual results and Oil Shock instability](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--annual-results-and-oil-shock-instability.md) | The apparent annual success of many predictors is episode-dependent, with no model performing well after 1975 in the authors' sample. |
| [conclusion: historical mean is hard to beat](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--conclusion-historical-mean-is-hard-to-beat.md) | A return signal requires stable post-selection in- and out-of-sample performance, not regression significance alone. |
| [Meese & Rogoff overview](../sections/papers--meese-rogoff-exchange-rate-models-seventies-1983--overview.md) | The empirical random-walk benchmark for exchange-rate point forecasts, without claiming perfect efficiency. |
| [Meese & Rogoff random-walk result](../sections/papers--meese-rogoff-exchange-rate-models-seventies-1983--random-walk-benchmark-survives-the-horse-race.md) | Structural and time-series alternatives fail a stable held-out comparison with the current spot rate. |

## See also

- [[garch-volatility-models]] — the forecastable second moment, the complement to un-forecastable return direction.
- [[data-snooping-bias]] — why apparent return-predictability found in-sample usually vanishes out of sample.
- [[walk-forward-validation]] — the out-of-sample test that exposes fragile "edges."
