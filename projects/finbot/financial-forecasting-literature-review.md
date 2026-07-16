# Financial-forecasting literature review — for the finbot builder

> Abstract: A consolidated, actionable synthesis of the academic literature on financial / market forecasting, written for the finbot builder (the `finbot-progress` press). It meets finbot where it is — a deterministic GARCH-family **volatility** forecaster driving regime-aware **volatility-targeting** position sizing — and answers three questions in order of value: (1) which methods are worth adopting and in what value-to-effort order; (2) the evaluation and anti-overfitting discipline finbot **must** adopt before trusting any model, which is the single highest-value thing missing today; and (3) what the literature holds is *not* reliably forecastable, and the pitfalls that have sunk countless backtested strategies. The one-line thesis: **finbot is forecasting the right thing (volatility, which is forecastable) the right way (parametric, deterministic, out-of-sample-fittable); its next unit of value is not another volatility model but an out-of-sample, cost-aware, baseline-relative *evaluation harness* — without it, "the GJR model helps" is an untested claim.** This is a derived-from synthesis of the cited literature, not the original works.

This report is a synthesis derived from the sources cited below; it is not a substitute for them and does not reproduce them. Library entries created for this survey are linked with relative paths; the broader literature is cited by author/year/venue inline.

---

## 0. What finbot is, and why the literature endorses its core

finbot forecasts **conditional volatility** with GARCH-family models fit by deterministic maximum likelihood (symmetric GARCH → GJR-GARCH leverage; EGARCH on the roadmap), and uses the forecast to *size* positions (volatility targeting: cut exposure when forecast risk is high, e.g. half-size at persistence ≈ 0.98). It does **not** predict the direction/sign of returns.

This is, from the literature's point of view, exactly the right division of labour, and it is worth stating loudly up front because it protects finbot from the most common way trading systems fail:

- **Volatility is strongly forecastable.** Volatility clustering — large changes follow large changes — is one of the most robust stylized facts in all of empirical finance (Mandelbrot 1963; Engle 1982, *Econometrica*, "Autoregressive Conditional Heteroskedasticity"; Bollerslev 1986, *J. Econometrics*, "Generalized ARCH"; Cont 2001, *Quantitative Finance*, "Empirical properties of asset returns: stylized facts"). Conditional variance has real, exploitable persistence. finbot's persistence ≈ 0.98 estimate is textbook.
- **The direction of returns is, at tradeable horizons and net of costs, largely *not* forecastable** (see §4). Systems that chase return-sign "alpha" are fighting the efficient-market null and usually lose to costs and overfitting.

So: **keep the core.** finbot's forecast target and its parametric, deterministic, no-RNG, out-of-sample-fittable approach is defensible and unusually clean. The recommendations below are about (a) squeezing more value from the volatility axis at low effort, and (b) — far more important — building the evaluation scaffolding that tells finbot whether any of its models actually earn their complexity.

---

## 1. Methods worth adopting, in value-to-effort order

Ranked by *(value to finbot) ÷ (effort)*, highest first. The top of the list is deliberately **not** more models.

### Tier 1 — do these first (highest value, modest effort)

1. **A walk-forward, out-of-sample evaluation harness for the *policy*, with baselines.** This is the highest-value item in the entire report and it is not a model — it is the thing that makes every model claim testable. finbot today proves *parameter recovery on synthetic DGPs* (excellent MLE discipline), but that is not the same as proving the model *forecasts better out of sample on real prices*, and it says nothing about whether the *trading policy* makes money after costs. Adopt time-series cross-validation / rolling-forecast-origin evaluation ([walk-forward-validation](../../library/concepts/walk-forward-validation.md); Hyndman & Athanasopoulos, *FPP3* §5.10, [tscv section](../../library/sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md)). See §2 — this is the report's core.

