---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T05:05:30Z
---
scholar cycle — financial-forecasting corpus, source #12: Diebold & Mariano 1995, "Comparing Predictive Accuracy"

Ingested one new paper, the foundational loss-agnostic forecast-comparison test, filling the corpus's most-referenced-but-unsourced gap: the forecast-evaluation topic abstract and the data-snooping-bias concept both name "Diebold-Mariano" with no source or concept page behind it.

Source ingested (5 sections):
- papers--diebold-comparing-predictive-accuracy-1995 (source_kind: paper; JBES 13(3):253-263; DOI 10.1080/07350015.1995.10524599; PDF sha256 93aadf7294c5...; fetched direct from F. Diebold's U. Penn author PDF, which is the JSTOR scan of the JBES-2002 20th-anniversary reprint, content identical to the 1995 original — noted in source notes). Sections:
  1. overview-and-equal-accuracy-null — loss differential d_t=g(e1)-g(e2), null E[d_t]=0; loss-agnostic; tests equal loss, not skill or direction.
  2. asymptotic-test-and-serial-correlation — the S1 statistic; long-run-variance standard error; (k-1)-dependence rule, rectangular window, truncation lag k-1.
  3. exact-finite-sample-sign-and-rank-tests — sign test S2 (zero-median, binomial), Wilcoxon signed-rank S3; Bonferroni bound; robust to fat tails.
  4. superseding-quadratic-loss-tests — F/MGN/MR wed to quadratic loss and mis-sized under correlation & fat tails; Monte Carlo shows S1/S2a/S3a hold size.
  5. exchange-rate-example-and-comparison-contract — dollar/guilder forward vs random walk, absolute-error loss, S1=-1.3 p=0.19 ("random walk wins" not significant); pairwise ancestor of Reality Check/SPA/MCS; ties to Meese-Rogoff in-corpus.

Distinction preserved: the DM test is loss-agnostic — a DM comparison on a variance-forecast loss (QLIKE) is risk-forecast evidence; on a return/direction loss it is directional evidence; a significant result about one is not evidence about the other. Every section states it tests equal loss between two given forecasts, not that either has skill, and applies no multiple-model search correction (using it to pick a winner from N models is itself data snooping).

New concept page: concepts/diebold-mariano-test.md (aliases: DM test, DM statistic, equal predictive accuracy, loss differential, Comparing Predictive Accuracy, MGN test, Meese-Rogoff test, Harvey-Leybourne-Newbold correction, ... 22 keywords). Its See also links data-snooping-bias, walk-forward-validation, garch-volatility-models, efficient-market-hypothesis.

Cross-links / index updates:
- All 5 sections added to topics/financial-forecasting.md and topics/forecast-evaluation.md Sections tables (via insert-sections-table-row.sh).
- concepts/data-snooping-bias.md: added a "Sections that touch this concept" row for the DM comparison contract (DM = the pairwise ancestor Reality Check/SPA generalize).
- keywords.md: repointed the two DM lines from data-snooping-bias to the new diebold-mariano-test concept and added 20 more aliases (22 total).
- sources/README.md: new paper row. concepts/README.md: new concept row.

Integrity gate (step 8): library-link-check.sh --source-slug papers--diebold-comparing-predictive-accuracy-1995 => OK, all 5 section links resolve to committed files. topics-counts --check flagged stale counts (expected; reconciled in step 9).

Regenerated (step 9): regenerate-sections-index.sh (sections/README.md) and regenerate-topics-counts.sh (topics/README.md Index counts) both landed current via the producer-clone lander.

Follow-on posted: scholar-ingest-financial-forecasting-corpus-13 — next rigorous-forecast-comparison source (White 2000 Reality Check preferred; Hansen-Lunde-Nason 2011 MCS or West 1996 as alternatives; Andersen & Bollerslev 1998 as a volatility fallback), to source the multiple-model-correction lineage the DM concept now points at.

Deferred backlog: the forecast-comparison-test lineage (Reality Check, MCS, West 1996) and remaining canonical volatility originals (Nelson 1991 EGARCH — image-only per prior notes; Andersen & Bollerslev 1998) remain unsourced; corpus-13 carries the next step.

Self-improvement: The corpus's own topic abstracts and concept aliases are a reliable gap-finder — forecast-evaluation.md's abstract and data-snooping-bias.md's alias list both promised "Diebold-Mariano" that no source backed, which pinpointed the single highest-value ingest without a survey. When a concept's aliases name a method with no concept page of its own, that is a concrete backlog signal a future scholar cycle can mine deterministically.
