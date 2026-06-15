---
ts: 2026-06-15T06:17:51Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/15/061309Z-dispatch-liaison-059a74.md
---

Shape-2 re-ferry of the retconned bots#401 onto endojs/endo#3300 (`kriskowal-shellcheck-ci`). Pure structure-only regroup: the bot retconned the shellcheck mirror from a 5-commit shape to a clean 4-commit shape with byte-identical net content, and this ferry replaced #3300's 5-commit structure with the 4.

**Recompute.** Detached at `origin/master` (315533fff, verified via `git ls-remote origin refs/heads/master` against `rev-parse`). Cherry-picked the 4 source commits (d762ce7e8, 4dec008e9, 0bdb4a70b, f5d63b525; source base master-4a04d07 = 4a04d078b) in order. **No conflicts** despite the source base lagging current master: the `.sh` cleanups and the shellcheck-add commit (ci.yml, package.json, scripts/shellcheck.sh) applied clean, so no mechanical re-derivation was needed.

**Attribution + trailers.** Normalized author AND committer of all 4 to `Kris Kowal <kriskowal@kriskowal.com>` via `git rebase --exec 'commit --amend --reset-author --no-edit'` under the `-c user.name/email` override of the bot-identity pin. Source messages were already clean (no `(#401)` suffix, no Co-Authored-By / Generated-with trailers). Trailer gate: `interpret-trailers --parse` EMPTY for all 4. Subjects free of `(#401)`.

**Net-diff fidelity.** `git diff origin/master..HEAD`: 76 content lines, 10 files. Sorted `+`/`-` content hunks are byte-identical to `git diff 4a04d078b..f5d63b525` (the source net diff). Confirms the regroup carried the same content.

**Force-push.** `git push --force-with-lease=kriskowal-shellcheck-ci:d797661b651ddc786262719d574fe0ecdbffa39f` succeeded: `d797661b6...dc41d1d6f (forced update)`. Lease against the prior 5-commit tip held. New #3300 head: **dc41d1d6f4cdd1b3d5933c8c53a5d3d5f304eb0a**.

**Post-push state.** `gh pr view 3300`: 4 commits, MERGEABLE, reviewDecision CHANGES_REQUESTED. The CHANGES_REQUESTED is turadg's prior review persisting (endo's branch protection did not dismiss it on force-push; no approval existed to dismiss). Title/body left unchanged; review not re-requested. CI re-running fresh on the new head (zizmor pass; all else pending at report time).

**Cross-link.** Edited garden-side comment id 4645026707 on endo-but-for-bots#401 in place: `Mirror of https://github.com/endojs/endo/pull/3300 (head dc41d1d6f).` (was head 19e4194d2). No upstream-side comment posted; no review re-requested.

Self-improvement: nothing this time. The dispatch was a textbook Shape-2 recompute with a clean cherry-pick; pr-handoff § Shape 2 and § Trailer-strip covered every step, and the verify-tracking-ref precondition (ls-remote vs rev-parse) confirmed the bare clone's master ref was current.
