---
title: Exact finite-sample sign and signed-rank tests
source: "Comparing Predictive Accuracy"
source_kind: paper
source_authors: [Francis X. Diebold, Roberto S. Mariano]
source_year: 1995
source_venue: "Journal of Business & Economic Statistics 13(3):253-263"
source_url: https://doi.org/10.1080/07350015.1995.10524599
source_pdf_sha256: 93aadf7294c50788584384b4806f6bf7d58b959da550405ea6db431d7330bcd5
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: When only a few forecast-error observations are available, Diebold and Mariano offer two distribution-free finite-sample tests of predictive accuracy that complement the asymptotic `S1`: a **sign test** on the loss differential (null: zero-median loss differential) and **Wilcoxon's signed-rank test** (null: zero-mean, symmetric loss differential). Both need no distributional assumption on the loss differential, and both extend to serially correlated data through a Bonferroni bound. They are the small-sample tools of the DM family.

**Sign test (`S2`).** The null is a zero-median loss differential, `med(g(e_1t) − g(e_2t)) = 0`, i.e. `P(g(e_1t) > g(e_2t)) = P(g(e_1t) < g(e_2t))`. This is *not* in general the same as a zero difference between the median losses, so the null differs slightly in spirit from `S1`'s; but if the loss differential is symmetrically distributed, the zero-median null coincides with the zero-mean null because mean and median then agree (symmetry holds, for example, when `g(e_1t)` and `g(e_2t)` share a distribution up to a location shift, and the authors report roughly symmetric loss differentials to be common). Assuming an iid loss differential, the number of positive loss-differential observations is `Binomial(T, ½)` under the null, so the statistic is simply `S2 = Σ_t 1_+(d_t)` with `1_+(d_t) = 1` if `d_t > 0` and `0` otherwise. Significance comes from the cumulative binomial table, and the studentized large-sample form is `S2a = (S2 − 0.5T) / sqrt(0.25T) → N(0, 1)`.

**Wilcoxon's signed-rank test (`S3`).** A related distribution-free procedure that *requires* symmetry of the loss differential but can be more powerful than the sign test in that case. Again assuming an iid loss differential, the statistic is `S3 = Σ_t 1_+(d_t) rank(|d_t|)` — the sum of the ranks of the absolute values of the positive observations. Its exact finite-sample critical values are invariant to the distribution of the loss differential (it need only be zero-mean and symmetric) and are tabulated; its studentized version is asymptotically standard normal.

**Serial correlation via Bonferroni bounds.** The exact tests `S2`, `S3` and their asymptotic counterparts assume iid data, because serial correlation makes the rearrangements underlying a randomization test unequally likely. When forecast errors (and hence the loss differential) are `(k − 1)`-dependent, the sample can be split into `k` interleaved subsequences — `{d_1, d_{1+k}, d_{1+2k}, …}`, `{d_2, d_{2+k}, …}`, …, `{d_k, d_{2k}, …}` — each free of serial correlation. Running `k` tests, each of size `α/k`, and rejecting if *any* rejects, yields a test of overall size bounded by `α` (Bonferroni, as in Campbell and Ghysels 1995). The paper also notes that in multistep comparisons forecast-error serial correlation can be a "common feature" (Engle and Kozicki 1993) induced by the horizon exceeding the sampling interval, so it may be absent from the loss differential even when present in the errors — checkable empirically.

For this corpus, the sign test is the most robust member: it survives non-Gaussian, fat-tailed error distributions where the classical quadratic-loss tests collapse (the next section's Monte Carlo evidence), which matters directly for financial returns and squared-return variance proxies whose tails are heavy.

Source: Diebold and Mariano 1995, section 1.2 (1.2.1 sign test, 1.2.2 signed-rank test) and section 1.3, canonical DOI [10.1080/07350015.1995.10524599](https://doi.org/10.1080/07350015.1995.10524599); readable PDF [author copy (F. Diebold, U. Penn)](https://www.sas.upenn.edu/~fdiebold/papers/paper68/pa.dm.pdf), sha256 `93aadf7294c5`.
