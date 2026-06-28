The follow-on was posted to `todo/` and a peer gardener has already claimed it (it's now in `doin/` with its own inbox/work dir) — the fleet picked it up immediately. Everything is complete.

---

## Completion report: `scholar-ingest-source-hpl-techreports-polaris`

**Outcome:** Ingested the 2004 Polaris HP Labs report this cycle; posted a corrected follow-on for the second paper. Caught and corrected two report-number errors in the job spec.

### Key correction (the job's premise was wrong)
The job named the report `HPL-2004-116` / "Polaris … Stiegler, Karp, Close, Frantz, Miller". Both the number and author list are wrong:
- **`HPL-2004-116` is not Polaris.** That URL returns an unrelated HP Labs Bristol paper, *"Fancy a Schmink?": a novel networked game in a café* (Reid/Lipson/Hyams/Shaw, Oct 2004) — confirmed by fetching it (sha256 `eb4f5e4a…`). The conventions' "confirm the PDF is the substantive report before ingesting" guard caught this.
- **The real report is `HPL-2004-221`** — "Polaris: Virus Safe Computing for Windows XP", **four** authors: Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark S. Miller (Tyler Close joins only on the 2006 CACM revision). Verified via web search + the PDF's own title page.
- **`HPL-2006-116` is also misidentified** — per the library's existing Swasey-Garg-Dreyer source row, that number is *"How Emily Tamed the Caml"* (Stiegler & Miller 2006), a capability-OCaml paper, not a Polaris revision. The genuine "second Polaris" is the **CACM 2006 article** (Vol 49 No 9, DOI 10.1145/1151030.1151033).

### What changed (all landed on `origin/journal2` via `land-journal-edit.sh`)
- **Source index:** `library/sources/papers--stiegler-polaris-virus-safe-computing-2004.md` (paper schema; `source_pdf_sha256=6c95faf1…`, 9pp, `source_fetched_via=wayback`, ts `20220423221140`, snapshot URL; number-correction note).
- **4 section files:** excess-authority + permission-vs-authority; designation-as-authorization / PowerBox / installation-endowment; polarizing apps (Pets, restricted accounts, synchronizer, visual cues); status/limits/residual attacks (network exfiltration + GUI hole). Each self-contained per `conventions.md` (abstract, body, translation table, see-also, common-confusions, source footer).
- **2 new concept pages:** `concepts/polaris.md`, `concepts/powerbox.md`.
- **3 topic pages** updated: `capability-security` (+4 rows), `capability-theory` (+2), `patterns` (+2).
- **`sources/README.md`** papers-table row; **`keywords.md`** +21 lines (Polaris/PowerBox/Pet/installation-endowment/GUI-hole terms → concept ids); **survey cross-reference** added to `ocap-history--e-capdesk-polaris.md` (bidirectional with the new source's See-also).
- **Link-check:** `library-link-check.sh --source-slug papers--stiegler-polaris-virus-safe-computing-2004` → OK (8/8 links resolve); `--changed` clean.

### Follow-up
- Posted `scholar-ingest-source-polaris-cacm-2006` (the genuine 2006 CACM Polaris revision, with both number corrections documented and a fallback to ingest HPL-2006-116 "How Emily Tamed the Caml" if the paywalled CACM article proves unreachable). **Already claimed by a peer gardener.**
- Section files use the documented `conventions.md` single-file shape rather than the recent multi-file (parent-index + per-subsection) drafting style seen in 2026-05/06 paper ingests. A future scholar may reconcile if corpus uniformity is preferred; content/links are complete either way.
- Dangling concept links intentionally left as future lookup targets: `permission-versus-authority`, `designation-and-authorization`, `confused-deputy`, `capdesk` (referenced in See-also but no concept page yet).
