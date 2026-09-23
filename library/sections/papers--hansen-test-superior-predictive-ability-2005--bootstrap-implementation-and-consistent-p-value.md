---
title: Bootstrap implementation of the SPA test
source: "A Test for Superior Predictive Ability"
source_kind: paper
source_authors: [Peter R. Hansen]
source_year: 2005
source_venue: "Journal of Business & Economic Statistics 23(4):365-380"
source_url: https://doi.org/10.1198/073500105000000063
source_pdf_sha256: e6f4585659d4453432c944e9b4dce340d68a7aa2f75076a8733c814c6c633a1d
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: How SPA is actually computed. Because the studentized statistic is non-pivotal — its asymptotic distribution depends on (elements of) the covariance `Ω`, which is a nuisance parameter, and `m` is typically too large to estimate all of `Ω` reliably — Hansen follows White in using a **bootstrap that implicitly handles the nuisance parameter**, not for higher-order refinement. The engine is the **stationary bootstrap of Politis & Romano (1994)**: resample the relative-performance vectors `d_t` in random-length (geometrically distributed, parameter `q ∈ (0,1]`) blocks to build `B` pseudo-time-series `{d*_{b,t}}`, whose sample averages `d̄*_b` are (asymptotically) independent draws from the sampling distribution of `d̄` (Lemma 1, following Gonçalves & de Jong 2003). The block bootstrap of Künsch (1989) is an easy substitute, but its optimal block length is hard to pin down when `m` is large relative to `n`, which is common in SPA problems. `B` should be raised until the results are stable to increments.

**Imposing the null by recentering.** The bootstrap draws estimate the distribution of `d̄`, but the test needs its distribution *under the null*. Hansen recenters each bootstrap variable about one of the three estimators via `Z*_{k,b,t} = d*_{k,b,t} − g_i(d̄_k)`, where `g_l(x) = max(0, x)`, `g_c(x) = x · 1{ x ≥ −√((ω̂²_k/n) · 2 log log n) }`, and `g_u(x) = x`. The conditional expectations of the recentered variables are exactly `µ̂^l`, `µ̂^c`, `µ̂^u` — so this operationalizes the three null distributions of §2.4 as three sets of bootstrap resamples (Corollary 3). The three bootstrap p-values are then
`p̂^{SPA} = (1/B) Σ_b 1{ T^{SPA*}_{b,n} > T^{SPA}_n }`,
with `T^{SPA*}_{b,n} = max{ 0, max_k n^{1/2} Z̄*_{k,b} / ω̂_k }`, rejecting for small p-values. One p-value per estimator; `p̂^c` (the consistent one from §2.4) is the recommended report, with `p̂^l`/`p̂^u` as the bracketing diagnostic.

**The variance estimator `ω̂²_k`.** Rather than a noisy bootstrap variance (which needs a very large `B`), Hansen recommends the **bootstrap population value** computed directly from the data:
`ω̂²_k = γ̂_{0,k} + 2 Σ_{i=1}^{n−1} κ(n,i) γ̂_{i,k}`,
where `γ̂_{i,k}` are the empirical autocovariances of `d_{k,·}` and the kernel weights `κ(n,i) = ((n−i)/n)(1−q)^i + (i/n)(1−q)^{n−i}` are those implied by the stationary bootstrap (Politis & Romano 1994). This is a serial-correlation-robust (long-run) variance, matching the multi-step-forecast serial dependence the [Diebold-Mariano](../concepts/diebold-mariano-test.md) machinery also has to handle.

**A robustness property.** The *same* `ω̂²_k` is used for both `T^{SPA}_n` and its bootstrap counterpart, and this makes the SPA test **valid even if `ω̂²_k` is inconsistent** for `ω²_k` — a nice consequence: setting `ω̂²_k = 1` for all `k` (generally inconsistent) recovers exactly the Reality Check, so the RC is a special, un-studentized case of the SPA bootstrap. Consistency of `ω̂²_k` is still *desirable* (so the individual `t`-statistics `n^{1/2} d̄_k / ω̂_k` share a common scale, which is where the power gain of §2.2 comes from), but not *required* for the test's validity.

Source: Hansen 2005, §3 (Bootstrap Implementation of the Test for Superior Predictive Ability — the stationary bootstrap, Lemma 1, the `ω̂²_k` population estimator, recentering by `g_l/g_c/g_u`, Corollary 3, and the three bootstrap p-values), canonical DOI [10.1198/073500105000000063](https://doi.org/10.1198/073500105000000063); readable PDF is the author's postprint in the UNC Carolina Digital Repository ([`zp38wf793`](https://cdr.lib.unc.edu/downloads/zp38wf793), record DOI [10.17615/wehz-da64](https://doi.org/10.17615/wehz-da64)), sha256 `e6f4585659d4`.
