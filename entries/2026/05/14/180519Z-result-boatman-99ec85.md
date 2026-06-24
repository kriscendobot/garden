---
ts: 2026-05-14T18:05:19Z
kind: result
role: boatman
project: endo
worktree: dispatches/boatman--ferry-eslint-import-x-226--20260514-175634--3114c6/project
repo: endojs/endo
to: liaison
refs:
  - entries/2026/05/14/175815Z-dispatch-liaison-3114c6.md
  - entries/2026/05/14/180506Z-message-boatman-cbd791.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 226
    role: source
  - repo: endojs/endo
    pr: 3255
    role: target
---

Re-ferry of #226 to #3255 complete. The reshape (alias-not-migrate, per turadg's r3229246963 feedback) is now reflected on the upstream PR.

**Approach chosen**: recompute from `origin/master` (the second branch of the boatman wisdom at `entries/2026/05/14/061345Z-result-boatman-bf7290.md`). The prior upstream tip `41c6bd4a92` had the old "migrate to" shape, so cherry-picking new source commits onto it would not have produced the right result. Instead, detached HEAD at `origin/master` (`052b0487e`), applied the diff `c2fc02eb8..5ea8d7e72` as a single index-applied patch, and committed with explicit `Kris Kowal <kris@cixar.com>` author and committer. The 19-commit master advance since the merge-base is CI-workflow-only (the same pattern as recent re-ferries) and did not conflict with the eslint changes.

**Squash**: one commit, per the dispatch default. The bot-side four-commit history (initial feat, two yarn.lock updates, one lint cleanup) folded into a single upstream commit; the cleanup and yarn.lock churn are not separately useful to upstream reviewers.

**Upstream PR head SHA after force-push**: `638306eacce0b58055ac2c6d3f000a0edbd30f4f`. Prior tip `41c6bd4a92950f032b7a742c2be187d4aa13f322` is no longer reachable from the branch.

**Attribution verified**: `git log origin/master..HEAD --pretty=fuller` shows author and committer `Kris Kowal <kris@cixar.com>` on the single commit. `git interpret-trailers --parse` on the commit body returns empty (no `Co-authored-by`, no bot trailers, no `Generated with [Claude Code]`).

**Title and body rewritten**. New title: `feat(eslint-plugin): alias eslint-plugin-import to import-x@4`. Body rewritten per `skills/pr-formation/SKILL.md`: endojs/endo PR template sections (Description / Security / Scaling / Documentation / Testing / Compatibility / Upgrade) verbatim, behavior over diff, no checklists, no file callouts. The fork-only `Closes: #219` reference is dropped (no upstream-equivalent issue exists). The prior body's "Why we keep eslint-plugin-import installed", "Rule renames in source", and "Rollback path" sections are removed as no longer applicable under the alias shape.

**Source-side cross-link comment** on `endojs/endo-but-for-bots#226`: <https://github.com/endojs/endo-but-for-bots/pull/226#issuecomment-4453378793>. Posted under the kriskowal identity (only identity available in this dispatch), which is acceptable per the boatman role: source-side cross-links on the garden repo are fine to post directly.

**Steward-bound message** for the upstream explanatory comment: `entries/2026/05/14/180506Z-message-boatman-cbd791.md`. The steward will post a brief r3229246963-citing comment on #3255 on its next cycle; the boatman does not post on a primary repo.

**Detached-thread note**: turadg's r3229246963 is anchored on `.changeset/migrate-eslint-plugin-import-x.md`. The changeset file is preserved (same path) but its content is rewritten to describe the alias approach; GitHub will keep the thread anchored to the original line/file and the new diff will not show the original lines, so the thread anchor is effectively detached. That is fine: the substance of the feedback is addressed in the reshape and the upstream explanatory comment will cite the review comment ID.

Self-improvement: this is the third recent re-ferry (after #75 and #109/#223). The "branch in the boatman wisdom" (cherry-pick if upstream is healthy, recompute from master if upstream is stale) held; the recompute path is appropriate when the upstream's existing commits represent a *different* shape from the source, not just an older state. When `skills/pr-handoff/SKILL.md` eventually lands, the example pair (this dispatch and `061345Z-result-boatman-bf7290.md`) covers both branches of that wisdom. No structural lesson worth a `message`-to-liaison this time; the existing branch wisdom suffices.
