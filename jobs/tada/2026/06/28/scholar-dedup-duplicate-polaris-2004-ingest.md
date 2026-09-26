Job complete.

## Completion report — scholar-dedup-duplicate-polaris-2004-ingest

**Confirmed the duplicate.** `papers--stiegler-karp-yee-miller-polaris-2004` and `papers--stiegler-polaris-virus-safe-computing-2004` are the same report: identical `source_pdf_sha256` `6c95faf19fef…`, same HPL-2004-221, same 9 pages, same four authors (Stiegler, Karp, Yee, Miller), same Wayback capture (`20220423221140`). Their two 4-section sets cover the same material.

**Canonical decision.** Kept `papers--stiegler-polaris-virus-safe-computing-2004` (the job's default) — it is the cluster wired into `concepts/polaris.md`, `concepts/powerbox.md`, and `sources/README.md`. The karp-yee-miller sections are quote-rich but not *materially* better, and re-wiring two concept pages would have been far more disruptive.

**Marked superseded** (per `conventions.md` § Consolidation; not deleted — journal is append-only):
- Orphan source `papers--stiegler-karp-yee-miller-polaris-2004.md` → `status: superseded`, `superseded_by`/`_on`/`_reason` added, a superseded banner above the abstract, and its section-table statuses flipped to `superseded`.
- All 4 orphan sections → `status: superseded` with per-section `superseded_by` pointing at the closest canonical section.
- Canonical source `notes:` updated with a CONSOLIDATION entry recording the dedup and the section→section mapping.

**Rewired / de-duplicated:**
- `sources/README.md`: orphan row marked **superseded** redirecting to the canonical row (also joined the table that the racing ingest had split with a stray blank line).
- `keywords.md`: dropped the duplicate `PowerBox` row (already covered by the `powerbox` concept); redirected `Polaris`, `polarize`, `installation endowment`, `permission vs authority`, `RunAs` to canonical sections.
- `sections/README.md`: orphan block heading annotated superseded → canonical.
- `topics/capability-security.md` and `topics/capability-theory.md`: moved the orphan rows out of the main Sections tables into new **Superseded sections** subsections mapping each to its canonical replacement.
- Redirected stale prose cross-references away from the orphan to the canonical slug in `combex--edesk.md`, `combex--opportunity.md`, `combex--tech-index.md`, `ocap-history--e-capdesk-polaris.md`, and the `combex--edesk--capdesk-confinement-and-developer-productivity` section body.

**Landing & verification.** All 16 files landed via `land-journal-edit.sh` (16/16, no CAS failures; verified no edited file had been committed since my scratch read, so no sibling clobber). `library-link-check.sh --source-slug` passes clean (exit 0) for **both** slugs. Tip re-inspection confirms all superseded statuses and that no active cross-reference still points readers at the orphan as the canonical Polaris paper.

**Follow-ups:** none. Inbox drained clean throughout.
