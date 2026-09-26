Everything is landed and verified. The job is complete.

---

## Completion report: `improve-post-ingest-parent-index-resolution-gate`

**What the job asked for:** a deterministic post-ingest integrity gate so that, before a library ingest is reported complete, every section-table target on each touched source page and every `sections/README.md` (index) row resolves to a committed file. The motivating defect: `ingest-ocap-kernel` (commit `069d42b1`) committed 11 child sections + the source page + the README rows but silently dropped the `kind: index` parent `sections/metamask-ocap-kernel--docs-kernel-guide-md.md`, leaving the source page and the README `(index)` row pointing at a nonexistent file until a later scan caught it.

**What I did** (landed on `main2`, commit `ec4b0494c`):

1. **`scripts/jobs/library-link-check.sh`** — a deterministic, write-free, network-free section-link resolver shared by two callers:
   - **Gate mode (`--changed [base]`)**: maps each library file changed since the base (committed + staged + unstaged + untracked) to its owning source-slug, then validates that source cluster — the source page's section table, the `kind: index` parent's child list, and the `sections/README.md` block. A row pointing at a file the ingest never wrote (the omitted parent) exits **1** loudly; an on-disk-but-git-untracked target (would not be pushed) is also flagged.
   - **`--all`** (whole-library), **`--source-slug <slug>`**, **`--files`** scopes; optional **`--wikilinks`** for the `[[concept]]` axis.
   - Walks the source/topic/concept/role → section axis, the `sections/README.md` backstop, and the source/README → `kind:index` parent axis the prior keyword/wikilink scans missed. Source-slugs contain `--`, so it never string-splits them; it maps section files to their owning source page by reference.
2. **`scripts/jobs/test/library-link-check-test.sh`** — hermetic, 13 assertions, all passing. Reproduces the exact missing-parent-index defect via both `--source-slug` and the `--changed` gate path, plus missing-child, untracked-target, and clean-cluster cases.
3. **Wired the gate into `roles/scholar/AGENT.md`** — new procedure step 8 ("Post-ingest integrity gate (deterministic; blocks completion)") that runs `library-link-check.sh --changed` and forbids completing on a nonzero exit, plus a matching `## Done` bullet. This is the only trigger point, since ingest runs inside the scholar LLM (there is no deterministic ingest harness to hook).

**Verified:** ran clean against the real library (resolved a live `kind: index` cluster's children); 13/13 hermetic tests pass; files and the role step confirmed on `origin/main2`.

**Coordination:** the sibling job `improve-deterministic-section-link-integrity-scan` (gardener 70) wants a `scripts/jobs/` checker for the *standing* scan. I proposed and messaged a clean split — I own the shared core resolver; their scan becomes a thin sync-tip-first wrapper calling `library-link-check.sh --all --wikilinks`. No conflict, no duplicated link-parsing. (No reply received during this cycle; the message is in their inbox.)

**Follow-ups / notes:**
- The role-file edit (`roles/scholar/AGENT.md`) is a meta-evolution touch; it is minimal, reversible, and directly authorized by this job ("add a gate to the ingest job path"). Flagging it here per the proactively-fix-the-garden norm in case the liaison wants to review the wording.
- I did **not** also edit `journal/library/conventions.md` (journal2) — the role-file step is the load-bearing wiring the scholar reads every cycle, and writing to the live shared journal worktree concurrently with ~100 gardeners is avoidable risk. A conventions.md cross-reference is a low-priority nice-to-have a future scholar cycle can add.

Scratch worktree torn down; no stray worktrees left.

Self-improvement: nothing structural this time — the lesson (catch integrity defects at the producer, not just the downstream scan) is encoded directly in the script and the scholar step rather than needing a role/skill change beyond the one this job authorized.
