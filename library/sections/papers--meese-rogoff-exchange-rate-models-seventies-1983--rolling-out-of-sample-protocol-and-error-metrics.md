---
title: Rolling out-of-sample protocol and error metrics
source: "Empirical Exchange Rate Models of the Seventies: Do They Fit Out of Sample?"
source_kind: paper
source_authors: [Richard A. Meese, Kenneth Rogoff]
source_year: 1983
source_venue: "Journal of International Economics 14(1-2):3-24"
source_url: https://doi.org/10.1016/0022-1996(83)90017-X
source_mirror_url: https://www.ssc.wisc.edu/~bhansen/390/MeeseRogoff.pdf
source_pdf_sha256: a77da74666890db4476b10f11a7e96334ad8009b38ae0fe41304a280102a74f2
source_fetched_via: direct
ingested: 2026-07-17
ingested_by: scholar
topics: [forecast-evaluation, financial-forecasting]
status: current
---

Abstract: The paper implements a recognizably modern rolling-origin forecast evaluation: estimate only on information available at each origin, generate one-, three-, six-, and twelve-month forecasts, advance the sample one month, re-estimate every model, and repeat. It deliberately gives structural models a favorable, unrealistic input by using their future explanatory variables as realized, then asks whether they can still beat the random walk.

Monthly data run from March 1973 through June 1981. The initial estimation window ends at November 1976; each new month is added before every parameter and seasonal-adjustment re-estimation. The authors also shift the start to November 1978 and truncate at November 1980 to test whether a particular policy regime or sample endpoint explains the ranking. This is an expanding-window form of [[walk-forward-validation]], though the study predates that label.

Accuracy is reported as mean error, mean absolute error, and root mean square error of log exchange rates. Log targets make errors approximately percentage-like and comparable across currencies while avoiding the reciprocal-rate Jensen-inequality problem. RMSE is primary, MAE checks sensitivity to fat tails and outliers, and mean error detects systematic over- or under-prediction. The paper notes that formal comparisons are difficult with overlapping multi-horizon errors and restrictive independence assumptions. Its robust conclusion is correspondingly modest but useful: no alternative is shown to forecast significantly better than the random-walk benchmark.

Source: Meese and Rogoff (1983), Section 3; University of Wisconsin faculty-hosted PDF, sha256 `a77da746`.
