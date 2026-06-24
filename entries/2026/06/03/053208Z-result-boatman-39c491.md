---
ts: 2026-06-03T05:32:08Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/06/03/052950Z-dispatch-liaison-28c610.md
---

Scrubbed the leaked `Co-Authored-By: Claude Opus 4.8 (1M context)` trailer off endojs/endo#3295 (branch `fix-eslint-projectservice-conflict`). This was a single-commit message rewrite, not a content ferry: only the commit message changed, the tree did not.

- Old head: `d16fbc2d4bbeb0bf76389ae22de7b825f1a44947`
- New head: `809ca5d41aec1020628bf362782fac12fa3cc0f8`
- Tree: identical (`a70ff11c051f2f99f4440053878fb647c4eed92e` before and after).
- Parent: unchanged (`ba26f4cdba760e16aeb0a6265c391dd52cd4c8ea`); no reparenting.
- Author and committer: `Kris Kowal <kriskowal@kriskowal.com>` (override-pinned at amend time via `git -c user.*`).
- `git interpret-trailers --parse` on the new message: empty. The Claude trailer and its now-trailing blank line are gone; the subject and all body lines are byte-identical otherwise.

Push: `git push --force-with-lease=fix-eslint-projectservice-conflict:d16fbc2d4...` landed as `+ d16fbc2d4...809ca5d41 ... (forced update)`. No approval existed on #3295, so nothing was dismissed.

Post-push state: `mergeable: MERGEABLE`, `reviewDecision: REVIEW_REQUIRED` (unchanged: no prior approval). API commit-message readback confirms no `Co-Authored-By` / `Claude` line. CI re-triggered by the head move and is all `pending` (build, cover, lint, the test/test262 matrix, test-xs, test-hermes, test-ocapn-python, viable-release, zizmor, check-action-pins); did not wait.

Title and body left unchanged. No comment posted on endojs/endo. Identity confirmed kriskowal (push: true, admin: true) before pushing.

Cross-link: searched endojs/endo-but-for-bots PRs (title/branch) and recent issue-comments for a `Mirror of ...pull/3295` cross-link posted under the bot identity; none found. No PATCH performed; not hunted further per dispatch.

Self-improvement: nothing structural to land. This ferry is itself the reinforcing evidence for the standing per-commit `interpret-trailers --parse` gate documented in `skills/pr-handoff/SKILL.md` § Trailer-strip discipline: a prior ferry's eyeball inspection let a below-the-fold `Co-Authored-By: Claude` trailer ship to #3295, and only the executable `interpret-trailers --parse` check (run here pre-push and verified post-push via the GitHub API) reliably catches it. The discipline as written already covers this; no edit needed.
