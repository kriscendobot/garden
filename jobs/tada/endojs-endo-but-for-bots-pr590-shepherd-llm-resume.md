Shepherd job complete. PR #590 is merged and green.

**What I did**
- Re-fetched live state: PR #590 (base `llm`, head branch `refactor/inter-package-far-repoint-deprecate`) was OPEN with `lint` red.
- Confirmed the PR head was based on pre-fix `llm` (merge-base `e50be0b0`); `origin/llm` was at `2b2e3200` (the merged bucketed-eslint ceiling fix, #597).
- Rebased the PR's two commits onto `origin/llm` cleanly and force-pushed with lease (`d52073e79` → `83d11e12c`).
- The rebased run's `lint` still failed — but on a **different** step than the ceiling: `yarn build:types:check` ("Check composite tsconfig files are up to date"). The eslint step itself passed, confirming the ceiling fix worked. This was a direct downstream effect of the PR: repointing `@endo/far` consumers to `@endo/pass-style` added a dependency that the composite tsconfig project-references hadn't picked up.
- Regenerated the composite tsconfigs (`node scripts/generate-composite-tsconfigs.mjs`, via a corepack yarn@4.13.0 shim), which added `../pass-style` references to `packages/daemon` and `packages/exo-playwright`. Verified `--check` passes, committed those two files, and pushed (`83d11e12c` → `d512cb9c7`).

**What changed**
- PR #590 head branch rebased onto current `llm` and given a regenerated-tsconfig commit; both mechanical and in shepherd scope (no source-logic change).
- Result: all 24 checks green; **PR #590 merged** at `d512cb9c7`.

**Follow-ups**
- None. No fixer escalation was needed — the second failure was a deterministic regenerate-and-commit, not an out-of-scope defect. No comments posted (none warranted despite standing auth). The corepack shim lived in `/tmp` and the isolated project worktree is disposable.
