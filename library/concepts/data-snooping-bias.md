---
id: data-snooping-bias
aliases: [data snooping, data-snooping bias, data mining bias, backtest overfitting, multiple testing, multiple hypothesis testing, Reality Check, White's Reality Check, Superior Predictive Ability, SPA test, Hansen SPA, Model Confidence Set, MCS, Deflated Sharpe Ratio, deflated sharpe, Diebold-Mariano, Diebold Mariano test, DM test, p-hacking, selection bias]
topics: [forecast-evaluation, financial-forecasting]
---

# data-snooping-bias

The inflation of apparent predictive skill caused by trying many models, parameters, or strategies against the same data and reporting the best — the single most-warned-against hazard in the empirical trading/forecasting literature. With enough trials an arbitrarily good in-sample result (Sharpe ratio, R², win rate) can be manufactured with **zero** true skill ("backtest overfitting"; Bailey, Borwein, López de Prado & Zhu 2014, *Notices of the AMS*). The corrections, in increasing everyday usefulness: the **Diebold–Mariano test** (Diebold & Mariano 1995) compares two forecasts' losses (small-sample correction: Harvey, Leybourne & Newbold 1997); **White's Reality Check** (White 2000, *Econometrica*) and **Hansen's Superior Predictive Ability (SPA)** test (Hansen 2005) test "the best of N models beats the benchmark" *while accounting for having searched N models* (SPA is preferred — robust to poor/irrelevant models); the **Model Confidence Set** (Hansen, Lunde & Nason 2011, *Econometrica*) returns the *set* of models statistically indistinguishable from the best (if several land in the MCS, prefer the simplest); and the **Deflated Sharpe Ratio** (Bailey & López de Prado 2014) discounts a reported Sharpe for the number of configurations tried and for return non-normality. **Practical rule: count every configuration ever evaluated against the data, and apply a correction before any "X beats Y" claim is trusted.**

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [training-and-test-sets](../sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md) | Over-fitting is as bad as under-fitting and a perfect in-sample fit is always attainable — the mechanism data snooping exploits across repeated trials. |
| [Welch & Goyal monthly horizons and specification search](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--monthly-horizons-and-specification-search.md) | The paper's 90 longer-memory ratio combinations show why the few attractive searched specifications need a future holdout period. |
| [Welch & Goyal conclusion](../sections/papers--welch-comprehensive-look-equity-premium-prediction-2008--conclusion-historical-mean-is-hard-to-beat.md) | More elaborate return-prediction searches enlarge the chance of a favorable configuration, so model selection cannot certify itself on the searched history. |
| [Hansen & Lunde SPA correction](../sections/papers--hansen-lunde-forecast-comparison-volatility-models-2005--spa-corrects-the-330-model-search.md) | SPA compares GARCH to the full 330-model candidate set, while a naive selected-best p-value ignores the search and Reality Check may lack power. |

## See also

- [[walk-forward-validation]] — necessary but not sufficient; out-of-sample protocol does not by itself correct multiple testing.
- [[mean-absolute-scaled-error]] — the metric whose best value across many trials must be deflated/corrected.
- [[look-ahead-bias]] — a distinct bias (information leakage) that also inflates backtests.
