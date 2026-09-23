---
title: A Simple Approximate Long-Memory Model of Realized Volatility (heterogeneous market hypothesis and the volatility cascade)
source: "A Simple Approximate Long-Memory Model of Realized Volatility"
source_kind: paper
source_authors: [Fulvio Corsi]
source_year: 2009
source_venue: "Journal of Financial Econometrics 7(2):174-196 (2009)"
source_url: https://doi.org/10.1093/jjfinec/nbp001
source_pdf_sha256: 18c305635feefc152a0522791de67677b5db037dd10958a09134c7d55cf222e5
ingested: 2026-07-16
ingested_by: scholar
topics: [financial-forecasting]
status: current
---

Abstract: The economic motivation behind HAR-RV, from Corsi 2009 section 2.2. Rather than fractional integration (a mathematical device with no economic story), the long memory of volatility is explained by a **volatility cascade** across market participants with different time horizons -- the Heterogeneous Market Hypothesis. Short-term traders (dealers, intraday speculators), medium-term investors (weekly rebalancers), and long-term agents (pension funds, monthly horizon) each perceive, react to, and cause a distinct volatility component. Crucially the propagation is **asymmetric**: long-horizon volatility drives short-horizon volatility more than the reverse, because short-term traders care about the long-term volatility level (it sets expected trend size and risk) while long-term traders ignore short-term noise. This hierarchical cascade from low to high frequency is what a three-component additive model captures, and what gives HAR its economically interpretable coefficients.

## The Heterogeneous Market Hypothesis

The motivating idea (Muller et al. 1993) is that a financial market is populated by participants operating at a wide spectrum of trading frequencies, and heterogeneity across those horizons -- not a single representative agent -- generates the observed volatility dynamics. Related framings Corsi cites: the Fractal Market Hypothesis (Peters 1994), the Interacting Agent view (Lux & Marchesi 1999; Alfarano & Lux 2007), agent-based markets (LeBaron 2006), and the Mixture of Distribution Hypothesis (Andersen & Bollerslev 1997), where the multi-component structure comes from heterogeneous information arrivals.

Corsi concentrates on heterogeneity of **time horizon**. Simplifying the continuous spectrum of trader frequencies to three primary components:

- **short-term traders** -- dealers, market makers, intraday speculators, with daily or higher trading frequency;
- **medium-term investors** -- who typically rebalance weekly;
- **long-term agents** -- insurance companies and pension funds, with a characteristic time of one month or more, trading infrequently and in larger amounts.

Each type perceives, reacts to, and causes a different volatility component. This categorization has a clear economic interpretation yet had been largely overlooked in econometric modeling (the noteworthy exception Corsi credits is the HARCH model of Muller et al. 1997 and Dacorogna et al. 1998, which sums squared returns aggregated over different intervals).

## Asymmetric volatility propagation and the cascade

The empirical fact that shapes the model: **volatility over longer intervals influences volatility over shorter intervals more strongly than the reverse.** This asymmetry has been confirmed by several statistical tools (lead-lag correlation of "fine" and "coarse" volatility in a Granger-causal sense; wavelet analyses; direct visualization by Lynch & Zumbach 2003).

The economic mechanism: for short-term traders the *level of long-term volatility matters* because it determines the expected future size of trends and of risk. So short-term traders react to changes in long-term volatility by revising their behavior, thereby generating short-term volatility. But the level of short-term volatility does not affect long-term traders' strategies. The result is a one-directional **volatility cascade from low frequencies (long horizons) to high frequencies (short horizons)** -- an analogy some authors draw to the energy cascade in turbulent fluid dynamics (Kolmogorov-style multiplicative cascades; Ghashghaie et al. 1996).

This asymmetric cascade is the substance HAR encodes: each horizon's volatility component depends on its own past realized volatility (an "almost AR(1)" term) *and* on the expectation of the next-period longer-horizon volatility (the hierarchical term). The longest (monthly) component has only the AR(1) term. Recursively substituting the three partial volatilities collapses this cascade into the single HAR regression (see [the-har-rv-model-as-restricted-ar](papers--corsi-simple-long-memory-model-realized-volatility-2009--har-rv-model-as-restricted-ar.md)). The payoff of the economic story is interpretability: the fitted daily/weekly/monthly coefficients read directly as the relative contribution of each market component to overall volatility, and a moving-window regression traces how those weights evolve over time.

Source: Fulvio Corsi, *A Simple Approximate Long-Memory Model of Realized Volatility*, Journal of Financial Econometrics 7(2):174-196 (2009), section 2.2, doi:10.1093/jjfinec/nbp001; ingested from an open-access PDF copy, sha256 `18c30563`.
