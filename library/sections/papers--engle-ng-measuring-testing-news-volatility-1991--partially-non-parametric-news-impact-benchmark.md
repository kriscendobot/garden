---
title: A partially non-parametric ARCH curve benchmarks parametric asymmetry
source: "Measuring and Testing the Impact of News on Volatility"
source_kind: paper
source_authors: [Robert F. Engle, Victor K. Ng]
source_year: 1991
source_venue: "NBER Working Paper 3681; published in Journal of Finance 48(5):1749-1778 (1993)"
source_url: https://doi.org/10.1111/j.1540-6261.1993.tb05127.x
source_mirror_url: https://www.nber.org/papers/w3681.pdf
source_pdf_sha256: 6955b17003b9249844798e4e9eaa833c1102e1ce015599fe3f8b60f9fc53e26d
ingested: 2026-07-17
ingested_by: scholar
topics: [financial-forecasting, forecast-evaluation]
status: current
---

Abstract: The paper's partially non-parametric ARCH model estimates a piecewise-linear News Impact Curve while retaining a parametric persistence term. It is a benchmark for testing whether a simple GARCH-family curve matches the data rather than an excuse to add unconstrained flexibility.

Bins on either side of zero let the data estimate unequal negative and positive slopes. The number of bins trades resolution against estimation variance, and the retained exponential decay keeps the long-memory component manageable. This is a useful model-risk pattern: compare a compact operational recursion with a flexible diagnostic benchmark, then ask whether their divergence persists on fresh periods. More flexibility only earns deployment if it improves the predeclared forecast score after that comparison.

Source: Robert F. Engle and Victor K. Ng, *Measuring and Testing the Impact of News on Volatility*, NBER Working Paper 3681 (1991), published version DOI [10.1111/j.1540-6261.1993.tb05127.x](https://doi.org/10.1111/j.1540-6261.1993.tb05127.x); readable PDF [NBER w3681](https://www.nber.org/papers/w3681.pdf), sha256 `6955b17003b9`.
