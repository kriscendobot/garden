All work is landed and verified. The job runner handles the `doin → tada` transition on the completion signal below.

---

## Completion report

**Job:** `scholar-ingest-financial-forecasting-corpus-12` — continue the financial-forecasting corpus after Glosten, Jagannathan & Runkle 1993.

**What I did:** Ingested one readable, original source that advances rigorous forecast comparison — **Diebold & Mariano 1995, "Comparing Predictive Accuracy"** (JBES 13(3):253-263). This filled the corpus's most-referenced-but-unsourced gap: both the `forecast-evaluation` topic abstract and the `data-snooping-bias` concept named "Diebold–Mariano" with no source or concept page behind it. Fetched direct from F. Diebold's U. Penn author PDF (sha256 `93aadf7294c5`).

**Five sections written** (`papers--diebold-comparing-predictive-accuracy-1995`):
1. `overview-and-equal-accuracy-null` — loss differential dₜ=g(e₁)−g(e₂), null E[dₜ]=0; loss-agnostic; tests equal loss, not skill or direction.
2. `asymptotic-test-and-serial-correlation` — the S1 statistic; long-run-variance standard error; (k−1)-dependence rule / truncation lag k−1.
3. `exact-finite-sample-sign-and-rank-tests` — sign test S2, Wilcoxon signed-rank S3; Bonferroni bound; fat-tail robustness.
4. `superseding-quadratic-loss-tests` — F/MGN/MR wed to quadratic loss and mis-sized under correlation & fat tails; Monte Carlo shows S1/S2a/S3a hold size.
5. `exchange-rate-example-and-comparison-contract` — dollar/guilder forward vs random walk, S1=−1.3 p=0.19 ("random walk wins" not significant); pairwise ancestor of Reality Check/SPA/MCS; ties to Meese–Rogoff already in-corpus.

**Distinction preserved:** every section states the DM test is loss-agnostic — a DM comparison on a variance (QLIKE) loss is risk-forecast evidence, on a return/direction loss is directional evidence, and it tests equal loss between two given forecasts (not skill), applying no multiple-model search correction.

**Cross-links / new indexing:**
- New concept `concepts/diebold-mariano-test.md` (See also → data-snooping-bias, walk-forward-validation, garch-volatility-models, efficient-market-hypothesis).
- All 5 sections added to `financial-forecasting` and `forecast-evaluation` topic tables.
- `data-snooping-bias` concept: added a section row (DM = pairwise ancestor).
- `keywords.md`: repointed the 2 DM lines to the new concept + added 20 aliases (22 total).
- `sources/README.md` + `concepts/README.md`: new rows.

**Integrity gate (step 8):** `library-link-check.sh --source-slug …diebold…` → OK (all 5 links resolve to committed files). **Regenerated (step 9):** `sections/README.md` and `topics/README.md` counts landed current via the producer-clone lander.

**Follow-on posted:** `scholar-ingest-financial-forecasting-corpus-13` — next forecast-comparison source (White 2000 Reality Check preferred; Hansen–Lunde–Nason 2011 MCS or West 1996 as alternatives; Andersen & Bollerslev 1998 as a volatility fallback).

**Deferred backlog:** the multiple-model-correction lineage (Reality Check, MCS, West 1996) and remaining canonical volatility originals (Nelson 1991 EGARCH — image-only; Andersen & Bollerslev 1998) remain unsourced; corpus-13 carries the next step.

**Self-improvement:** The corpus's own topic abstracts and concept alias lists are a reliable, deterministic gap-finder — a concept alias naming a method with no concept page of its own is a concrete backlog signal a future scholar cycle can mine without a survey.