2. **Baseline forecasters to beat.** A volatility model is only worth its complexity if it beats a *naive* baseline out of sample. The mandatory baselines: (a) the **random-walk / previous-value** variance, (b) a **rolling-window historical variance**, and (c) **RiskMetrics EWMA** (exponentially weighted moving average variance, λ ≈ 0.94 for daily; J.P. Morgan/Reuters *RiskMetrics Technical Document*, 1996) — EWMA is IGARCH with fixed parameters and is a famously hard-to-beat volatility baseline. Score forecasts as **scaled errors against the naive** ([mean-absolute-scaled-error](../../library/concepts/mean-absolute-scaled-error.md); Hyndman & Koehler 2006, *Int. J. Forecasting*) so "MASE/RMSSE < 1" literally means "beats naive." **If GJR-GARCH does not beat EWMA out of sample on QLIKE loss, its extra parameter is not earning its keep** — and finbot cannot know this today.

3. **A proper volatility loss function: QLIKE (and MSE) on a good variance proxy.** Volatility is latent, so you must score forecasts against a *proxy* for realized variance. The literature's standard robust choices are **MSE** and **QLIKE** — these are the two loss functions proven "robust" to noise in the variance proxy (Patton 2011, *J. Econometrics*, "Volatility forecast comparison using imperfect volatility proxies"). Use squared daily returns, or better, a **realized-variance** proxy if any higher-frequency data is available (Andersen, Bollerslev, Diebold & Labys 2003, *Econometrica*, "Modeling and forecasting realized volatility"). QLIKE is generally preferred because it penalizes under-prediction of variance (dangerous for a risk system) more sharply than MSE.

4. **Formal forecast-comparison tests, so model choice is not eyeballed.** Once you have out-of-sample losses per model, compare them with the **Diebold–Mariano test** (Diebold & Mariano 1995, *J. Business & Economic Statistics*; small-sample correction, Harvey, Leybourne & Newbold 1997) ([diebold-mariano-test keyword → data-snooping-bias](../../library/concepts/data-snooping-bias.md)). When comparing *more than two* models (symmetric vs GJR vs EGARCH vs EWMA — finbot is already in this regime), a single pairwise test is not enough; use the **Model Confidence Set** (Hansen, Lunde & Nason 2011, *Econometrica*) to retain the set of models statistically indistinguishable from the best, or **Hansen's SPA** / **White's Reality Check** (§2.3) to test "does my best model beat the benchmark once I account for having tried many?".

### Tier 2 — solid incremental value, moderate effort

5. **EGARCH (roadmap item) — but gate it on the harness.** EGARCH (Nelson 1991, *Econometrica*, "Conditional heteroskedasticity in asset returns: a new approach") models the log-variance, so it needs no positivity constraints and captures leverage multiplicatively. It is a reasonable next model — but its marginal value over GJR-GARCH is *an empirical question the harness answers*, not a foregone conclusion. Build item 1–4 first; then EGARCH becomes one more entrant in the Model Confidence Set rather than a leap of faith. The literature's verdict on GARCH variants is sobering: Hansen & Lunde (2005, *J. Applied Econometrics*, "A forecast comparison of volatility models: does anything beat a GARCH(1,1)?") tested 330 models and found **plain GARCH(1,1) is not clearly beaten for exchange rates**, though asymmetric models (GJR/EGARCH) do help for equities where the leverage effect is strong. finbot's GJR work is well-motivated for equity-like/crypto assets; do not assume EGARCH adds more.

6. **Close the symmetric-vs-asymmetric consistency gap you already flagged.** The builder's own note (2026-07-16) identifies that `conditionalVolFromPriceHistory` rolls the *symmetric* surface forward even when the fitted world is GJR — so the auditor's tail floor and the analyzer's sizing see magnitude-conditional vol, not down-move-conditional vol. This is both a correctness issue *and* an evaluation issue: with the harness in place you can measure whether the GJR roll-forward actually improves out-of-sample QLIKE/tail-coverage before wiring it into sizing. Fix + measure, not fix + assume. **Beware this is also a look-ahead trap** (§3): make sure the roll-forward only ever conditions on information available at the decision time.

