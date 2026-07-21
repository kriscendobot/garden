Conducted https://github.com/endojs/endo-but-for-bots/pull/800 on the bot fork only.

- Re-verified that the PR targeted live `llm`, was open and mergeable, and that `origin/llm` was an ancestor of approved head `f45ef36aa`; no fixup commits required tidying.
- The CI rollup had no failures. I queued the conductor auto-merge while two non-required checks were still running; GitHub merged the PR at 2026-07-21T03:18:54Z as merge commit `151db3d8b40b6a674b043b785586ad98c4dabde4`.
- Verified the final PR state is `MERGED`, the remote `feat/endor-npm-run` branch is deleted, and no branch used by open PR #802 was deleted. At final observation, the rollup had 24 checks, 0 failures, and 1 still in progress.

Follow-up: none for the merge. The remaining non-required CI check can finish normally after the merge.
