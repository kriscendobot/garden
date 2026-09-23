---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T05:50:06Z
---
scholar cycle — ingest `scholar-ingest-financial-forecasting-corpus-16`

Ingested Peter R. Hansen 2005, "A Test for Superior Predictive Ability" (JBES 23(4):365-380, DOI 10.1198/073500105000000063) — the power-improving successor to White's Reality Check and the previously-missing middle link of the corpus's forecast-comparison lineage (both endpoints, White 2000 RC and Hansen-Lunde-Nason 2011 MCS, were already sourced).

Source acquisition: fetch-source.sh direct from the author's postprint in the UNC Carolina Digital Repository (record DOI 10.17615/wehz-da64, download `zp38wf793`), 16pp, sha256 `e6f4585659d4453432c944e9b4dce340d68a7aa2f75076a8733c814c6c633a1d`. Provenance recorded honestly: the readable PDF is a repository postprint carrying the published JBES running heads/pagination; the JBES DOI is the canonical citation, the sha256 anchors the bytes read (parallels the MCS ingest's CREATES-working-paper honesty).

New source: `papers--hansen-test-superior-predictive-ability-2005` (5 sections):
- overview-and-the-spa-test-idea (financial-forecasting, forecast-evaluation) — SPA vs EPA (composite vs simple null), the H0: mu<=0 framework identical to White, the two-modification recipe, the Bonferroni-padding intuition, object-agnosticism / risk-vs-directional.
- studentized-statistic-and-sample-dependent-null (forecast-evaluation) — T_SPA studentization (15%->53% power example), Theorem 1 / Corollary 1 (only binding constraints matter; RC manipulable by padding), the mu-hat^c law-of-iterated-logarithm sqrt(2 log log n) threshold, Theorem 2 / Corollary 2 consistent p-value with l/c/u bounds.
- bootstrap-implementation-and-consistent-p-value (forecast-evaluation) — Politis-Romano stationary bootstrap, recentering by g_l/g_c/g_u to impose the null, long-run-variance omega-hat_k, RC = omega-hat=1 special case, validity even under inconsistent omega-hat.
- monte-carlo-power-and-inflation-application (financial-forecasting, forecast-evaluation) — ~84%-data-thrown-away relative efficiency; US-inflation large/small/full universes (full: RC p .106->.963 vs SPA .048->.100, opposite conclusions; Phillips-curve models best; the log-every-configuration honesty).
- relation-to-reality-check-and-the-correction-lineage (financial-forecasting, forecast-evaluation) — placement DM/West -> RC -> SPA -> MCS; Romano-Wolf and MCS relations; the West/recursive-estimation boundary (fixed/rolling OK, recursive not); risk-vs-directional preserved; explicit connection to Hansen & Lunde 2005 (the 330-model GARCH horse race that applies SPA).

Cross-links landed:
- topics/financial-forecasting.md — 3 Sections rows (overview, monte-carlo, relation).
- topics/forecast-evaluation.md — all 5 Sections rows.
- concepts/data-snooping-bias.md — 4 rows (overview, studentized, monte-carlo, relation).
- concepts/diebold-mariano-test.md — 2 rows (bootstrap loss-differential t-statistic, relation/lineage).
- keywords.md — added "A Test for Superior Predictive Ability", "Hansen 2005 SPA", "studentized test statistic", "sample-dependent null distribution", "least favorable configuration", "LFC", "test for superior predictive ability" -> data-snooping-bias (no duplicate-key conflicts; existing SPA aliases already routed there).
- sources/README.md — new paper row (fifteenth financial-forecasting-corpus paper).

No new topic or concept page created: SPA routes into the existing consolidated `data-snooping-bias` concept exactly as White's Reality Check does, keeping the lineage in one lookup target.

Integrity gate (step 8): library-link-check.sh --source-slug papers--hansen-test-superior-predictive-ability-2005 = OK (all 5 section-table targets resolve to committed files); regenerate-topics-counts.sh --check reported stale (expected — new rows) with no missing topic page.

Step 9 regenerators landed: regenerate-sections-index.sh (sections/README.md) and regenerate-topics-counts.sh (topics/README.md) both landed and now self-report current/idempotent.

Follow-on posted: `scholar-ingest-financial-forecasting-corpus-17` — recommends Giacomini & White 2006 (Tests of Conditional Predictive Ability) as the strongest next node, with Romano-Wolf 2005 stepwise, Clark-West 2007 nested-model MSPE-adjusted, and Bailey-Lopez de Prado 2014 Deflated Sharpe as ranked alternates.

Self-improvement: The forecast-comparison lineage (DM/West -> RC -> SPA -> MCS) is now sourced end to end. Recording provenance honestly for a repository *postprint* of a published paper (as opposed to a working paper) is now a second worked precedent alongside the MCS's CREATES version — worth a one-line note in conventions.md's paper-schema section if a third such case appears, so future scholars know "postprint deposited in an institutional repository, JBES DOI canonical, sha256 anchors the deposited bytes" is an accepted shape.
