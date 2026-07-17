---
title: "StepM stepdown, bootstrap calibration, and strong FWER"
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

Abstract: StepM ranks the `K` observed strategy statistics from largest to smallest, calibrates a simultaneous one-sided confidence region over every still-unrejected strategy, rejects every interval whose lower bound exceeds zero, and repeats on the remainder. The bootstrap supplies each step's `1-alpha` critical value for the maximum centered statistic over precisely that remaining set, preserving the joint dependence among strategies instead of paying a worst-case Bonferroni/Holm penalty. The algorithm stops only when a step rejects nothing.

The shrinking family is the source of the extra discoveries. The first step is the modified multi-declaration version of White's Reality Check. Once clear winners are removed, the maximum over the remaining candidates is usually smaller, so the next critical value can fall and further false nulls can be rejected. Under the paper's bootstrap consistency assumptions, this has asymptotic **strong** FWER control, not merely the weak all-null guarantee White established for his original procedure. The procedure therefore controls the post-search false-positive risk while returning named benchmark beaters rather than an unhelpful global rejection.

This is distinct from running many pairwise Diebold-Mariano or conditional Giacomini-White tests and reading unadjusted p-values. Those test a given pair or pairwise method rule. StepM assumes a family of benchmark contrasts and makes the subsequent many-declaration decision valid. It also differs from the later Model Confidence Set: StepM's discoveries are benchmark-relative winners; the MCS is benchmark-free and reports models not distinguishable from the best.

Source: Romano and Wolf 2005, pp. 1242-1249, especially Algorithm 3.1 and Theorem 3.1; canonical DOI [10.1111/j.1468-0262.2005.00615.x](https://doi.org/10.1111/j.1468-0262.2005.00615.x); working-paper provenance and sha256 `ef3ed6fa9c91` as recorded in the source index.
