---
title: "Forecasting methods and the conditional predictive-ability null"
source: "Tests of Conditional Predictive Ability"
source_kind: paper
source_authors: [Raffaella Giacomini, Halbert White]
source_year: 2006
source_venue: "Econometrica 74(6):1545-1578"
source_url: https://doi.org/10.1111/j.1468-0262.2006.00718.x
source_pdf_sha256: cc6e86b69e2cc70f484b45367528bd47f58e17f35102a87179ed3ce9060a0642
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: Giacomini and White change the object of a forecast comparison from idealized population-parameter models to the actual **forecasting methods** that issue forecasts: model, estimator, estimation window, and data choice together. Their conditional null asks whether the loss difference between two such methods has conditional mean zero given information available at the forecast origin. Thus it can ask not only whether one method was better on average, but whether current information predicts which will be more accurate at the next target date.

For forecasts `f_t(beta-hat_1t)` and `g_t(beta-hat_2t)` of `Y_(t+tau)`, evaluated by a general loss `L`, the null is `E[L(Y_(t+tau), f_t) - L(Y_(t+tau), g_t) | G_t] = 0`. Choosing a trivial information set yields the unconditional equal-predictive-ability case. Choosing informative instruments asks whether relative performance changes with the state, such as lagged loss differences. The paper likens the unconditional question to testing a regression intercept and the conditional question to testing structure left in the regression errors.

This nesting matters operationally. An unconditional tie does not mean that the methods are interchangeable at every date: a conditional test may support switching between them when the available information predicts the better method. Conversely, this is still a comparison of a stated loss. Under QLIKE or another variance loss it concerns conditional-volatility and risk forecasts; under a return or direction loss it concerns that different target. Neither result establishes the other.

Source: Giacomini and White 2006, abstract and sections 1-2, canonical DOI [10.1111/j.1468-0262.2006.00718.x](https://doi.org/10.1111/j.1468-0262.2006.00718.x); readable PDF [course-hosted published version](https://economia.uc3m.es/jgonzalo/teaching/PhdTimeSeries/GiacominiWhite.pdf), sha256 `cc6e86b69e2c`.