7. **Volatility-targeting sizing is well-supported — evaluate it as a policy.** The finding that scaling exposure inversely to forecast volatility improves risk-adjusted returns (higher Sharpe, smaller drawdowns, less negative skew) is robust across asset classes (Moreira & Muir 2017, *J. Finance*, "Volatility-managed portfolios"; Harvey et al. 2018, "The impact of volatility targeting"). finbot's core sizing logic is on solid ground. The value-add is to *backtest the sizing policy itself* against a constant-exposure baseline within the walk-forward harness (does vol-targeting raise net-of-cost Sharpe here?).

### Tier 3 — only if a specific need appears; guard against complexity

8. **Realized-volatility / HAR models** (Corsi 2009, *J. Financial Econometrics*, "A simple approximate long-memory model of realized volatility") — *if and only if* finbot ingests intraday data. HAR-RV is cheap and often beats daily GARCH when high-frequency data exists. With only daily closes, it does not apply.

9. **Regime-switching models** (Markov-switching, Hamilton 1989, *Econometrica*). finbot already has a "regime read"; a formal Markov-switching layer is more machinery for often-fragile out-of-sample gains. Defer unless the harness shows a clear regime-conditional failure of the single-regime model.

10. **Machine-learning forecasters — approach with heavy skepticism for *this* system.** The honest state of the ML-for-finance literature:
    - For **return prediction across the cross-section of many assets**, ML (gradient-boosted trees, neural nets) does add measurable value: Gu, Kelly & Xiu (2020, *Review of Financial Studies*, "Empirical asset pricing via machine learning") is the canonical result — trees and shallow nets beat linear models on out-of-sample R² for monthly equity returns, with a strict expanding-window protocol. But this is a *large-cross-section, low-frequency* setting with hundreds of predictors, and even there out-of-sample monthly R² is ~0.4% (real but tiny).
    - For **a single (or few) asset's next-step return or volatility**, deep models (LSTM, temporal-CNN, Transformers) rarely beat well-tuned parametric baselines out of sample once costs and overfitting are controlled; the apparent wins in the applied literature are riddled with the pitfalls in §3 (look-ahead, no costs, cherry-picked windows). Makridakis, Spiliotis & Assimakopoulos (2018, *PLoS ONE*, "Statistical and Machine Learning forecasting methods: concerns and ways forward") and the **M4/M5 competitions** found pure-ML methods frequently *lost* to statistical methods and simple combinations; the winners were **hybrids** (ES-RNN) and **ensembles**.
    - **Recommendation for finbot: do not add an LSTM/Transformer return predictor.** It fights the un-forecastable target (§4), it breaks the clean determinism finbot prizes, and it is the highest-overfitting-risk category. If ML is ever used, use gradient-boosted trees for *volatility* forecasting only, inside the same walk-forward harness, and only adopt it if it beats GARCH/EWMA in the Model Confidence Set.

### What to *stop* being tempted by

- **Return-direction / sign prediction as alpha.** See §4. This is the road to overfit ruin; finbot's volatility+sizing framing already sidesteps it — keep it that way.
- **Adding models before adding evaluation.** Every model added without a harness increases the multiple-testing burden (§2.3) and the odds that the "best" one is best by luck.

---

## 2. The evaluation and anti-overfitting discipline finbot MUST follow

*This is the strongest and most important section. A trading model without this discipline is not a model, it is a hypothesis dressed as a conclusion.* The financial-ML literature is unusually blunt that **most published backtested strategies are false positives** produced by insufficiently disciplined evaluation (Bailey, Borwein, López de Prado & Zhu 2014, "Pseudo-mathematics and financial charlatanism," *Notices of the AMS*; López de Prado 2018, *Advances in Financial Machine Learning*).

### 2.1 Walk-forward / expanding-window out-of-sample, always

The only trustworthy accuracy estimate comes from **genuine forecasts on data not used to fit the model** (Hyndman & Athanasopoulos, *FPP3* §5.8, [training-and-test-sets section](../../library/sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md)): a model that fits the training data well *will not necessarily forecast well*, and a perfect in-sample fit is always attainable with enough parameters. The time-series-correct form is **evaluation on a rolling forecasting origin** ([walk-forward-validation](../../library/concepts/walk-forward-validation.md), [tscv section](../../library/sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md)):

