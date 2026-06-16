---
ts: 2026-06-16T03:55:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--32650e
prs:
  - repo: endojs/endo-but-for-bots
    pr: 435
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/435
  - https://github.com/endojs/endo-but-for-bots/pull/435#pullrequestreview-4502549835
---

# dispatch: fixer — apply erights' 29 inline asks on PR #435 immutable-arraybuffer

Reviewer erights (Mark Miller) submitted CHANGES_REQUESTED on PR #435 at 2026-06-16T03:53:54Z, review id 4502549835. 29 inline comments on `packages/immutable-arraybuffer/` (mostly DESIGN.md + adjacent source).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#435`, OPEN, head `448fa0298`.
- **Title**: feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic (per DESIGN.md)

## Task

In your `project/` worktree at `448fa0298`:

1. Read the full review body + every inline comment:
   - `gh api repos/endojs/endo-but-for-bots/pulls/435/reviews/4502549835` for the top-level body.
   - `gh api repos/endojs/endo-but-for-bots/pulls/435/comments --jq '[.[] | select(.pull_request_review_id == 4502549835)]'` for the 29 inline asks.
2. For each inline ask, apply the requested change (most are documentation refinements per the early samples — variable renames, missing constants, diagnostic improvements). When erights uses GitHub's suggestion blocks (` ```suggestion ... ``` `), apply the suggested literal text.
3. For each ask, the threaded reply should:
   - Address the substantive change.
   - Reply on the inline thread acknowledging + linking the addressing SHA.
4. Run `corepack yarn workspace @endo/immutable-arraybuffer test`.
5. Run pre-push-gates.
6. Commit per logical group (probably one commit per source/test file touched, OR one cohesive commit per topical theme erights organized — read the inline comments to find the right grouping).
7. Push to `build/immutable-arraybuffer-drop-the-pseudo-prototype` (append only).
8. Post a top-level comment on PR #435 at-mentioning @erights AND @kriskowal:
   - Per-ask resolution table.
   - All commit SHAs.
   - Notes on any asks that were declined (with rationale).
9. Re-request review from erights.

## Authorizations

- Push to `build/immutable-arraybuffer-drop-the-pseudo-prototype` (append only).
- Reply to inline review threads.
- Top-level summary comment.
- Re-request review (erights).
- Do NOT touch upstream endojs/endo.

## Out of scope

- Do NOT modify substance not asked for.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/16/` naming:

- Pre/post head SHAs.
- Per-ask resolution mapping (file:line + commit SHA).
- Any declined asks + rationale.
- Test results.
- pre-push-gates result.
- PR #435 inline reply URLs + top-level comment URL + re-request review URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (erights re-reviews + decides).

End your turn with a concise summary back to the orchestrator.
