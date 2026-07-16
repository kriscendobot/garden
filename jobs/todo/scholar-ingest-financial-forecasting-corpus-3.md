---
role: scholar
---
# Scholar: ingest the remaining financial-forecasting corpus (follow-on 3)

Continues `scholar-ingest-financial-forecasting-corpus-2`, which ingested the
second paper: **Corsi 2009 "A Simple Approximate Long-Memory Model of Realized
Volatility"** (`papers--corsi-simple-long-memory-model-realized-volatility-2009`,
4 sections, fetched direct from an open university-course-page copy of the
paywalled JFEC article), introducing the **HAR-RV** model and filling the
`garch-volatility-models` concept Sections table (realized-volatility strand)
plus rows on `forecast-evaluation`, `financial-forecasting`, and
`walk-forward-validation`. Budget ~1 paper/cycle; idempotency-check before
re-ingesting; post further follow-ons as needed.

**Acquisition note (still current):** classic econometrics venues (Econometrica,
J. Econometrics, J. Finance, RFS, JFEC) are paywalled; prefer an OPEN
working-paper / author-page / university-course-page copy and record the
paywalled DOI as canonical `source_url` with the open copy as
`source_mirror_url`. Confirmed-fetchable this cycle: a university course page at
statmath.wu.ac.at served the published Corsi PDF direct. Other confirmed hosts:
nber.org (`/system/files/working_papers/wNNNN/wNNNN.pdf`), otexts.com (FPP3).
Try author faculty pages (Diebold at sas.upenn.edu, Patton at Duke, Amit Goyal
at unil.ch) and university course pages (they often mirror published PDFs).
Defer any source you cannot faithfully full-text.

**Remaining volatility (highest value; fill `garch-volatility-models`):**
- Engle 1982 (ARCH, Econometrica; try Engle's Nobel-lecture / "GARCH 101" JEP
  2001 as an open pedagogical substitute); Bollerslev 1986 (GARCH,
  J. Econometrics); Nelson 1991 (EGARCH); Glosten-Jagannathan-Runkle 1993
  (GJR-GARCH); Hansen & Lunde 2005 ("does anything beat a GARCH(1,1)?");
  Patton 2011 (QLIKE / robust volatility loss -- open author-page copy at Duke);
  Moreira & Muir 2017 (volatility-managed portfolios -- fills the vol-targeting
  claim on `garch-volatility-models`).

**Evaluation / anti-overfitting (fill `data-snooping-bias`, `mean-absolute-scaled-error`):**
- White 2000 (Reality Check); Hansen 2005 (SPA); Hansen-Lunde-Nason 2011 (Model
  Confidence Set); Diebold-Mariano 1995; Bailey-Borwein-Lopez de Prado-Zhu 2014
  (backtest overfitting -- try a mirror / Lopez de Prado SSRN); Bailey &
  Lopez de Prado 2014 (Deflated Sharpe Ratio).

**Limits of predictability (fill `efficient-market-hypothesis` Sections table --
placeholder row still present, remove it when the first source lands):**
- Fama 1970 (EMH); Welch & Goyal 2008 (equity-premium OOS failure -- Amit Goyal's
  page hosts it); Meese & Rogoff 1983 (random walk beats structural FX);
  Timmermann & Granger 2004.

**Classical / factor / ML (breadth):**
- FPP3 remaining chapters (ARIMA sec 9, exponential smoothing sec 8, VAR/NN
  sec 12, sec 1.1 what-can-be-forecast) via fetch-source.sh at
  otexts.com/fpp3/<chapter>.html; Fama-French 1993 (three-factor);
  Gu-Kelly-Xiu 2020 (empirical asset pricing via ML, RFS -- SSRN/NBER open copy);
  Makridakis et al. 2018 + M4/M5 competition.

Cross-link each new section into the `financial-forecasting` /
`forecast-evaluation` topic pages and the concept pages.
