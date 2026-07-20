The rebase is complete and the PR is now `MERGEABLE`.

## Completion report

**Job:** Rebase `endojs/endo-but-for-bots` PR #160 (`feat/exo-zip-package` → `llm`) on its base.

**What I did:**
- Confirmed PR #160 was `CONFLICTING`: head branch `feat/exo-zip-package` (6 commits) sat on a merge-base that `origin/llm` had advanced 1010 commits past.
- Worked in an isolated project worktree keyed to this job's base (`ensure-project-worktree.sh`), never a shared checkout.
- Rebased the 6 commits onto fresh `origin/llm`. One conflict, in `designs/README.md`.

**Conflict resolution (`designs/README.md`):**
- The conflict was in the "Per-Design Estimates" table, which had diverged heavily on `llm` (milestone renumbering, `daemon-checkin-checkout` completion, etc.). The PR commit's actual intent was a single one-line edit to the `exo-zip-package` row description.
- I kept the `origin/llm` (HEAD) version of the whole table — preserving the new milestone numbering (`7`) and all upstream row updates — and reapplied only the PR's intended change: the `exo-zip-package` estimate-table row description now reads `@endo/exo-unzip (unzip(bytes) -> ReadableTree) and @endo/exo-zip (zip(tree) -> bytes); PR #128 reshape blocker`.
- The sibling first-table (`Proposed`) row change and the `designs/exo-zip-package.md` edits auto-merged cleanly.

**Verification:**
- Rebased branch is 6 commits ahead / 0 behind `origin/llm`; no conflict markers anywhere; `yarn.lock` textually merged clean and retains the exo-zip/exo-unzip entries; the separate `chore: Update yarn.lock` commit is preserved.
- Force-pushed with `--force-with-lease` (lease target `a7e6d5ad60`, matched) → `feat/exo-zip-package` now at `b7544e85d0`.
- PR #160 recomputed to **`MERGEABLE`**, still base `llm`, 6 commits.

**Follow-ups:** None required. `yarn.lock` merged textually without regeneration; if a downstream CI `yarn install` integrity check flags drift, a `chore: Update yarn.lock` refresh would be the fix, but no evidence of breakage was seen.
