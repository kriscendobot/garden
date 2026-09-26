The full classified scan confirms: **every must-resolve navigation/index/source-table link now resolves**; the 168 remaining are the expected advisory upstream-verbatim leaf-body links (dangle by construction, out of scope). My work is complete.

---

**Completion report — `fu-scholar-ingest-erights-4-3`**

**What I found.** The authoritative tip-synced nav scan (`library-link-scan.sh --nav`, the only correct tool — it resolves against `origin/journal2` tip, never the stale live worktree) reported **3** dangling must-resolve nav-links, all in the **erights** cluster — not the `endo-but-for-bots--llm-designs-*` cluster the job text named (that cluster was already clean; peers had resolved it). The 3 danglers traced to today's `scholar-ingest-erights` ingest having written the source/concept pages but **not** the two section bodies they reference:

- `sources/erights--elang-concurrency-epimenides.md` → missing `…--reference-states-and-data-lock.md`
- `concepts/data-lock.md` → same missing section (cited as its "canonical origin")
- `sources/erights--elib-concurrency-index.md` → missing `…--event-loop-reference-map.md`

**What I did.** Rather than prune live nav rows (which would orphan a rich concept page and lose recoverable content), I **completed the ingest**:
1. Re-fetched both upstream pages via `fetch-source.sh`; both content SHA-256s matched the source pages' recorded anchors **exactly** (same bytes the scholar ingested — no drift).
2. Authored the two missing section files faithfully from the upstream text, matching the established sibling format (frontmatter, Abstract, content, "Why this matters for Endo," E→Endo translation table, Source provenance). Verified every cross-reference I added (`…concurrency-index--event-loop-concurrency-map`, `…concurrency-among-strangers…vat-and-event-loop-model`) exists at tip before writing.
3. Landed both via the sanctioned `land-journal-edit.sh` producer-clone CAS path (never touched the live `/home/kris/journal` worktree or the root checkout).

**Verification.** Re-ran the tip-synced scan: `--nav` is **clean**, and `--all` reports **0 must-resolve danglers** (only the 168 expected advisory upstream-verbatim leaf-body links remain). `section_count: 1` in both source pages now matches reality.

**Follow-up (not blocking).** `sections/README.md` (the 5500-entry auto-generated backstop) does not yet list the two new section clusters. This is a completeness gap, **not** a dangling link (the nav scan passes), and is owned by the deterministic `regenerate-sections-index.sh` projection (currently a peer's uncommitted WIP) — hand-editing a 3 MB generated file via whole-file replace would risk dropping a concurrent sibling's rows, so I left it for that mechanism. Inbox was empty throughout.
