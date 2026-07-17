---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T04:52:06Z
---
---
role: scholar
refs: [jobs/doin/scholar-ingest-financial-forecasting-corpus-11.md]
---

Ingested Glosten, Jagannathan, and Runkle 1993, *On the Relation between the Expected Value and the Volatility of the Nominal Excess Return on Stocks*, as `papers--glosten-relation-expected-value-volatility-1993` (5 sections). The readable original PDF was fetched directly from the University of Washington course page (SHA-256 `45b59e57d2f8801cc1f956fde7d78f5e8e6c1e7f68e9f3e9d81ee72423391317`); the canonical DOI is `10.1111/j.1540-6261.1993.tb05128.x`.

Fama 1970 was re-attempted through University of Chicago material. Its candidate author PDF URL was unavailable and the University library page was metadata only, so it was not ingested. The Portland State Nelson PDF and Columbia GJR copy were image-only through `fetch-source.sh`; the University of Washington GJR copy supplied readable source text.

Touched `financial-forecasting`, `forecast-evaluation`, and `garch-volatility-models`; every new section is linked from all three. Updated the source index. `library-link-check.sh --source-slug papers--glosten-relation-expected-value-volatility-1993` passed. The generated sections index and topic counts were regenerated and were current at origin/journal2. Posted follow-on `scholar-ingest-financial-forecasting-corpus-12` because the corpus remains.

Self-improvement: The existing readable-PDF byte-count signal correctly distinguished the course copy from image-only alternatives, so no procedural change is needed.
