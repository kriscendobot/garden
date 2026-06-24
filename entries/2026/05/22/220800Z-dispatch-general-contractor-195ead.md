---
ts: 2026-05-22T22:08:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 134
    role: target
---

# Dispatch: fixer 195ead — address CHANGES_REQUESTED on endo-but-for-bots#134 (docker selfhost)

Dispatch root: `dispatches/fixer--195ead/`. Project worktree on `endojs/endo-but-for-bots@feat/docker-selfhost`.

Contractor slot-1 adoption: PR #134 (`feat(docker,daemon): docker self-hosting — foreground daemon, CIDR gate, static files (re-opened from #47 under the bot)`). 10+ days idle. `reviewDecision: CHANGES_REQUESTED`. Substantial feat scope.

## Task

Standard fixer pass per `garden/skills/review-feedback-followup-commits/SKILL.md` + `garden/skills/pr-review-thread-replies/SKILL.md`:
1. Fetch inline comments: `gh api repos/endojs/endo-but-for-bots/pulls/134/comments` and surface grouped by file+line. Also `gh api repos/endojs/endo-but-for-bots/pulls/134/reviews` for review-body level signals.
2. Per thread: address inline (commit) OR respond inline (rationale, resolve via `resolveReviewThread` GraphQL when both agree).
3. Push follow-up commits to `feat/docker-selfhost`. Do NOT rebase unless required (preserve review-context per `garden/skills/rebase-before-followup/SKILL.md`).
4. CI watch (`garden/skills/pr-ci-watch/SKILL.md`).
5. Re-request review per the skill if change-shape warrants.

## Constraints

- Sizeable feat; if a comment proposes a re-design materially changing scope, surface as out-of-scope (recommend liaison dispatch a designer).
- Don't broaden scope; defer adjacent improvements to follow-up PRs.

## Per-action authorization

- Push to `feat/docker-selfhost` on `endojs/endo-but-for-bots`.
- Inline review replies on PR #134; `resolveReviewThread` on addressed threads.
- READ-ONLY outside PR #134.

## Out of scope

- Don't un-draft (justice's call after re-panel).

## Report

≤ 300 words at `/home/kris/dispatches/fixer--195ead/journal/entries/2026/05/22/<HHMMSS>Z-result-fixer-195ead.md`; commit+push origin journal. Cover: inline-comment inventory; per-thread resolution; commit shas; CI status; one-line `Self-improvement: ...`.
