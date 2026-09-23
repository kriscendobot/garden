---
ts: 2026-06-08T22:56:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--aed1f5
prs:
  - repo: endojs/endo-but-for-bots
    pr: 131
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/131
  - https://github.com/endojs/endo-but-for-bots/pull/131#issuecomment-4654234589
---

# dispatch: fixer — refresh PR #131 title + description per kriskowal directive

Maintainer comment on `endojs/endo-but-for-bots#131` at
2026-06-08T22:46:47Z (kriskowal):

> Please refresh the pull request title and description in
> preparation for stating the record of what has changed. Omit
> details of the process of building the change.

This is a PR-shell maintenance task: refresh the title to
describe substance only; drop process-detail from title and
body (e.g., the "(re-opened from #41 under the bot)" suffix and
any build-process narrative in the body).

## Task

1. **Read** the current PR title and body:
   `gh pr view -R endojs/endo-but-for-bots 131 --json
   title,body`.
2. **Rewrite the title** to describe substance only. Current:
   `feat(chat): inventory drag-and-drop, cancel, type badges
   (re-opened from #41 under the bot)`. Drop the parenthetical.
3. **Rewrite the body** to state what has changed. Omit
   process detail (re-opening history, rebases, cleaner notes,
   etc.). Keep cross-references that are substantive (linked
   issues, designs).
4. **Apply**: `gh pr edit 131 --title <new> --body <new>`.

## Authorizations (per-action, forwarded by steward)

- **Edit PR title and body** via `gh pr edit 131`. Implicit in
  the "refresh title/description" framing.
- **Reply comment** acknowledging the refresh and citing the
  new shape (`endo-but-for-bots` standing broad-comment
  authorization).

## Out of scope

- Do NOT push commits to the branch.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming
the before/after title and body summaries (or full text),
reply-comment URL, and `Self-improvement: ...`.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
