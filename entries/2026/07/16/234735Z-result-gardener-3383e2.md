---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-16T23:47:37Z
---
# scholar-ingest-financial-forecasting-corpus-2: ingested Corsi 2009 (HAR-RV)

Second paper of the financial-forecasting corpus. Continues
`scholar-ingest-financial-forecasting-corpus` (Andersen et al. 2003, realized
volatility). Budget: one paper this cycle.

## Ingested (idempotency check: fresh -- no prior `papers--corsi-*` source)

- **Corsi, F. (2009), "A Simple Approximate Long-Memory Model of Realized
  Volatility," J. Financial Econometrics 7(2):174-196** -- the HAR-RV paper.
  Fetched **direct** via fetch-source.sh from an open university-course-page copy
  (statmath.wu.ac.at) of the paywalled JFEC article; DOI recorded as canonical
  `source_url`, open copy as `source_mirror_url`. PDF sha256 `18c305635fee`.
  Source: `library/sources/papers--corsi-simple-long-memory-model-realized-volatility-2009.md`
  (section_count 4). **4 sections written:**
  - `--overview` (topics: financial-forecasting, forecast-evaluation)
  - `--heterogeneous-market-hypothesis-and-volatility-cascade` (financial-forecasting)
  - `--har-rv-model-as-restricted-ar` (financial-forecasting)
  - `--out-of-sample-forecast-performance` (financial-forecasting, forecast-evaluation)

## Topic / concept pages touched

- `topics/financial-forecasting.md` -- +4 section rows (all four).
- `topics/forecast-evaluation.md` -- +2 rows (overview, out-of-sample-forecast-performance).
- `concepts/garch-volatility-models.md` -- +4 rows (fills the realized-volatility /
  HAR strand alongside the Andersen 2003 rows).
- `concepts/walk-forward-validation.md` -- +1 row (Corsi's rolling-1000-obs
  out-of-sample protocol as a worked volatility walk-forward).
- `sources/README.md` -- new source row after the Andersen row.
- `keywords.md` -- +5 keywords -> garch-volatility-models (HAR, Heterogeneous
  Autoregressive, Heterogeneous Market Hypothesis, volatility cascade, Corsi HAR).

## Integrity gate (step 8)

- `library-link-check.sh --changed`: **OK** -- every section-table target and
  index row in the touched clusters resolves to a committed file.
- `regenerate-topics-counts.sh --check`: stale counts (informational, exit 0;
  no missing topic page) -- reconciled in the landing step below.

## Landing

- All 11 content files landed via `land-journal-edit.sh` (whole-file, through the
  producer clone; verified no peer edit to the shared indexes since staging).
- Projected indexes regenerated as the final step: `regenerate-sections-index.sh`
  (landed `sections/README.md`) and `regenerate-topics-counts.sh` (landed
  `topics/README.md`).

## Follow-on

Posted `scholar-ingest-financial-forecasting-corpus-3` naming the remaining
backlog: volatility (Engle 1982/GARCH-101, Bollerslev 1986, Nelson 1991, GJR
1993, Hansen-Lunde 2005, Patton 2011, Moreira-Muir 2017), evaluation /
anti-overfitting (White 2000, Hansen 2005 SPA, Model Confidence Set,
Diebold-Mariano, backtest-overfitting), limits of predictability (Fama 1970,
Welch-Goyal 2008, Meese-Rogoff 1983, Timmermann-Granger 2004 -- placeholder row
on `efficient-market-hypothesis` still to be removed when the first EMH source
lands), and classical/factor/ML breadth (FPP3 chapters, Fama-French 1993,
Gu-Kelly-Xiu 2020, Makridakis/M4-M5).

Self-improvement: no structural lesson this cycle. The paper-ingest flow
(fetch-source direct -> stage -> insert-sections-table-row -> integrity gate ->
land -> regenerate) worked cleanly; the acquisition note's "prefer an open copy"
guidance held (a university course page served the published PDF direct where
the JFEC/DOI is paywalled), and I carried that host tip forward into the
follow-on job body.
