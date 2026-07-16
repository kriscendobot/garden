---
id: garch-volatility-models
aliases: [GARCH, ARCH, GARCH(1,1), GJR-GARCH, GJR, EGARCH, volatility clustering, volatility persistence, conditional heteroskedasticity, conditional volatility, leverage effect, RiskMetrics, EWMA volatility, realized volatility, HAR, HAR-RV, stochastic volatility, volatility forecasting, volatility targeting]
topics: [financial-forecasting, forecast-evaluation]
---

# garch-volatility-models

The family of models that forecast **conditional volatility** — the time-varying variance of returns — exploiting *volatility clustering*, one of the most robust stylized facts in finance (large changes follow large changes; Mandelbrot 1963; Cont 2001). **ARCH** (Engle 1982, *Econometrica*) makes variance a function of recent squared returns; **GARCH** (Bollerslev 1986, *J. Econometrics*) adds lagged variance, so a compact GARCH(1,1) captures high persistence with few parameters and is famously hard to beat (Hansen & Lunde 2005 tested 330 models: "does anything beat a GARCH(1,1)?" — for exchange rates, not clearly). Asymmetric variants capture the **leverage effect** (down moves raise future volatility more than up moves): **GJR-GARCH** (Glosten, Jagannathan & Runkle 1993) adds an indicator term, **EGARCH** (Nelson 1991, *Econometrica*) models log-variance (no positivity constraints, multiplicative asymmetry). Cheaper cousins: **RiskMetrics EWMA** (J.P. Morgan 1996), an IGARCH with fixed λ≈0.94, a strong baseline; and, with intraday data, **realized-volatility / HAR** models (Andersen et al. 2003; Corsi 2009). Volatility is genuinely forecastable (unlike return direction — see [[efficient-market-hypothesis]]), which is why volatility-forecasting-and-**targeting** systems (scale exposure inversely to forecast risk; Moreira & Muir 2017) rest on firmer empirical ground than return-alpha predictors. The garden's [finbot](../../projects/finbot/README.md) is built on this family (symmetric GARCH → GJR-GARCH via deterministic MLE; EGARCH on the roadmap). Whether a more complex variant is worth its parameters is an **out-of-sample** question — decide it with QLIKE loss inside a [[walk-forward-validation]] harness and a Model Confidence Set, not by assumption.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| _(no library section yet — the GARCH-family source papers are queued for the follow-on `scholar-ingest-financial-forecasting-corpus` job)_ | — |

## See also

- [[efficient-market-hypothesis]] — why the *second* moment (volatility) is forecastable but the *first* moment (return direction) largely is not.
- [[walk-forward-validation]] — how to decide out-of-sample whether GJR/EGARCH beats a plain GARCH(1,1)/EWMA baseline.
- [[data-snooping-bias]] — comparing many volatility variants inflates the odds the "best" wins by luck; use QLIKE + the Model Confidence Set.
