---
ts: 2026-05-22T01:37:28Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: fixer
prs:
  - repo: endojs/endo
    pr: 3274
    role: source
  - repo: endojs/endo-but-for-bots
    pr: 67
    role: mirror
---

# Dispatch: fixer carries feedback from endojs/endo#3274 onto endo-but-for-bots#67

Dispatch root: `dispatches/fixer--8253c6/`. Project worktree on `endojs/endo-but-for-bots@design/issue-2390-harden-exports-patterns` (head `7ddcfa486`).

Maintainer directive (2026-05-22): *"Please respond to feedback on https://github.com/endojs/endo/pull/3274 at our mirror of that PR in endo-but-for-bots"*

## Upstream and mirror state

- Upstream: `endojs/endo#3274` — "fix(eslint-plugin): harden-exports handles destructuring patterns (#2390)" by kriskowal, base `master`.
- Mirror: `endojs/endo-but-for-bots#67` — same title, base `master`, branch `design/issue-2390-harden-exports-patterns`. **NOT draft** (the gauntlet has already run).
- Upstream feedback: 3 inline comments + 2 reviews (copilot bot, turadg). Substantive enough to address.

## Task

1. Read `garden/roles/COMMON.md`, then `garden/roles/fixer/AGENT.md`.
2. Read `garden/skills/review-feedback-followup-commits/SKILL.md` (canonical: follow-up commits on top, one concern per commit; lockfile separate; do not amend), `rebase-before-followup/SKILL.md`.
3. Enumerate upstream feedback: `gh api repos/endojs/endo/pulls/3274/comments --paginate` and `gh api repos/endojs/endo/pulls/3274/reviews --paginate`. Distinguish in-scope from out-of-scope.
4. For each in-scope item, apply a follow-up commit on top of `design/issue-2390-harden-exports-patterns`. Conventional-commit messages cite the upstream review-comment URL.
5. **The mirror PR #67 is NOT draft.** That means the gauntlet has already run. Follow-up commits land on top of the un-drafted PR; no re-draft is needed.
6. Local validation: package tests for `packages/eslint-plugin/`, `yarn lint`, `yarn docs`, pre-push-gates.
7. Push to `endojs/endo-but-for-bots:design/issue-2390-harden-exports-patterns`. Non-force unless rebasing.
8. **Do NOT** reply on upstream review threads (boatman handles). **Do NOT** comment on the bot mirror PR.

## copilot-pull-request-reviewer treatment

Copilot's review is automated. Treat each item on its technical merits: apply if substantive and correct, skip with a one-line "rejected: <reason>" if spurious. Do not treat the bot's review as a maintainer-level directive.

## Per-action authorization

Push to `design/issue-2390-harden-exports-patterns`. READ-ONLY on endojs/endo. No comments anywhere.

## Report

≤ 400 words. Number of in-scope items addressed with one-line summary each (cite upstream comment URLs). Out-of-scope items with reasons. Follow-up commit SHAs with messages. Final head SHA. Test status. One-line `Self-improvement: ...`. Write result as `journal/entries/2026/05/22/<HHMMSSZ>-result-fixer-8253c6.md` and push journal (rebase if non-fast-forward).
