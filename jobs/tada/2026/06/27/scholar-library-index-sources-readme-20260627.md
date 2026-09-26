Worktree removed (the cwd error is just because my shell was inside it). Done.

---

**Completion report — `scholar-library-index-sources-readme-20260627`**

**Outcome:** Reconciled `journal/library/sources/README.md` with the `sources/` directory. The gap was live (not a no-op): 102 ingested source-index files existed on `origin/journal2` without a link from the master index.

**What I did:**
- Recomputed the gap against the live tree, then re-confirmed it against `origin/journal2` (the local `/home/kris/journal` worktree had diverged from origin, so I built in an **isolated detached worktree off `origin/journal2`** per garden-infra discipline rather than fighting the shared, concurrently-mutated worktree).
- Extracted per-file metadata (display path, section count, status, first-sentence abstract) from each of the 102 files, handling the mixed frontmatter schemas (`source_path`/`file_commit_*`, `source_url`/`source_date`, and a few one-off shapes).
- Added the entries grouped by the existing partition:
  - **29 endojs/endo** rows → new `### endojs/endo per-package READMEs, design, and changeset docs` subsection under `## Ingested` (schema `Source | Abstract | Sections | Status`, matching the precedent of the existing Collections sub-table).
  - **68 endojs/endo-but-for-bots** rows → parallel `### …per-package READMEs, docs, designs, and source fragments` subsection.
  - **5 cloud-marketplace web sources** → appended to the existing `## External web sources` table (matched its `Source | URL | Sections | Status` schema; Title-cased the labels to match neighbors).
- Dropped one would-be duplicate: `endo--packages-init-node-async_hooks` was already indexed under `## External code-comment fragments` (its underscore made the job's detection regex falsely flag it). Net result: every source file referenced exactly once.

**Verification:** 0 unreferenced source files (re-checked post-rebase: 0/587), 0 duplicate links among the added set, well-formed tables.

**Push:** Rebased cleanly over a concurrent gardener push (the conflicting commit touched the top-level `README.md`, not the library index) and pushed `795e4cead..8625edb3d` to `journal2`. Isolated worktree torn down.

**Follow-ups:** None required. Inbox drained at checkpoints — empty. Note: the `sources/` set is still actively growing (520→587 files during this job from concurrent ingests); those newer files were already self-linked by their ingesting cycles, so no new gap was introduced.
