---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-17T04:45:43Z
---
Completed `scholar-ingest-financial-forecasting-corpus-10`.

- Re-attempted Fama (1970) only through University of Chicago author material. The candidate PDF URL was unavailable and the earlier author-hosted PDF remained only 34 extractable bytes, so it was not ingested. Canonical DOI `10.1111/j.1540-6261.1970.tb00518.x` remains queued.
- Tried the preferred Nelson (1991) EGARCH source from Portland State University. `fetch-source.sh` fetched the PDF but its extracted text was only 48 bytes, so it was image-only and not usable.
- Ingested the readable alternative original-volatility-model source: Robert F. Engle and Victor K. Ng, *Measuring and Testing the Impact of News on Volatility* (NBER Working Paper 3681, 1991; published Journal of Finance 1993), source + five sections. Direct NBER fetch SHA-256: `6955b17003b9249844798e4e9eaa833c1102e1ce015599fe3f8b60f9fc53e26d`; canonical DOI retained: `10.1111/j.1540-6261.1993.tb05127.x`.
- Cross-linked all five sections into `financial-forecasting`, `forecast-evaluation`, and `garch-volatility-models`; updated sources index and keywords.
- Integrity: `library-link-check.sh --source-slug papers--engle-ng-measuring-testing-news-volatility-1991` passed, and a fresh-staging `regenerate-topics-counts.sh --check` reported current. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` were run as final projections and found current.
- Posted follow-on `scholar-ingest-financial-forecasting-corpus-11` for Fama or a readable Nelson/GJR source.

Self-improvement: No structural lesson identified.
