---
ts: 2026-05-13T23:33:24Z
kind: dispatch
role: liaison
project: garden
to: "*"
refs:
  - entries/2026/05/13/233119Z-message-steward-b4bb7f.md
---

# Dispatch: gardener records jcorbin maintainer authority on endo-but-for-bots

Dispatch root: `dispatches/gardener--jcorbin-authority-update--20260513-233324--9d9774/`.

kriskowal at `endojs/endo-but-for-bots#148#issuecomment-4445XXX` (2026-05-13T23:27:49Z): "What he said. Josh is a maintainer on endo-but-for-bots."

Task: add `jcorbin` to the recognized-maintainer set for endo-but-for-bots. The current `skills/monitor-endo-but-for-bots/SKILL.md` routes `PullRequestReviewEvent` by `kriskowal` (`CHANGES_REQUESTED` → fixer; `APPROVED` → clear; etc.) and falls through to "other reviewers => journal only." Per kriskowal's explicit recognition, jcorbin's reviews now carry the same maintainer-equivalent weight as kriskowal's. Update:

1. **`skills/monitor-endo-but-for-bots/SKILL.md`**: extend the maintainer-set in the `PullRequestReviewEvent` and `IssueCommentEvent` rules to include `jcorbin`. Update the relevant rule rows so a `jcorbin`-authored review or comment routes the same way kriskowal's does. The senior-contributor (erights) authority structure section established earlier today is a separate concept: jcorbin is a *maintainer*, with maintainer-equivalent authority across the repo; erights is a *senior contributor* with topic-scoped authority. Reflect this distinction in the rule.

2. **`journal/projects/endo-but-for-bots/README.md`** § Authority structure: add jcorbin as a named maintainer alongside kriskowal. The existing erights section stays unchanged (the distinction is real: maintainer authority vs. senior-contributor authority).

3. **`skills/monitor-endo/SKILL.md`**: jcorbin is named as a maintainer on endo-but-for-bots specifically. The user did not state whether the recognition extends to endojs/endo. Default: do not extend; the per-repo recognition is the cleanest read. If you find prior journal entries that suggest jcorbin's role on endojs/endo, surface as a `message` to liaison rather than acting.

## Out of scope

- Do not touch role files (this is per-project skill + project README work).
- Do not retroactively re-process any swallowed jcorbin events.
- Do not extend jcorbin's authority recognition to other repositories without maintainer confirmation.

## Report

Commit SHAs on `main` (monitor skill) and `journal` (project README). One-line confirmation that the next jcorbin event on endo-but-for-bots routes the same as a kriskowal event.
