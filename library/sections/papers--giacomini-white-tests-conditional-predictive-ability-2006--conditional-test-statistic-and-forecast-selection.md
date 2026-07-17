---
title: "Conditional test statistic and forecast selection"
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

Abstract: The usable Giacomini-White procedure turns a conditional loss-difference hypothesis into moment restrictions by multiplying the loss difference by forecast-origin instruments `h_t`; a HAC covariance estimate then gives a chi-squared Wald test. With only a constant instrument it becomes an unconditional test. With state variables or lagged relative performance as instruments, rejection says the relative loss is predictably state-dependent, not merely that one average is lower.

For one-step forecasts the test is a standard regression-style Wald statistic. For multi-step forecasts, overlapping targets induce serial dependence, so the covariance estimate must remain long-run-variance robust. The method does not select a loss or an instrument set for the analyst: those choices state the decision problem and the information permitted at forecast time. Reporting them is as necessary as reporting the estimation window.

The proposed two-step selection rule first tests equal conditional predictive ability. If rejected, it predicts the sign of the next conditional loss difference from the fitted conditional relation and chooses the method predicted to have lower loss. This is a decision rule for a pre-specified pair, not a replacement for data-snooping control after trying many models or many instrument specifications.

Source: Giacomini and White 2006, sections 3-4, canonical DOI [10.1111/j.1468-0262.2006.00718.x](https://doi.org/10.1111/j.1468-0262.2006.00718.x); readable PDF [course-hosted published version](https://economia.uc3m.es/jgonzalo/teaching/PhdTimeSeries/GiacominiWhite.pdf), sha256 `cc6e86b69e2c`.
