The follow-on (corpus-14) was already claimed by a peer. All work is complete. Here is my report.

## Completion report — `scholar-ingest-financial-forecasting-corpus-13`

**Source ingested:** White 2000, *"A Reality Check for Data Snooping"* (Econometrica 68(5):1097-1126) — the twelfth financial-forecasting-corpus paper and the **first multiple-model data-snooping correction**, exactly the search-correction the Diebold–Mariano test does *not* make and the direct next node the DM concept pointed to. Fetched **direct** (Wisconsin Econ 718 course copy of the Econometrica original), PDF sha256 `675eb3226dee`, canonical DOI `10.1111/1468-0262.00152`.

**5 sections written** (`library/sections/papers--white-reality-check-data-snooping-2000--*`):
1. `overview-and-the-data-snooping-null` — the hazard and the search-aware null (best searched model vs benchmark; simultaneous error rate).
2. `framework-and-the-max-statistic` — builds on Diebold–Mariano 1995 + West 1996; the max statistic `V̄_l = max_k √n f̄_k` at the least-favorable configuration.
3. `monte-carlo-and-bootstrap-reality-checks` — the two feasible p-value routes; the preferred stationary-bootstrap Reality Check needs no coefficient recomputation.
4. `sp500-illustration-and-the-naive-p-value` — 3,654 technical models vs a constant-only EMH benchmark; naive directional p=.0036 → search-corrected p=.2040; the gap *is* the data-mining bias.
5. `placement-and-the-correction-lineage` — the pairwise(DM)→best-of-N(Reality Check)→model-set(SPA/MCS) lineage.

**Cross-links:** both topic pages (`forecast-evaluation`, `financial-forecasting`, 5 rows each); concepts `data-snooping-bias` (4 rows) and `diebold-mariano-test` (2 rows); `sources/README.md` row; `keywords.md` aliases (bootstrap/Monte Carlo Reality Check, naive p-value, data mining → `data-snooping-bias`).

**Risk-vs-directional distinction preserved:** the placement section makes explicit that a Reality Check on a variance loss (QLIKE) speaks to risk-forecast quality while one on a return/direction loss speaks to directional quality — illustrated by White's own MSE and directional experiments, neither of which is a variance-forecast comparison.

**Integrity gate (step 8):** `library-link-check.sh --source-slug …white-reality-check…` → OK (all 6 links resolve to committed files); topics-count check current after regeneration.

**Projected indexes (step 9):** `sections/README.md` regenerated + landed; `topics/README.md` Sections-count column reconciled current.

**Follow-on:** posted `scholar-ingest-financial-forecasting-corpus-14` (prefers West 1996 → Hansen, Lunde & Nason 2011 MCS → Andersen & Bollerslev 1998) — already claimed by a peer (in `doin/`).

**Concurrency note:** corpus-12 (the Diebold seed) was still in `doin/` when I started; I based all shared-index edits on the post-corpus-12 tip and used the sync-to-tip lander throughout, so no rows were dropped.

Self-improvement: The `library-link-check.sh --changed` scope silently passes as an empty check when the staging clone has been hard-reset to a tip that already contains the just-landed files (the land-then-verify ordering the scholar procedure uses). The producer-side gate is only meaningful with `--source-slug`/`--all` in that ordering; the role brief could note that `--changed` is for the author-before-landing ordering and `--source-slug` for the land-then-verify ordering, so a future scholar does not read the empty `--changed` verdict as a passed gate.
