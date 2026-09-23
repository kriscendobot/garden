---
title: "Finite-window estimation uncertainty and scope"
source: "Tests of Conditional Predictive Ability"
source_kind: paper
source_authors: [Raffaella Giacomini, Halbert White]
source_year: 2006
source_venue: "Econometrica 74(6):1545-1578"
source_url: https://doi.org/10.1111/j.1468-0262.2006.00718.x
source_pdf_sha256: cc6e86b69e2cc70f484b45367528bd47f58e17f35102a87179ed3ce9060a0642
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: The paper's answer to the fitted-forecast problem is deliberately finite-sample: use a fixed estimation sample or a rolling window of fixed width, so the parameter estimates retain non-vanishing estimation uncertainty in the asymptotics. This makes the test evaluate the performance of a realizable forecasting method, including its bias-variance trade-off and refitting policy, rather than treating the estimated coefficients as if they had become known population constants.

Giacomini and White present this as a complement to the Diebold-Mariano and West framework. Diebold-Mariano compares given loss differentials. West carries parameter-estimation uncertainty into inference about population-model predictive ability. Here the fixed-width or rolling-window construction preserves the finite-sample behavior of the estimator and permits general parametric, semiparametric, nonparametric, and Bayesian estimation methods. It also provides one framework for forecasts from nested and nonnested models, where prior asymptotic formulas can be restrictive.

The restriction is substantive, not cosmetic: the stated theory is for limited-memory methods or fixed estimation samples, not a license to use an expanding recursive window under the same asymptotics. Rolling windows can be valuable when a misspecified model must track local dynamics, heterogeneity, or structural shifts, while an expanding window estimates a global average. The window rule is therefore part of the forecast method that must be recorded before comparing it.

Source: Giacomini and White 2006, sections 1-3, canonical DOI [10.1111/j.1468-0262.2006.00718.x](https://doi.org/10.1111/j.1468-0262.2006.00718.x); readable PDF [course-hosted published version](https://economia.uc3m.es/jgonzalo/teaching/PhdTimeSeries/GiacominiWhite.pdf), sha256 `cc6e86b69e2c`.
