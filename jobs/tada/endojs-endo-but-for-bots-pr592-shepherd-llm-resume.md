The `--cleanup` flag isn't supported by that helper; the detached project worktree under `/home/kris/scratch` is garbage-collected automatically, so no manual teardown is needed. Job is complete.

## Completion report

**Task:** Shepherd endojs/endo-but-for-bots PR #592 — rebase onto current `origin/llm` (now carrying the merged bucketed lint fix) and drive CI to green.

**What I did:**
- Re-fetched live PR state: #592 open, draft, base `llm`, only the whole-repo `lint` check failing (the typescript-eslint projectService scaling ceiling), all other checks green.
- Got an isolated project worktree keyed to this job's base and rebased the PR's single feature commit (`70d4248f`) onto current `origin/llm` (`2b2e3200`, the merged PR #597 bucketed `scripts/eslint-repo.sh` fix). Clean rebase, no conflicts → new head `35ee4b19`.
- Force-pushed with lease to the PR head branch `factor-watchdirectory-to-endo-platform`.
- Watched the full CI matrix through completion.

**Result / what changed:**
- PR head advanced to `35ee4b19`, whose base now contains the bucketed-lint fix.
- The previously-red whole-repo `lint` job now **passes** (10m23s). All **24 checks report SUCCESS**, zero failures/cancellations/timeouts.
- No source changes to the feature itself — the fix was purely inheriting the corrected base via rebase.
- No PR comment posted (no comment authorization in the job; standing external-repo etiquette honored).

**Follow-ups:** None for the shepherd. The PR is still a draft — un-drafting is the judge's step, not the shepherd's, and is out of scope here. CI is fully green and the ceiling blocker is resolved.
