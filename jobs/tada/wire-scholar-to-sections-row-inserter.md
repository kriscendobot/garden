Done. Inbox empty.

---

## Completion report: `wire-scholar-to-sections-row-inserter`

**Goal:** Wire the scholar's library-ingestion procedure to *use* `scripts/jobs/insert-sections-table-row.sh` for adding a row to a topic page's `## Sections` table, closing the documented path that produced the 2026-06-28 erights-part-2 mis-placement (headingless see-also block on `pass-style.md`).

**What I did**

1. **Verified the helper exists on main2** — commit `5d81f1c40`, `scripts/jobs/insert-sections-table-row.sh`. Its anchor is the parsed table boundary (last `|`-leading data row → terminating blank line), never a `## See also` heading.

2. **`journal/library/conventions.md` (journal2, the scholar's always-read doc)** — landed via `land-journal-edit.sh` (whole-file, CAS-pushed to `origin/journal2`):
   - **§ Ingestion procedure, step 5** rewritten from "append a row … (create the topic file if new)" to an explicit instruction to call the inserter with a fenced command example, stating precisely that it anchors on the table boundary, that it must **never** anchor on a `## See also` heading (frequently absent → row drops outside the table), citing the 2026-06-28 `pass-style.md` incident / journal entry 161137Z, and forbidding hand-construction of the whole-file body for a row insertion.
   - **§ Topic-page shape, item 2** got a one-line cross-reference to the helper pointing back at step 5.

3. **`roles/scholar/AGENT.md` (main2, optional cross-reference)** — landed in an isolated worktree off `origin/main2`, committed and pushed (`3a53fe6ab`). Added a pointer in the per-job step 4 "Ingest or re-ingest" bullet (where it lists writing the touched `topics/*.md`) to call the inserter per conventions § step 5, so a scholar working straight from the role procedure also gets the directive without a re-lookup.

**Acceptance check (met):** A scholar reading `conventions.md` is now told to call the helper for `## Sections` row insertion, with the no-`## See also`-anchor rule stated precisely; the headingless-see-also mis-placement cannot recur from the documented path. Reinforced in the role file per the standing lesson "put the directive in the doc the role reads every job."

**Verification:** Confirmed both references present on `origin/journal2`; the main2 commit is at the branch tip. Isolated worktree removed.

**Follow-ups:** None. (Both branches landed cleanly; no remainder.)

Self-improvement: The job split cleanly across two branches — the substantive directive on journal2 (`land-journal-edit.sh`) and an optional reinforcing pointer on main2 (isolated worktree push). Keeping the authoritative rule in the always-read journal doc and the role file as a redundant pointer follows the encoded lesson that a single bus message or tool-only encoding is insufficient; the doc the role reads every cycle is the reliable home.
