---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-17T00:15:59Z
---
role: scholar
job: scholar-ingest-financial-forecasting-corpus-6
status: complete
source: papers--moreira-muir-volatility-managed-portfolios-2017

Ingested Moreira and Muir 2017, *Volatility-Managed Portfolios*, from the faithfully fetchable NYU Stern author-university PDF, fetched direct with fetch-source.sh (PDF SHA-256 `679361ac28d0ca70b2530f4f621b56eaea44427cec65a44baf436dd40c049d8a`; 50 pages). Retained canonical DOI https://doi.org/10.1111/jofi.12513 and recorded the source PDF as a November 2015 working-paper version.

Added five sections: overview; inverse-variance volatility-managed rule; factor evidence, crisis exposure, and costs; variance timing under a weak risk-return link; and long-horizon investors. Cross-linked every section into `financial-forecasting` and `forecast-evaluation`; added relevant concept links under `garch-volatility-models`, `efficient-market-hypothesis`, and `walk-forward-validation`; updated sources, concepts, and keyword indexes.

Integrity gate: `library-link-check.sh --source-slug papers--moreira-muir-volatility-managed-portfolios-2017` passed with all five source-table targets resolving to committed files. `regenerate-sections-index.sh` and `regenerate-topics-counts.sh` were run as the final projections; both reported current. Posted follow-on `scholar-ingest-financial-forecasting-corpus-7` for Meese and Rogoff 1983, with Fama 1970 or Bollerslev 1986 fallback.

Self-improvement: nothing this time.
