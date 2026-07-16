---
role: scholar
---
# Scholar: ingest the remaining financial-forecasting corpus (follow-on)

Follow-on to `scholar-financial-forecasting-literature` (the finbot survey), which
delivered the report `journal/projects/finbot/financial-forecasting-literature-review.md`
and anchored the library on the Hyndman & Athanasopoulos FPP3 forecast-evaluation
cluster (`sources/web--hyndman-fpp3-forecast-evaluation`, new topics
`financial-forecasting` + `forecast-evaluation`, 6 new concept pages). The report
cites many canonical sources by provenance that are not yet ingested as library
sections. Ingest them (idempotency-checked, budget ~1 paper/cycle — post further
follow-ons as needed):

**Volatility (highest value for finbot):**
- Engle 1982 (ARCH, Econometrica); Bollerslev 1986 (GARCH, J. Econometrics);
  Nelson 1991 (EGARCH, Econometrica); Glosten-Jagannathan-Runkle 1993 (GJR-GARCH);
  Hansen & Lunde 2005 ("does anything beat a GARCH(1,1)?"); Patton 2011 (QLIKE /
  robust volatility loss); Andersen-Bollerslev-Diebold-Labys 2003 (realized vol);
  Corsi 2009 (HAR-RV). Fill the empty Sections table on
  `concepts/garch-volatility-models.md`.

**Evaluation / anti-overfitting (fill concept Sections tables):**
- White 2000 (Reality Check); Hansen 2005 (SPA); Hansen-Lunde-Nason 2011 (Model
  Confidence Set); Diebold-Mariano 1995; Bailey-Borwein-López de Prado-Zhu 2014
  (backtest overfitting / pseudo-mathematics); Bailey & López de Prado 2014
  (Deflated Sharpe Ratio); López de Prado 2018 (Advances in Financial ML).
  → concepts `data-snooping-bias`, `mean-absolute-scaled-error`.

**Limits of predictability (fill `efficient-market-hypothesis` Sections table):**
- Fama 1970 (EMH); Welch & Goyal 2008 (equity-premium prediction OOS failure);
  Meese & Rogoff 1983 (random walk beats structural FX models); Timmermann &
  Granger 2004.

**Classical / factor / ML (breadth):**
- FPP3 remaining chapters (ARIMA §9, exponential smoothing §8, VAR/NN §12,
  §1.1 what-can-be-forecast) — same source, fetchable via fetch-source.sh at
  otexts.com/fpp3/<chapter>.html; Fama-French 1993 (three-factor); Gu-Kelly-Xiu
  2020 (empirical asset pricing via ML, RFS); Makridakis et al. 2018 + M4/M5
  competition findings (stats vs ML); Moreira & Muir 2017 (volatility-managed
  portfolios).

Many Miller/erights-adjacent fetch substitutes do not apply here; use
`fetch-source.sh` for open-access copies (arXiv, author pages, otexts). For
paywalled venues, record the source-index with the canonical URL/DOI and the
best open anchor available, and defer sections you cannot faithfully source.
Cross-link each new section into the `financial-forecasting` / `forecast-evaluation`
topic pages and the six concept pages already created.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 10
  worker_kind: gardener
  claimed_at: 2026-07-16T23:23:45Z
