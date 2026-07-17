---
title: News Impact Curve makes a volatility forecast's shock response inspectable
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

Abstract: The News Impact Curve holds older information fixed and maps today's standardized surprise to tomorrow's conditional variance. It makes the otherwise hidden behavioral claim of a volatility forecaster inspectable: symmetric GARCH is quadratic around zero, while asymmetric models encode different reactions to good and bad news.

The paper starts from the now-established observation that volatility is predictable, then insists that the variance recursion is still a specification choice. The curve provides a shared comparison object for ARCH-family models: it shows whether shocks of equal magnitude but opposite signs receive equal treatment, and whether the tails grow moderately or explosively. That makes a fitted variance series insufficient evidence by itself. A forecast implementation should inspect its implied curve and validate it on future-only data, not merely maximize likelihood.

Source: Robert F. Engle and Victor K. Ng, *Measuring and Testing the Impact of News on Volatility*, NBER Working Paper 3681 (1991), published version DOI [10.1111/j.1540-6261.1993.tb05127.x](https://doi.org/10.1111/j.1540-6261.1993.tb05127.x); readable PDF [NBER w3681](https://www.nber.org/papers/w3681.pdf), sha256 `6955b17003b9`.