- Fit on data up to time *t*, forecast *t+1…t+h*, roll *t* forward, average errors over all origins.
- **Never** use plain k-fold cross-validation (it leaks future into past) and **never** shuffle time-series rows.
- Prefer **expanding window** (all history so far) as the default; use a **rolling fixed window** if you believe old data is non-representative (a regime bet — test it, don't assume it).
- The test span should be **at least as long as the maximum forecast horizon** and long enough to span multiple market regimes (a backtest that never saw a crash tells you nothing about crash behavior).

**Concretely for finbot:** its OODA loop is naturally a rolling origin. The deliverable is a harness that, for each decision date, fits every model on only-prior data, records the one-step (and h-step) volatility forecast and the realized proxy, and accumulates per-model out-of-sample loss — plus a parallel record of the *policy's* realized P&L net of costs.

### 2.2 Baselines and honest skill metrics

- **Beat a naive baseline or it is not skill.** Score with **MASE / RMSSE** (scaled to the naive/seasonal-naive one-step error, [scaled-errors section](../../library/sections/web--hyndman-fpp3-forecast-evaluation--percentage-and-scaled-errors-mase.md); Hyndman & Koehler 2006) so the number *is* the skill-vs-naive ratio (<1 = beats naive). For volatility specifically, use **QLIKE/MSE on a variance proxy** (§1.3) against the **EWMA/random-walk-variance** baseline.
- **Directional accuracy** (% of correct up/down calls) is a *weak* metric — it ignores magnitude and is easy to game; if reported, test it against 50% with a proper test, and never trust it alone.
- **Score the strategy, not just the forecast.** The forecast metric (QLIKE) and the economic metric can disagree. Report the policy's **out-of-sample Sharpe ratio net of transaction costs**, **maximum drawdown**, **skewness/tail behavior**, and **turnover** — against the constant-exposure and buy-and-hold baselines. A model that lowers QLIKE but raises turnover-costs more than it saves is a net loss.
- **Transaction-cost realism is not optional.** The single most common reason a backtest evaporates live is unmodeled costs: bid-ask spread, market impact/slippage, and (for crypto) fees and funding. López de Prado (2018) and the M5 "uncertainty" track both stress this. Charge realistic costs on **every** simulated trade, sized to finbot's actual venue; a vol-targeting policy that re-sizes often is *especially* cost-sensitive.

### 2.3 Data-snooping / multiple-testing corrections — the finbot-specific trap

finbot is *already* comparing model variants (symmetric vs GJR vs EGARCH vs EWMA…) and will compare more. **Every additional model or parameter you try inflates the chance the "winner" wins by luck.** This is data snooping ([data-snooping-bias](../../library/concepts/data-snooping-bias.md)), and it is the central methodological hazard the literature warns about:

- **White's Reality Check** (White 2000, *Econometrica*, "A reality check for data snooping") and **Hansen's Superior Predictive Ability (SPA)** test (Hansen 2005, *J. Business & Economic Statistics*) test the null "the best model is no better than the benchmark" *while accounting for the full universe of models searched*. Use SPA (it is less sensitive to poor/irrelevant models than the Reality Check) whenever you declare a best model.
- **Model Confidence Set** (Hansen, Lunde & Nason 2011) — the practical everyday tool: it returns the *set* of models you cannot statistically distinguish from the best at a given confidence. If GJR, EGARCH, and EWMA all land in the MCS, you have *no evidence* to prefer the more complex one — pick the simplest (EWMA/GARCH(1,1)) by Occam.
- **Deflated Sharpe Ratio** (Bailey & López de Prado 2014, *J. Portfolio Management*) — when you report a strategy Sharpe, *deflate* it for the number of configurations tried and the non-normality of returns. A Sharpe of 1.5 found after trying 50 variants may be indistinguishable from zero. Track and report **the number of trials**; silent multiple testing is the charlatan's tell (Bailey et al. 2014, *Notices of the AMS*).
- **Practical rule:** keep a running count of every model/parameter configuration ever evaluated against the same data, and apply one of the above corrections before any "X beats Y" claim reaches sizing or the maintainer.

### 2.4 The evaluation checklist finbot should encode

1. Fit on only-prior data (walk-forward, expanding window). No exceptions.
2. Forecast at the horizon you actually act on; score with QLIKE/MSE (vol) or MASE (point) on a proper proxy.
3. Compare against EWMA + random-walk-variance + rolling-historical baselines. Skill = beats naive.
4. Use Diebold–Mariano (2 models) or Model Confidence Set / SPA (many models) — never eyeball.
5. Backtest the *policy* net of realistic transaction costs; report Sharpe, drawdown, turnover, tail, vs constant-exposure + buy-and-hold.
6. Count trials; deflate the Sharpe; apply a data-snooping correction before any comparative claim.
7. Reserve a final **untouched** holdout period never used in any model selection — look at it *once*, at the end.

---

## 3. Pitfalls to avoid (the biases that kill live performance)

Each of these makes a backtest look better than reality; all are documented failure modes.

- **Look-ahead bias / information leakage** ([look-ahead-bias](../../library/concepts/look-ahead-bias.md)). Using any data not available at the decision instant: a future value in a rolling stat, a same-bar close used to trade that bar, a parameter fit on the whole sample, a "realized" volatility that peeks past *t*. finbot's flagged symmetric-vs-GJR roll-forward is exactly where this can creep in — the roll-forward must condition only on info available at the decision time. *FPP3* §5.10 states the invariant plainly: "no future observations can be used in constructing the forecast."
- **Survivorship bias.** Backtesting only on assets/tokens that still exist today silently deletes the failures and inflates returns. For crypto this is severe (dead tokens, delistings, rug-pulls). Use point-in-time universes.
- **Data-snooping / backtest overfitting** (§2.3). The more you tune, the more the backtest is fitted to noise. Bailey et al. (2014) show that with enough trials you can manufacture an arbitrarily good in-sample Sharpe with **zero** true skill ("backtest overfitting").
- **Ignoring transaction costs and slippage** (§2.2). The default reason live ≪ backtest.
- **Non-stationarity / regime change.** Financial return distributions drift; parameters estimated in one regime fail in the next (Cont 2001). A backtested edge is a *sample* statistic, not a law. This is *the* reason to (a) test across multiple regimes, (b) prefer robust simple models, and (c) expect live Sharpe to be materially below backtest.
- **Multiple-horizon / metric shopping.** Reporting whichever horizon or metric looks best is data snooping by another name. Fix the horizon and metric to what the policy actually uses *before* looking.
- **Overfitting to a single asset/period.** finbot's per-asset MLE is good practice; guard it by requiring out-of-sample validation per asset and being suspicious of parameters that vary wildly across refits.

---

## 4. What the literature says is NOT reliably forecastable

Calibrating ambition is itself a deliverable — knowing what *not* to try saves the most effort and avoids the biggest overfitting traps.

- **The direction/sign of returns at short horizons, net of costs, is largely not forecastable.** The Efficient Market Hypothesis ([efficient-market-hypothesis](../../library/concepts/efficient-market-hypothesis.md); Fama 1970, *J. Finance*, "Efficient Capital Markets") holds that prices already reflect available information, so *predictable* excess returns are competed away. The modern, evidence-based reading is **not** "markets are perfectly efficient" but "**predictable return components are small, unstable, and hard to capture after costs**" (Lo 2004's Adaptive Markets framing; Timmermann & Granger 2004, *Int. J. Forecasting*, "Efficient market hypothesis and forecasting"). Short-horizon return prediction is the graveyard of overfit strategies.
- **Equity-premium predictability is weak and fragile out of sample.** Welch & Goyal (2008, *Review of Financial Studies*, "A comprehensive look at the empirical performance of equity premium prediction") showed that the standard predictors (dividend yield, term spread, etc.) fail to beat a simple historical-mean forecast out of sample and are unstable over time. In-sample "predictability" routinely vanishes out of sample.
- **Precise turning points, crash timing, and regime-change timing are not reliably forecastable.** You can forecast that volatility *clusters* and that tails are fat; you cannot reliably time the switch. Build for robustness to regime change, not prediction of it.
- **Long-horizon point forecasts of price levels** are dominated by the random-walk/drift null (Meese & Rogoff 1983, *J. International Economics*, for exchange rates — the classic "no model beats the random walk out of sample" result). Do not stake sizing on level forecasts.

**What *is* reliably forecastable — finbot's sweet spot:** conditional **volatility** (clustering, persistence, leverage/asymmetry), the **fat-tailedness** and **negative skew** of returns, and the risk-adjusted benefit of **volatility-managed exposure**. This is precisely finbot's core. The literature's guidance is therefore encouraging *and* disciplining: forecast the second moment (risk), size to it, and be humble about the first moment (return direction).

---

## 5. The one-paragraph brief for the next finbot builder cycle

You are forecasting the right thing (volatility) the right way (deterministic parametric MLE). Your next unit of value is **not** another volatility model — it is a **walk-forward, out-of-sample, cost-aware evaluation harness with naive baselines** (EWMA, random-walk variance, rolling historical), scoring volatility forecasts with **QLIKE** and the *policy* with net-of-cost **Sharpe/drawdown/turnover**, comparing models with the **Model Confidence Set / SPA**, and **deflating any Sharpe for the number of trials**. Build that, then let it referee GJR-vs-symmetric-vs-EGARCH (and the roll-forward consistency fix) instead of assuming the more complex model wins. Never let a model reach sizing on in-sample or parameter-recovery evidence alone. Keep resisting return-direction "alpha"; the literature says it mostly is not there after costs.

---

## Library entries created for this survey

Source ingested (Hyndman & Athanasopoulos, *Forecasting: Principles and Practice*, 3rd ed. — freely published; the canonical modern forecasting-evaluation reference):

- [web--hyndman-fpp3-forecast-evaluation](../../library/sources/web--hyndman-fpp3-forecast-evaluation.md) (source index)
  - [training-and-test-sets](../../library/sections/web--hyndman-fpp3-forecast-evaluation--training-and-test-sets.md)
  - [forecast-errors-and-scale-dependent-measures](../../library/sections/web--hyndman-fpp3-forecast-evaluation--forecast-errors-and-scale-dependent-measures.md)
  - [percentage-and-scaled-errors-mase](../../library/sections/web--hyndman-fpp3-forecast-evaluation--percentage-and-scaled-errors-mase.md)
  - [time-series-cross-validation](../../library/sections/web--hyndman-fpp3-forecast-evaluation--time-series-cross-validation.md)

Topics: [financial-forecasting](../../library/topics/financial-forecasting.md), [forecast-evaluation](../../library/topics/forecast-evaluation.md).

Concepts: [walk-forward-validation](../../library/concepts/walk-forward-validation.md), [mean-absolute-scaled-error](../../library/concepts/mean-absolute-scaled-error.md), [data-snooping-bias](../../library/concepts/data-snooping-bias.md), [look-ahead-bias](../../library/concepts/look-ahead-bias.md), [garch-volatility-models](../../library/concepts/garch-volatility-models.md), [efficient-market-hypothesis](../../library/concepts/efficient-market-hypothesis.md).

The remaining canonical sources named inline above (Engle 1982; Bollerslev 1986; Nelson 1991; Glosten-Jagannathan-Runkle 1993; Hansen & Lunde 2005; Patton 2011; Hansen-Lunde-Nason 2011; White 2000; Hansen 2005; Bailey & López de Prado 2014; López de Prado 2018; Gu-Kelly-Xiu 2020; Welch & Goyal 2008; Diebold & Mariano 1995; Corsi 2009; Moreira & Muir 2017) are queued for library ingestion by the follow-on `scholar-ingest-financial-forecasting-corpus` job; this report cites them by provenance in the meantime.
