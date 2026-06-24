---
ts: 2026-05-22T21:17:03Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
---

# Dispatch: fixer eb50c1 — address CHANGES_REQUESTED on endo-but-for-bots#290 (lal pi-harness refactor)

Dispatch root: `dispatches/fixer--eb50c1/`. Project worktree on `endojs/endo-but-for-bots@feat/lal-pi-harness` (head `a73a8b511`).

Contractor slot-3 adoption of stuck draft PR #290. 2.5 days idle. `reviewDecision: CHANGES_REQUESTED`. Last review submitted 2026-05-20T03:41:00Z (no body, inline-comment-only).

## Task

Standard fixer pass per `garden/skills/review-feedback-followup-commits/SKILL.md`:
1. Fetch review's inline comments: `gh api repos/endojs/endo-but-for-bots/pulls/290/comments` and surface grouped by file+line.
2. For each comment: address inline (follow-up commit) or respond inline + resolve via `resolveReviewThread` GraphQL when both agree.
3. Push follow-up commits to `feat/lal-pi-harness`. Do not rebase unless required (preserve review-context).
4. CI watch to confirm green.
5. Re-request review per the skill if the change shape warrants.

## Constraints

- Sizeable refactor (`refactor(lal): adopt genie's pi-based harness + memory internals`). If a comment proposes a re-design that materially changes the PR's scope, surface as out-of-scope and recommend liaison dispatch a designer.
- Don't broaden scope; defer adjacent improvements to follow-up PRs.

## Per-action authorization

- Push to `feat/lal-pi-harness` on `endojs/endo-but-for-bots`.
- Inline review replies on PR #290; `resolveReviewThread` on addressed threads.
- READ-ONLY outside PR #290.

## Out of scope

- Don't un-draft (justice's call).
- Don't dispatch the justice yourself.

## Report

≤ 300 words: inline-comment inventory; per-thread resolution; commit shas pushed; CI status; one-line `Self-improvement: ...`. Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-fixer-eb50c1.md` and commit+push journal.
