All landed on `origin/journal2` and the integrity gate is green. Report follows.

---

**Job: scholar-ingest-financial-forecasting-corpus-15 — complete**

Ingested **Hansen, Lunde & Nason 2011, "The Model Confidence Set"** (Econometrica 79(2):453-497, DOI 10.3982/ECTA5771) — the 14th financial-forecasting-corpus paper, continuing the forecast-comparison lineage after West 1996.

**Source acquisition.** Fetched a readable full-text PDF via `fetch-source.sh` (direct): the authors' freely-available working-paper version, CREATES Research Paper 2010-76 (`rp10_76.pdf`), sha256 `c4abc4759af8…`; pypdf text extracted cleanly. The paywalled Econometrica article is the canonical `source_url`; the working-paper provenance is stated honestly in the source frontmatter notes.

**Sections written (5)** + source page:
- overview-and-the-model-confidence-set-idea
- algorithm-equivalence-test-and-mcs-p-values
- bootstrap-tests-and-loss-differential-t-statistics
- relation-to-reality-check-spa-and-parameter-uncertainty
- empirical-applications-and-forecasting-boundary

**Continuation framing.** MCS explained as the step from pairwise DM (two given forecasts) and best-of-N Reality Check/SPA (best-vs-benchmark) to the model *set* — the models statistically indistinguishable from the best, no benchmark required — with the sequential equivalence-test/elimination-rule algorithm (FWE bounded at the test level), the MCS p-value, the DM/West loss-differential t-statistic aggregated into `T_R`/`T_max` with a block bootstrap, and the SPA-comparison (§4.1) and West parameter-uncertainty caveat (§4.3). The conditional-volatility/risk-forecast versus directional-return distinction is preserved in every section (the MCS is loss-agnostic, so meaning is fixed by the loss it runs on).

**Cross-links added** (section-table rows via `insert-sections-table-row.sh`, landed via `land-journal-edit.sh`): `topics/financial-forecasting` (2), `topics/forecast-evaluation` (5), `concepts/data-snooping-bias` (3), `concepts/diebold-mariano-test` (2).

**Indexes.** `sources/README.md` — added the MCS row **and repaired a pre-existing gap** by adding the missing West 1996 row (the prior cycle landed the West source/sections but never added its README row). `keywords.md` — 4 aliases → data-snooping-bias. `topics/README.md` counts and `sections/README.md` flat index regenerated as the final landing step.

**Integrity gate (step 8): PASS** — `library-link-check.sh` OK on both the MCS and West source clusters; `regenerate-topics-counts.sh --check` current after `--land`.

**Follow-on posted:** `scholar-ingest-financial-forecasting-corpus-16` — ingest **Hansen 2005, "A Test for Superior Predictive Ability"** (JBES 23(4):365-380), the missing middle link (both the Reality Check and MCS endpoints are now sourced, but SPA itself is only referenced), to be connected to the already-ingested Hansen & Lunde 2005 330-model GARCH horse race that applies it. Later candidate nodes named in the body (Giacomini-White 2006, Romano-Wolf 2005, Deflated Sharpe Ratio, Clark-West 2007).

Self-improvement: the West-row omission was invisible to the per-cycle integrity gate because `library-link-check --changed` only walks a cycle's *touched* sources — a source whose files all resolve but whose `sources/README.md` row was never added slips through. A cheap standing "every `sources/<slug>.md` has a matching README row" reconciler (the mirror of the sections-index DANGLING check) would catch it at the creating cycle. Routing that as a structural lesson exceeds my role bounds, so it is noted in the result entry for the mentor/liaison channel.
