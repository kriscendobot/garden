---
title: Relation to Reality Check and SPA, and the parameter-uncertainty caveat
source: "The Model Confidence Set"
source_kind: paper
source_authors: [Peter R. Hansen, Asger Lunde, James M. Nason]
source_year: 2011
source_venue: "Econometrica 79(2):453-497"
source_url: https://doi.org/10.3982/ECTA5771
source_pdf_sha256: c4abc4759af8a10ab68dbca077bafb51db3ad2b7142b280f5151eadddabfed00
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation]
status: current
---

Abstract: This is where the MCS is placed in the data-snooping correction lineage that runs pairwise Diebold-Mariano → best-of-N Reality Check/SPA → the model *set*. White's Reality Check and Hansen's SPA test one fixed benchmark against many alternatives and answer "is the benchmark significantly beaten by any of them?"; the MCS needs *no benchmark* and instead returns the set of models not significantly inferior to the best. Where there is a natural benchmark, the MCS still answers the SPA question — just check whether the benchmark is in the set — but it does something SPA cannot: model *selection*, because a rejected SPA test only says "at least one model beats the benchmark" without saying which models are best, and a non-rejection cannot tell the benchmark apart from other good models. You could build an MCS out of a sequence of SPA tests (let every model be the benchmark in turn), but controlling the familywise error then needs a Bonferroni level `α/m` per test, whose power loss the authors call "a major pitfall." The MCS also sidesteps a technical drawback of SPA: the SPA null is a *composite* inequality hypothesis whose limit distribution depends on how many inequalities bind (a nuisance-parameter problem), whereas the MCS tests a sequence of *equality* hypotheses and avoids composite-null testing.

Section 4.1 lays out the comparison directly. The Reality Check (White 2000) and SPA test (Hansen 2005) are "multiple comparisons with control": all objects are compared to a benchmark selected independently of the comparison data. The MCS has three advantages over them. First, no benchmark is required, which matters in applications with no obvious one. Second, it is suited to model selection — a rejected SPA test identifies only that one or more models beat the benchmark, offering "little guidance about which models reside in `M*`." Third, it avoids the composite-hypothesis and binding-inequality nuisance-parameter problem that makes the SPA statistic's Type-I error hard to control. Romano and Wolf (2005) improve the Reality Check by identifying the *entire* set of alternatives that significantly dominate a benchmark, but that set is specific to the chosen benchmark and so, the authors note, has no direct relation to the (benchmark-free) MCS.

Section 4.3 records the parameter-uncertainty caveat that ties the MCS back to West (1996). When forecasts come from estimated parameters — especially *nested* models under certain estimation schemes — the limit distribution of the test statistics need not be Gaussian (West & McCracken 1998; Clark & McCracken 2001), and Assumption 2 can fail. The practical escapes are the same ones West's framework points to: estimate parameters on a rolling window (the Giacomini-White scheme) so the loss differentials stay stationary, or fix the parameters on a pre-sample and compare forecasts conditional on those estimates. For nested comparisons a size-correct modification of `δ_M` is needed; with proper `δ_M` and `e_M` the general MCS theory still holds, but the paper deliberately does not pursue that extension so as not to obscure the core procedure. The lesson for the corpus: estimation-uncertainty (the West correction) and model-search multiplicity (the Reality Check/SPA/MCS correction) are *distinct* problems that must both be handled, and the MCS addresses the second while inheriting the first's caveats.

Because the MCS is a general loss-based comparison, none of this collapses the risk-forecast-versus-directional distinction. An MCS built on a variance loss over conditional-volatility forecasts is a statement about relative risk-forecast quality; an MCS built on a return or directional loss is a statement about mean or directional quality; the benchmark-freedom and search-correction of the procedure do not turn one into the other.

Source: Hansen, Lunde & Nason 2011, §4 (Related Concepts) — §4.1 Relation to Tests for Superior Predictive Ability, §4.2 Related Sequential Testing Procedures, §4.3 Aspects of Parameter Uncertainty and Forecasting, canonical DOI [10.3982/ECTA5771](https://doi.org/10.3982/ECTA5771); readable PDF is the CREATES Research Paper 2010-76 working-paper version [`rp10_76.pdf`](https://repec.econ.au.dk/repec/creates/rp/10/rp10_76.pdf), sha256 `c4abc4759af8`.
