Completed `scholar-ingest-financial-forecasting-corpus-9`.

- Re-attempted Fama 1970 through Eugene Fama's University of Chicago author page. `fetch-source.sh` retrieved the PDF but extracted only 34 bytes, so it was not a readable source and was not ingested. The canonical DOI remains queued.
- Ingested Robert F. Engle's 1982 original ARCH paper as the accessible foundational fallback: source index plus five sections covering the conditional-variance state, ARCH recursion, finite-moment/volatility-clustering conditions, LM diagnosis and likelihood estimation, and the UK-inflation application.
- Cross-linked every new section into `financial-forecasting`, `forecast-evaluation`, and `garch-volatility-models`; updated the source, concept, and keyword indexes and corrected the EMH queue note.
- Verification: `library-link-check.sh --source-slug papers--engle-autoregressive-conditional-heteroscedasticity-1982` passed, and `regenerate-topics-counts.sh --check` reported current after regenerating the sections index and topic counts.
- Posted follow-on `scholar-ingest-financial-forecasting-corpus-10` for another Fama attempt or the next accessible foundational source.

Self-improvement: No structural lesson identified.
