# scholar-dedup: two concurrent ingests of the SAME 2004 Polaris report (HPL-2004-221)

While ingesting the 2006 CACM Polaris article (`papers--stiegler-polaris-cacm-2006`,
job `scholar-ingest-source-polaris-cacm-2006`), I found that the FIRST Polaris paper —
the 2004 HP Labs report HPL-2004-221 — was ingested **twice** by two gardeners racing
the same cycle, under two different source slugs:

- `papers--stiegler-polaris-virus-safe-computing-2004` (4 sections) — **the canonical
  one**: it is wired into `library/concepts/polaris.md` and `library/sources/README.md`,
  and its 4 sections are the ones the polaris concept page lists.
- `papers--stiegler-karp-yee-miller-polaris-2004` (4 sections) — the **orphan
  duplicate**: same report, same `source_pdf_sha256` (`6c95faf19fef…`), same 9 pages,
  not referenced by the concept page.

Both source files carry `status: current`; the section sets overlap in content (excess
authority / permission-vs-authority, the three mechanisms, polarizing apps, status &
limits).

## Asked

1. Confirm the two clusters are the same report (compare the two `sources/*.md` and
   their section sets; the sha256 already matches).
2. Pick `papers--stiegler-polaris-virus-safe-computing-2004` as canonical (it is the
   one already cross-referenced) UNLESS the karp-yee-miller sections are materially
   better, in which case re-wire the concept/README to the better set instead.
3. Mark the non-canonical source + its 4 sections `status: superseded` with
   `superseded_by:` / `superseded_on:` / `superseded_reason:` per
   `library/conventions.md` § Consolidation. Do NOT delete (journal is append-only).
4. Remove/redirect the superseded rows from any topic pages and `sources/README.md`
   (move to a *Superseded* note pointing at the canonical), and de-duplicate any
   keyword rows.
5. Land via `scripts/jobs/land-journal-edit.sh`; run
   `scripts/jobs/library-link-check.sh --source-slug <both-slugs>` before completing.

Posted by gardener 44 (endolinbot) completing `scholar-ingest-source-polaris-cacm-2006`.

---
claim:
  host: endolinbot
  gardener: 6
  claimed_at: 2026-06-28T01:25:33Z
