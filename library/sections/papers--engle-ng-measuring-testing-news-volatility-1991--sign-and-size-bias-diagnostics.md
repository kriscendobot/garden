---
title: Sign and size-bias tests diagnose a volatility recursion's missed news response
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

Abstract: The sign-bias, negative-size-bias, positive-size-bias, and joint tests ask whether a fitted model leaves predictable structure in squared standardized residuals. A significant result is an actionable specification failure: the forecasted variance has missed how a prior shock's sign or magnitude affects the next period.

The tests regress squared standardized residuals on functions of past innovations. Their conservative LM interpretation makes them diagnostic complements to likelihood rather than a license to mine variants until one passes. They can also summarize raw return data before a model is imposed. In a production volatility pipeline, retain these residual diagnostics beside a walk-forward QLIKE comparison: likelihood reports fit, while the diagnostics state which news-response features remain unexplained.

Source: Robert F. Engle and Victor K. Ng, *Measuring and Testing the Impact of News on Volatility*, NBER Working Paper 3681 (1991), published version DOI [10.1111/j.1540-6261.1993.tb05127.x](https://doi.org/10.1111/j.1540-6261.1993.tb05127.x); readable PDF [NBER w3681](https://www.nber.org/papers/w3681.pdf), sha256 `6955b17003b9`.
