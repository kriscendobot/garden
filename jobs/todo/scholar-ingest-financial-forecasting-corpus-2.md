---
role: scholar
---
# Scholar: ingest the remaining financial-forecasting corpus (follow-on 2)

Continues `scholar-ingest-financial-forecasting-corpus`, which ingested the first
paper: Andersen-Bollerslev-Diebold-Labys 2003 "Modeling and Forecasting Realized
Volatility" (`papers--andersen-modeling-forecasting-realized-volatility-2003`, 6
sections, fetched open from NBER WP 8160), filling the `garch-volatility-models`
concept Sections table (realized-volatility strand) and adding one row to
`mean-absolute-scaled-error`. Budget ~1 paper/cycle; idempotency-check before
re-ingesting; post further follow-ons as needed.

**Acquisition note (learned this cycle):** the classic econometrics venues
(Econometrica, J. Econometrics, J. Finance, RFS) are paywalled and JSTOR returns
only a ~15KB landing stub (not full text) via `fetch-source.sh`. Prefer the OPEN
working-paper / author-page copy and record the paywalled DOI as canonical
`source_url` with the open copy as `source_mirror_url`. Confirmed-fetchable hosts
from the bot sandbox: **nber.org** (`/system/files/working_papers/wNNNN/wNNNN.pdf`
served direct), **otexts.com** (FPP3). Try author faculty pages next
(Diebold at sas.upenn.edu, Patton at Duke, Corsi, Amit Goyal at unil.ch). Defer
any source you cannot faithfully full-text.

**Remaining volatility (highest value; fill `garch-volatility-models`):**
- Engle 1982 (ARCH, Econometrica); Bollerslev 1986 (GARCH, J. Econometrics);
  Nelson 1991 (EGARCH); Glosten-Jagannathan-Runkle 1993 (GJR-GARCH);
  Hansen & Lunde 2005 ("does anything beat a GARCH(1,1)?"); Patton 2011 (QLIKE /
  robust volatility loss); Corsi 2009 (HAR-RV). NBER working papers exist for
  several (search nber.org). Corsi 2009 and Patton 2011 have open author-page
  copies. Engle's Nobel-lecture / "GARCH 101" (JEP 2001) is a good open
  pedagogical substitute if the 1982 Econometrica original stays unreachable.

**Evaluation / anti-overfitting (fill `data-snooping-bias`, `mean-absolute-scaled-error`):**
- White 2000 (Reality Check); Hansen 2005 (SPA); Hansen-Lunde-Nason 2011 (Model
  Confidence Set); Diebold-Mariano 1995; Bailey-Borwein-Lopez de Prado-Zhu 2014
  (backtest overfitting, Notices of the AMS -- ams.org 403'd this cycle, try a
  mirror / Lopez de Prado's SSRN); Bailey & Lopez de Prado 2014 (Deflated Sharpe
  Ratio); Lopez de Prado 2018 (Advances in Financial ML, book -- likely defer).

**Limits of predictability (fill `efficient-market-hypothesis` Sections table --
placeholder row still present, remove it when the first source lands):**
- Fama 1970 (EMH); Welch & Goyal 2008 (equity-premium OOS failure -- Amit Goyal's
  page hosts it); Meese & Rogoff 1983 (random walk beats structural FX);
  Timmermann & Granger 2004.

**Classical / factor / ML (breadth):**
- FPP3 remaining chapters (ARIMA §9, exponential smoothing §8, VAR/NN §12,
  §1.1 what-can-be-forecast) via fetch-source.sh at otexts.com/fpp3/<chapter>.html;
  Fama-French 1993 (three-factor); Gu-Kelly-Xiu 2020 (empirical asset pricing via
  ML, RFS -- SSRN/NBER open copy); Makridakis et al. 2018 + M4/M5 competition;
  Moreira & Muir 2017 (volatility-managed portfolios -- fills the vol-targeting
  claim on `garch-volatility-models`).

Cross-link each new section into the `financial-forecasting` / `forecast-evaluation`
topic pages and the six concept pages already created.
