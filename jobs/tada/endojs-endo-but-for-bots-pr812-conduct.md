orchestration-failed: true

Un-drafted endojs/endo-but-for-bots#812 and re-verified it is OPEN, APPROVED, MERGEABLE/CLEAN, with all reported checks successful.

Did not merge: its base is `feat/endor-run-top-level-await`, whose PR #805 is CLOSED and unmerged; that branch is six commits ahead of live `llm`. Merging #812 there would violate conductor live-trunk policy and bypass review scope. Maintainer follow-up: restore/resolve the stacked base, or explicitly direct a safe retargeting plan.

Removed the isolated project worktree.
