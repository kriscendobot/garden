All content is verified at the `origin/journal2` tip: 5 sections + source index, the `sources/README` row, keyword lines, and the regenerated flat `sections/README` (6 references) and `topics/README` counts. The job is genuinely complete.

---

## Completion report — `scholar-ingest-financial-forecasting-corpus-16`

**Ingested:** Peter R. Hansen 2005, "A Test for Superior Predictive Ability" (JBES 23(4):365–380, DOI `10.1198/073500105000000063`) — the power-improving successor to White's Reality Check and the previously-missing middle link of the corpus's forecast-comparison lineage. Both endpoints (White 2000 Reality Check, Hansen–Lunde–Nason 2011 MCS) were already sourced; the SPA test that improves on the Reality Check was only referenced.

**Source acquisition:** `fetch-source.sh` direct from the author's postprint in the UNC Carolina Digital Repository (record DOI `10.17615/wehz-da64`, download `zp38wf793`), 16pp, sha256 `e6f4585659d4…`. Provenance recorded honestly: the readable PDF is a repository postprint carrying the published JBES running heads/pagination; the JBES DOI is the canonical citation, the sha256 anchors the deposited bytes — parallel to the MCS ingest's CREATES-working-paper honesty.

**New source `papers--hansen-test-superior-predictive-ability-2005` (5 sections):**
- `overview-and-the-spa-test-idea` — SPA vs EPA (composite vs simple null), the `H0: µ≤0` framework identical to White, the two-modification recipe, the Bonferroni-padding intuition, loss-agnosticism / risk-vs-directional.
- `studentized-statistic-and-sample-dependent-null` — studentization (15%→53% power example), Theorem 1/Corollary 1 (only binding constraints matter; RC manipulable by padding poor models), the `µ̂ᶜ` law-of-iterated-logarithm `√(2 log log n)` threshold, consistent p-value with l/c/u bounds.
- `bootstrap-implementation-and-consistent-p-value` — Politis–Romano stationary bootstrap, recentering to impose the null, long-run-variance `ω̂²_k`, RC = `ω̂²=1` special case, validity under inconsistent `ω̂²`.
- `monte-carlo-power-and-inflation-application` — ~84%-data-thrown-away efficiency; US-inflation full universe RC p `.106→.963` vs SPA `.048→.100` (opposite conclusions); Phillips-curve models best; the log-every-configuration honesty.
- `relation-to-reality-check-and-the-correction-lineage` — placement DM/West → RC → SPA → MCS; Romano–Wolf and MCS relations; the West/recursive-estimation boundary; explicit connection to Hansen & Lunde 2005 (the 330-model GARCH horse race that *applies* SPA).

**Cross-links landed:** `topics/financial-forecasting` (3 rows), `topics/forecast-evaluation` (5 rows), `concepts/data-snooping-bias` (4 rows), `concepts/diebold-mariano-test` (2 rows), `keywords.md` (7 new keyword lines → `data-snooping-bias`, no duplicate-key conflicts), `sources/README.md` (new paper row, fifteenth corpus paper). No new topic/concept page created — SPA routes into the consolidated `data-snooping-bias` concept exactly as White's Reality Check does, keeping the lineage in one lookup target. The conditional-volatility/risk versus directional-return distinction is preserved in every section.

**Integrity gate (step 8):** `library-link-check.sh --source-slug …` = OK (all 5 section-table targets resolve to committed files); `regenerate-topics-counts.sh --check` reported stale-only (expected new rows), no missing topic page.

**Step-9 regenerators landed:** `regenerate-sections-index.sh` (`sections/README.md`) and `regenerate-topics-counts.sh` (`topics/README.md`) both landed and now self-report current/idempotent.

**Follow-on posted:** `scholar-ingest-financial-forecasting-corpus-17` — recommends Giacomini & White 2006 (Tests of Conditional Predictive Ability) as the strongest next node, with Romano–Wolf 2005 stepwise, Clark–West 2007 nested-model MSPE-adjusted, and Bailey–López de Prado 2014 Deflated Sharpe as ranked alternates.

**Result entry:** `entries/2026/07/17/055000Z-result-gardener-8de63a.md`.

Self-improvement: The DM/West → Reality Check → SPA → MCS lineage is now sourced end to end. Recording provenance for a repository *postprint* of a published paper (vs a working paper) is now a second worked precedent alongside the MCS's CREATES version — worth a one-line note in `conventions.md`'s paper-schema section if a third such case appears, so future scholars treat "postprint deposited in an institutional repository, published DOI canonical, sha256 anchors the deposited bytes" as an accepted shape.
