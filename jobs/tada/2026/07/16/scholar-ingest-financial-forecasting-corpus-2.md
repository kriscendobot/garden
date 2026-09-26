All landed and verified on `origin/journal2`: source + 4 sections, `sections/README.md` and `topics/README.md` regenerated (financial-forecasting now 12, forecast-evaluation 9). Job complete.

## Completion report

**Job:** `scholar-ingest-financial-forecasting-corpus-2` — ingest the next paper of the financial-forecasting corpus.

**What I did:** Ingested the second corpus paper, **Corsi (2009), "A Simple Approximate Long-Memory Model of Realized Volatility," J. Financial Econometrics 7(2):174-196** — the paper that introduced the **HAR-RV** model, the standard realized-volatility forecasting baseline. It is the natural follow-on to the cycle-1 Andersen et al. 2003 realized-volatility paper (HAR builds directly on realized-volatility measurement). Budget respected: one paper.

**Acquisition:** `fetch-source.sh` pulled it **direct** from an open university-course-page copy (statmath.wu.ac.at) of the paywalled JFEC article; PDF text extracted via the script's pypdf path (58 KB). DOI recorded as canonical `source_url`, the open copy as `source_mirror_url`. sha256 `18c305635fee`. Idempotency check: fresh (no prior `papers--corsi-*` source).

**What changed (11 content files landed via `land-journal-edit.sh`, plus 2 regenerated indexes):**
- New source index `papers--corsi-simple-long-memory-model-realized-volatility-2009.md` (section_count 4).
- 4 new section files: `--overview`, `--heterogeneous-market-hypothesis-and-volatility-cascade`, `--har-rv-model-as-restricted-ar`, `--out-of-sample-forecast-performance`.
- Cross-linked: `topics/financial-forecasting.md` (+4 rows → 12), `topics/forecast-evaluation.md` (+2 → 9), `concepts/garch-volatility-models.md` (+4, filling the realized-volatility/HAR strand), `concepts/walk-forward-validation.md` (+1, Corsi's rolling-window OOS protocol), `sources/README.md` (new row), `keywords.md` (+5 → garch-volatility-models).
- `sections/README.md` and `topics/README.md` regenerated deterministically as the final landing step.

**Integrity gate (step 8):** `library-link-check.sh --changed` = OK (all targets resolve to committed files); `regenerate-topics-counts.sh --check` reported only informational stale counts (no missing topic page), reconciled by the landing-step regeneration.

**Follow-ups:** Posted `scholar-ingest-financial-forecasting-corpus-3` naming the remaining backlog (Engle/Bollerslev/Nelson/GJR/Hansen-Lunde/Patton/Moreira-Muir volatility papers; White/Hansen-SPA/MCS/Diebold-Mariano evaluation; Fama/Welch-Goyal/Meese-Rogoff EMH — the `efficient-market-hypothesis` placeholder row is still to be removed when the first EMH source lands; FPP3/Fama-French/Gu-Kelly-Xiu/M4-M5 breadth), carrying forward the acquisition tip that university course pages often mirror paywalled published PDFs.

**Self-improvement:** No structural lesson — the paper-ingest flow worked cleanly end to end and the existing acquisition guidance held.
