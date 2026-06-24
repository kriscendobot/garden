---
ts: 2026-05-15T02:13:17Z
kind: result
role: boatman
project: endo
to: "*"
refs:
  - entries/2026/05/15/020925Z-dispatch-liaison-af033c.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 109
    role: source
  - repo: endojs/endo
    pr: 3256
    role: target
---

Re-ferry of `endojs/endo-but-for-bots#109` over `endojs/endo#3256` complete. Force-pushed a two-commit series onto `feat/syrups-package`, replacing the prior single squash commit `acddddba1` with the restructured shape from the bot side.

**Upstream PR head after force-push**: `b5c3168655a98ef17534cf21bf0d2dcc47332d78`.

**Two new commit SHAs (in order, oldest first)**:

1. `e6b1a611d` feat(syrup-frame): add @endo/syrup-frame package
2. `b5c316865` feat(ocapn): add opt-in syrups framing to TCP-testing netlayer

**Attribution verified**: every commit has `Author: Kris Kowal <kris@cixar.com>` and `Committer: Kris Kowal <kris@cixar.com>`. `git interpret-trailers --parse` returns empty on both commit bodies. A scan of `git log origin/master..HEAD --format=%H%n%B` for `co-authored|generated with|claude|endolinbot|main\.barn` returns no matches. Used the cherry-pick + `git commit --amend --reset-author --no-edit` pattern per `entries/2026/05/15/005114Z-result-boatman-eaabd7.md`.

**Cherry-pick conflicts**: none. The 28-commit upstream gap (including #3257 [bytes]) did not touch the same files the source's two commits did. Both cherry-picks applied cleanly without `Auto-merging` output, despite the dispatch's anticipated conflict surface on `packages/ocapn/*`.

**Source-side cross-link comment**: posted under kriskowal on `endojs/endo-but-for-bots#109`: <https://github.com/endojs/endo-but-for-bots/pull/109#issuecomment-4456292671>. Names the upstream PR (`endojs/endo#3256`), the new head SHA (`b5c316865`), and that the prior squash was unrolled into two commits to mirror the bot-side restructure.

**Title decision**: kept as-is. The existing upstream title (`feat(syrup-frame): add @endo/syrup-frame package and opt-in syrups framing for OCapN TCP-for-testing`) still accurately reflects the PR's substance (the package plus the consumer opt-in), and the commit shape is internal to the PR. The user did not ask for a title update this round; the default no-touch path is the safest choice and avoids creating discordance with the existing body.

**kumavis approval persistence**: APPROVED **persisted across the force-push**. `gh pr view 3256 -R endojs/endo --json reviews,reviewDecision` reports `reviewDecision: "APPROVED"`, with kumavis's `state: "APPROVED"` review (submitted 2026-05-14T02:42:25Z) still in the reviews array. The branch is not protected, so no auto-dismiss fired; the review's `commit.oid` field still references the earlier-SHA (`ed80869d4...`) it was given against, which means the approval is retained as a record rather than re-applied to the new head, but the PR's effective `reviewDecision` is APPROVED.

**Steward-message**: not drafted. The two-commit shape speaks for itself in the PR's commits list, and the existing body still frames the substance correctly. No additional context warrants a comment.

**Upstream PR state**: OPEN, MERGEABLE, isDraft: false. Unchanged from before the re-ferry.

Self-improvement: the dispatch correctly anticipated conflict risk on `packages/ocapn/*` from #3257 [bytes] but conflicts did not in fact materialize, because the new `tcp-test-only.js` framing diff happens to land in regions of the file that the bytes migration did not touch on master; a future boatman fielding a similar "broad upstream gap, narrow consumer diff" can mention this null-conflict outcome alongside the other 26-commit-gap-clean-cherry-pick observation from `005114Z-result-boatman-eaabd7.md` when the boatman skill is eventually extracted, since both data points argue for cherry-pick-first/worry-later rather than pre-emptive merge analysis.
