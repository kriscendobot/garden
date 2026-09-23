Done. Worktree torn down, push landed on `journal2` (`6eabd81b3..c0fed358e`).

## Completion report — scholar-sections-readme-reindex

**Outcome:** `library/sections/README.md` backstop index fully reindexed in one pass — zero orphans remaining. No cross-cycle split was needed despite the job's estimate.

**What I did:**
- Worked in an **isolated worktree off `origin/journal2`** (per the garden-infra-jobs convention) rather than the live `/home/kris/journal` tree, which was concurrently mutated — origin advanced `c81c80665 → 6eabd81b3` mid-job, so I reset to the fresh tip and re-ran before committing.
- Wrote a **purely additive** generator: it parses the existing README into header-blocks and per-entry units, computes orphans (`files − linked`), and inserts each orphan only — never reorders or rewrites existing rows. This preserves **all** curated content untouched (the 452 hand-authored `### From …` prose headers, every `(index)` parent description, and the nested-child curation).

**What changed (1 commit, `+944 / −1`):**
- **376 orphan section files linked** (the live count; the job's ~398 snapshot had drifted as indexing continued). Source-slug = first two `--` segments.
- **189 new `### <slug>` headers** created in correct alphabetical position (e.g. `cask--architecture` slotted between `cask--allocator-design` and `cask--array-design`), each with sorted flat child rows matching the existing flat-group idiom.
- **4 orphans merged into existing groups** in sorted position (e.g. `…postponed-js--interlockP-…` correctly placed *before* the existing `…postponed-handler-…` index entry).
- **Count header updated:** `5561 (868 parent indexes + 4693 children)` → `5826 (506 parent indexes + 5320 children)`. The parent/child split is recomputed with a clean prefix-parent definition (parents+children = total exactly); I did not try to reproduce the prior numbers' undefined semantics.

**Verified:** post-write orphans = 0; the two known "dangling" links (`daemon-os-sandbox-plugin.md`, `endoclaw-oauth.md`) are untouched (they're upstream design-doc cross-reference quotes inside descriptions, not index links, as the job noted); **zero new duplicate links** introduced (the 189 pre-existing duplicates are untouched curation); diff removes no content line except the count header.

**Follow-ups:** none required. The breakdown semantics (what counts as a "parent index") were never formally defined; if a future scholar cares about matching the old 868/4693 convention, that definition should be pinned down — but the total is authoritative and correct.
