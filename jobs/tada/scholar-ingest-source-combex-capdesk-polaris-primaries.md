Job complete and verified on `origin/journal2` (`doin` cleared, report in `tada`).

## Completion report

**scholar-ingest-source-combex-capdesk-polaris-primaries** — done in one cycle. The CapDesk/Polaris primaries are recoverable; ingested 5 primary sources (`source_fetched_via=wayback`) and 11 section files.

**Sources ingested:**
- `combex--tech-index` (1 §) — Combex Technology hub page (SHA `f22dc828`)
- `combex--edesk` (2 §) — "E and CapDesk: POLA for the Distributed Desktop", the canonical CapDesk primary (SHA `0cc54052`)
- `combex--darpa-browser` (3 §) — "The DarpaBrowser", the DARPA-accepted confined-renderer document, the most substantive CapDesk-era primary (SHA `3a68fd80`)
- `combex--opportunity` (1 §) — CapDesk threat-model/market framing (SHA `9bbce140`)
- `papers--stiegler-karp-yee-miller-polaris-2004` (4 §) — "Polaris: Virus Safe Computing for Windows XP" (HPL-2004-221), the Polaris primary, PDF text extracted via pypdf (PDF SHA `6c95faf1`)

All filed under `capability-security` / `capability-theory`, landed through `land-journal-edit.sh`.

**Indexes updated:** `sources/README.md` (4 web + 1 paper rows), `sections/README.md` (5 source blocks), both topic pages (9 + 5 rows), `keywords.md` (17 keywords), and a bidirectional cross-reference added to the existing secondary survey `ocap-history--e-capdesk-polaris.md`.

**Integrity gate:** `library-link-check.sh` passed (rc=0) on all 6 touched clusters via `--source-slug` and on all navigation surfaces via `--nav`.

**Recon confirmed:** combex.com is unreachable directly and absent from the erights.github.io mirror — every byte came from the Internet-Archive `id_` path. Polaris is not on combex; its primary is HPL-2004-221. Marc Stiegler's skyhunter.com pages have no usable Wayback captures (curl rc=22).

**Follow-ups (deferred, not forced, no follow-on job posted):** combex `products.html`, `screen-shots.html`, `papers/index.html`, and the external skyhunter "E in a Walnut" pages remain un-ingested — secondary to the primaries this job targeted.

**Self-improvement candidate (noted, not landed — outside gardener authority):** `fetch-source.sh` has no PDF-text extraction path; I hand-extracted HPL-2004-221 with pypdf (available in the sandbox; `pdftotext` is not). A deterministic "fetch + extract text for paper PDFs" companion would remove the one hand-rolled step in paper ingestion.
