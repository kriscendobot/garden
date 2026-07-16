---
title: Volatility Forecast Comparison Using Imperfect Volatility Proxies (conclusion: evaluation contract)
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

Abstract: Patton concludes that volatility forecasts must be judged through an imperfect proxy, so the loss function is part of the scientific claim rather than a reporting cosmetic. The paper supplies a robust class that includes MSE and QLIKE, and its IBM example shows the choice can affect inferential power and a model-selection conclusion. The same logic extends to other latent economic targets, where a proxy is observed but the quantity a user actually cares about is not.

## A compact contract for volatility comparisons

For every comparison, state the latent target (conditional variance or integrated variance), the feasible proxy, the loss, the time-respecting forecast-origin protocol, and the statistical comparison of loss differences. If the target is variance and the proxy is imperfect, choose a loss from the robust class. QLIKE is the practical default when positive forecasts and a scale-invariant, tail-tolerant score are wanted; MSE is a valid alternative under its stronger assumptions.

The conclusion complements, rather than replaces, careful data construction. Higher-frequency realized measures improve the proxy; [[walk-forward-validation]] prevents future leakage; and [[data-snooping-bias]] warns that selecting a winner from a large model catalogue requires multiplicity-aware evidence. Robust loss protects one link in that chain.

Source: Andrew J. Patton, *Volatility Forecast Comparison Using Imperfect Volatility Proxies*, section 5, doi:10.1016/j.jeconom.2010.03.034; open author PDF sha256 `2b85bc30`.
