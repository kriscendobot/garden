Audited 171 design records and `designs/README.md` on current `llm` (`f6d2efbbb9`).

No changes made: open bot grooming PR #804 already contains the safe link repairs and index filing this audit found. It is far behind `llm`, so rebasing it is unsafe; no duplicate PR opened.

Live-checked 151 cited records: 99 closed PRs, 52 open PRs. Left unresolved: references to still-open design PRs #432 and #450.

Checks: `git diff --check` clean; worktree byte-identical. `yarn docs` not runnable because the dependency install cannot execute `prebuild-install`, `node-gyp`, or `typedoc` (permission denied).
