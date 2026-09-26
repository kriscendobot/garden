Completion report — `scholar-ingest-source-polaris-cacm-2006`

**Outcome: ingested the genuine "second Polaris."** The real later Polaris paper — the 2006 CACM article — was reachable, so no pivot to *How Emily Tamed the Caml* was needed.

**Acquisition.** Path #1 worked: `https://cacm.acm.org/research/polaris-2/` 403'd on a direct fetch but `fetch-source.sh` fell back to the Internet-Archive `id_` capture (Wayback ts `20251016191707`), which carries the **full article text** (Introduction, Polarizing Applications, How It Works, Conclusion, References, and both sidebars). I did **not** chase the bogus `HPL-2004-116`/`HPL-2006-116` URLs. Confirmed genuine against the title page before ingesting: *Polaris: Virus-Safe Computing For Windows XP*, **CACM 49(9):83–88, Sept 1 2006**, DOI `10.1145/1151030.1151033`, five authors incl. **Tyler Close**. Idempotency anchor: `source_content_sha256 = 373d4eef…e974b78e` (153,271 B of HTML — recorded as `source_content_sha256`, not `source_pdf_sha256`, because no PDF exists: ACM DL is paywalled and HP Labs has no CACM PDF; this is noted prominently in the source file).

**What I wrote (all landed on `origin/journal2` via `land-journal-edit.sh`, slug `papers--stiegler-polaris-cacm-2006`):**
- 4 section files, deliberately scoped to the **2004→2006 delta** rather than re-transcribing shared mechanism: (1) *what the 2006 revision adds*, (2) *closing the GUI hole — shatter-proofing Windows* (the headline new result), (3) *two years of pilot experience and residual limits*, (4) *privilege, permission, and authority* sidebar (with an Endo translation table).
- The source index `sources/papers--stiegler-polaris-cacm-2006.md` (filed `capability-security`/`capability-theory`, cross-referencing the 2004 report, the ocap-history survey, and Paradigm Regained).
- Index updates: extended the existing `concepts/polaris.md` table with the 4 new sections; added a row to `sources/README.md`; added rows to `topics/capability-security.md` (4) and `topics/capability-theory.md` (2); appended 14 keywords (GUI hole, Shatter attack, shatter-proofing, CACM Polaris, Tyler Close Polaris, User Account Protection, etc.) → `polaris`.

**Verification.** `library-link-check.sh --source-slug papers--stiegler-polaris-cacm-2006` → OK; `--changed` → OK. All 5 new files confirmed present on `origin/journal2`. Inbox drained (empty throughout).

**Follow-ups:**
1. **Posted job `scholar-dedup-duplicate-polaris-2004-ingest`.** During ingest I found the *first* Polaris paper (HPL-2004-221) was ingested **twice** in this same cycle by racing gardeners — canonical `papers--stiegler-polaris-virus-safe-computing-2004` (wired into the concept page + README) and orphan duplicate `papers--stiegler-karp-yee-miller-polaris-2004` (same sha256, not referenced). Both are `status: current`; the job asks a scholar to supersede the orphan per the conventions' consolidation rule.
2. **`How Emily Tamed the Caml` (HPL-2006-116, Stiegler & Miller)** remains an un-ingested candidate the library already references — a natural next paper-cycle pick (not needed as a pivot here since the CACM article was reachable).
