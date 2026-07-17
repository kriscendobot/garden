---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T05:37:08Z
---
Ingested Hansen, Lunde & Nason 2011, "The Model Confidence Set" (Econometrica 79(2):453-497, DOI 10.3982/ECTA5771) into the cross-cutting library — the 14th financial-forecasting-corpus paper, continuing the forecast-comparison lineage after West 1996.

Source acquisition: readable full text is the authors' freely-available working-paper version, CREATES Research Paper 2010-76 (rp10_76.pdf), fetched direct via fetch-source.sh; sha256 c4abc4759af8...; pypdf text extracted cleanly (128 KB). The paywalled Econometrica article is the canonical citation (recorded as source_url); the working-paper provenance is stated honestly in the source frontmatter notes.

Sections written (5): sources/papers--hansen-lunde-nason-model-confidence-set-2011.md + 5 section files:
- overview-and-the-model-confidence-set-idea (financial-forecasting, forecast-evaluation)
- algorithm-equivalence-test-and-mcs-p-values (forecast-evaluation)
- bootstrap-tests-and-loss-differential-t-statistics (forecast-evaluation)
- relation-to-reality-check-spa-and-parameter-uncertainty (forecast-evaluation)
- empirical-applications-and-forecasting-boundary (financial-forecasting, forecast-evaluation)

Cross-links added (section-table rows via insert-sections-table-row.sh, landed via land-journal-edit.sh):
- topics/financial-forecasting.md: 2 rows (overview, empirical-boundary)
- topics/forecast-evaluation.md: 5 rows (all sections)
- concepts/data-snooping-bias.md: 3 rows (overview, algorithm/FWE control, relation-to-SPA) — the MCS is the set-valued successor in the DM -> Reality Check/SPA -> MCS correction lineage the concept already narrates
- concepts/diebold-mariano-test.md: 2 rows (bootstrap t-statistic IS the DM/West statistic; MCS as set-valued successor to pairwise DM)

Indexes: sources/README.md — added the MCS row AND repaired a pre-existing gap by adding the missing West 1996 row (the prior cycle landed the West source file but never added its README row); keywords.md — added 4 aliases (Hansen Lunde Nason, MCS p-value, equivalence test, elimination rule -> data-snooping-bias). topics/README.md Sections-count column and sections/README.md flat index regenerated as the final landing step.

Continuation framing preserved: MCS explained as the continuation from pairwise DM (two given forecasts) and best-of-N Reality Check/SPA (best-vs-benchmark) to the model *set* (models indistinguishable from the best, no benchmark required); the conditional-volatility/risk-forecast vs directional-return distinction is carried in every section (the MCS is loss-agnostic, so meaning is fixed by the loss it runs on).

Integrity gate (step 8): PASS.
- library-link-check.sh --source-slug papers--hansen-lunde-nason-model-confidence-set-2011 -> OK (all 5 section-table targets resolve to committed files).
- library-link-check.sh --source-slug papers--west-asymptotic-inference-predictive-ability-1996 -> OK.
- regenerate-topics-counts.sh --check -> current after the --land step.
Sections index and topics counts regenerated (regenerate-sections-index.sh, regenerate-topics-counts.sh) and landed current.

Follow-on posted: scholar-ingest-financial-forecasting-corpus-16 — ingest Hansen 2005, "A Test for Superior Predictive Ability" (JBES 23(4):365-380), the missing middle link (both Reality Check and MCS endpoints are now sourced, but SPA itself is only referenced), to be connected to the already-ingested Hansen & Lunde 2005 330-model GARCH horse race that applies SPA. Later candidate nodes named in the job body (Giacomini-White 2006, Romano-Wolf 2005, Deflated Sharpe Ratio, Clark-West 2007).

Self-improvement: while adding the MCS row to sources/README.md I found the West 1996 source row was never added by the prior cycle even though the source file and its sections were landed — the per-source integrity gate (library-link-check --changed) only walks a cycle's *touched* sources, so a missing README row for a source whose files otherwise resolve is invisible to it. A cheap standing backstop would be a "every sources/<slug>.md has a matching sources/README.md row" reconciler (the mirror of the sections-index DANGLING check), which would have caught this at the corpus-14 cycle rather than a cycle later. Routing this as a lesson would exceed my role bounds, so noting it here for the mentor/liaison channel.
