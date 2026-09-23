---
title: "Studentization and dependence-aware power"
source: "Stepwise Multiple Testing as Formalized Data Snooping"
source_kind: paper
source_authors: [Joseph P. Romano, Michael Wolf]
source_year: 2005
source_venue: "Econometrica 73(4):1237-1282"
source_url: https://doi.org/10.1111/j.1468-0262.2005.00615.x
source_pdf_sha256: ef3ed6fa9c91e2e2bb1f0c8b6bec84d2627941274f92c913e5a9e2f6cebe60ee
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: The studentized StepM variant ranks `z_T,k = w_T,k / sigma-hat_T,k` rather than raw performance contrasts, and bootstraps the maximum of the correspondingly studentized centered statistics. It retains asymptotic strong FWER control under a stronger variance-consistency condition. The key practical reason is comparability: raw statistics with different sampling variances live on different scales, so a common raw critical value gives uneven individual confidence coverage and uneven power. Individual studentization balances those intervals and often improves finite-sample size and power, particularly for dependent time series.

The gain is not an unconditional theorem that studentizing always rejects more. The authors explicitly say the studentized method need not uniformly dominate the basic method. It is preferred because the unknown data-generating mechanism prevents choosing the better one in advance, the individual decisions are better balanced, and their simulations show raw StepM can have poor finite-sample FWER behavior with substantial serial dependence while studentized StepM performs better. The bootstrap must resample the time dependence and reapply the variance-estimation scheme to each pseudo-sample; studentization does not license treating autocorrelated forecast or return observations as independent.

Source: Romano and Wolf 2005, pp. 1249-1253 and conclusion; canonical DOI [10.1111/j.1468-0262.2005.00615.x](https://doi.org/10.1111/j.1468-0262.2005.00615.x); working-paper provenance and sha256 `ef3ed6fa9c91` as recorded in the source index.
