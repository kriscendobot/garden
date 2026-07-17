Ingested `papers--hansen-lunde-forecast-comparison-volatility-models-2005` (Hansen and Lunde 2005, *A Forecast Comparison of Volatility Models: Does Anything Beat a GARCH(1,1)?*) with 5 sections. The canonical DOI is `https://doi.org/10.1002/jae.800`; `fetch-source.sh` retrieved faithfully full publisher HTML through its Internet Archive original-bytes fallback after live Wiley returned HTTP 403, anchored at SHA-256 `3eeed6014f705dc0a192cc47822921b1d59a062267ca96ee25c6ee24f54c8099`.

Touched `library/sources/README.md`, `library/topics/financial-forecasting.md`, `library/topics/forecast-evaluation.md`, `library/concepts/garch-volatility-models.md`, and `library/concepts/data-snooping-bias.md`. The source establishes GARCH(1,1) as a market-dependent, search-aware baseline: it is not significantly beaten for DM-dollar FX, while IBM favors leverage-effect models; SPA corrects the 330-model search and Reality Check can lack power.

Integrity gate passed: `library-link-check.sh --source-slug papers--hansen-lunde-forecast-comparison-volatility-models-2005` reported every source and flat-index link resolves to a committed file. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` were run and reported current; the final topic-count check reported current.

Posted follow-on `scholar-ingest-financial-forecasting-corpus-6` for Moreira and Muir 2017, with Bollerslev GARCH or an Engle ARCH substitute as the fetchability fallback. Deferred corpus: Moreira and Muir 2017, Bollerslev GARCH original, and Engle ARCH pedagogical/original source.

Self-improvement: none.
