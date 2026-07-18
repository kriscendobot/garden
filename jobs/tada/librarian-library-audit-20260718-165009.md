Inbox is empty. The audit is complete.

## Librarian library-audit completion report

**Scope:** Proactive context-efficiency audit of `library/sections/` (6552 files), `library/concepts/` (202), `library/topics/` (66), and `library/sources/` (838), plus the three index surfaces (`keywords.md`, `topics/README.md`, `sources/README.md`).

**Oversize-document audit — no violations found.** The largest section `--body.md` files (up to 416 lines) sit behind short `parent:` abstract sections, and the largest standalone sections each open with an inline `> Abstract:` (one, `ses-readme--usage-modules`, is an explicitly-documented deliberate consolidation per `conventions.md` §166). In every case a reader can skim the abstract and commit-or-abandon without reading the body, so the abstract-at-the-top exit criterion holds. Topic and concept pages that look long (e.g. `capability-security.md`, 307 lines) are index tables doing their routing job, not prose. Posted no split jobs.

**Index-gap audit — 5 genuine gaps, in 2 index surfaces:**
- `sources/README.md`: 3 source pages exist but are unlisted — `node--doc-api-packages`, `npm--configuring-npm-package-json`, `papers--moreira-muir-volatility-managed-portfolios-2017`. (A 4th apparent miss, `erights-org--elang-intro`, is correctly excluded — it is `status: superseded` and its live successor `erights--elang-intro` is listed.)
- `keywords.md`: 2 concept pages have no keyword mapping — `dual-package-hazard`, `package-type-field` — so a `library-lookup` grep for their terms dead-ends.
- `topics/README.md` and `concepts/README.md`: fully indexed, no gaps.

**Jobs posted (both already claimed by the fleet, now in `jobs/doin/`):**
1. `library-index-sources-readme-3-missing-20260718` — add the 3 missing source rows to `sources/README.md` (lands via `land-journal-edit.sh`; carries provenance for each and the superseded-exclusion caveat).
2. `library-index-keywords-2-concepts-20260718` — add keyword→concept-id lines for the 2 orphan concepts, aliases pre-extracted from each concept's frontmatter.

**Follow-ups:** none required from me. Both edits are authorized library-content jobs to be landed through `land-journal-edit.sh` by their claiming gardeners; each job carries its own acceptance check.
