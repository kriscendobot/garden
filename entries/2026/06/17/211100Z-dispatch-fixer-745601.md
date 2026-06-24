---
ts: 2026-06-17T21:11:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--745601
prs:
  - repo: endojs/endo-but-for-bots
    pr: 449
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/449#issuecomment-4735477238
---

# dispatch: fixer — apply erights' 3 design decisions on PR #449

erights answered the 3 open questions on PR #449 (2026-06-17T21:07Z):

1. **"delayed" = sequencing** ✅ (designer's assumption was right; no change needed beyond removing the open-question item).
2. **Two design files with parallel naming**: rename existing `packages/immutable-arraybuffer/DESIGN.md` → `DESIGN-immutable-arraybuffer.md` so the new sibling is `DESIGN-freezable-typedarray.md`.
3. **`[Symbol.toStringTag]`: option (b)** — defer to genuine TypedArray tag. Accepts the regression-risk hazard for simplicity ("happy not to add complexity to avoid it until we find out if it is an actual problem").

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#449`, DRAFT, head `d8b8a93fb`, base `master`.
- **master-4a04d07** has PR #435 merged at `855a8f7bc`.
- **live master** still at `4a04d078b` (will catch up via conductor unfreeze pass later).

NOTE: the rename of `packages/immutable-arraybuffer/DESIGN.md` → `DESIGN-immutable-arraybuffer.md` requires the file to EXIST in the base branch. PR #449's base is `master` (head `4a04d078b`) which does NOT yet have the file (only master-4a04d07 has it). So:
- Option A: Re-base PR #449 onto `master-4a04d07` (where DESIGN.md exists post-#435).
- Option B: Wait for live master to unfreeze; do the rename then.
- Option C: Add the rename to PR #449 anyway, expecting it to apply once master catches up.

**Choose Option A** — re-base PR #449 onto `master-4a04d07` (PR #435 is the design's premise).

## Task

In your `project/` worktree at `d8b8a93fb`:

1. Re-base PR #449's branch onto `master-4a04d07` (which has #435's DESIGN.md). Resolve any conflicts.
2. Apply decisions:
   - **Rename** `packages/immutable-arraybuffer/DESIGN.md` → `packages/immutable-arraybuffer/DESIGN-immutable-arraybuffer.md` (use `git mv` so history preserves).
   - **Update README.md** to reference the renamed `DESIGN-immutable-arraybuffer.md` instead of `DESIGN.md`.
   - **Update PR #449's own `DESIGN-freezable-typedarray.md`** to:
     - Replace "Open question 1" answer: confirmed sequencing.
     - Replace "Open question 2" answer: parallel-naming sibling files.
     - Replace "Open question 3" answer: option (b), defer to genuine TypedArray tag.
   - If the design doc has any `[Symbol.toStringTag]` discussion in implementation/semantics sections that defaulted to option (a), update to option (b).
3. Update PR base via `gh pr edit 449 --base master-4a04d07`.
4. Update PR body via `gh pr edit 449 --body ...` to remove the open-questions section (now resolved).
5. Commit per logical step:
   - `chore(immutable-arraybuffer): rename DESIGN.md to DESIGN-immutable-arraybuffer.md per erights`
   - `design(immutable-arraybuffer): incorporate erights' decisions on open questions 1, 2, 3`
6. Force-push with lease (rebase necessary).
7. Post a top-level comment on PR #449 at-mentioning @erights @kriskowal:
   - Summary of decisions applied + SHAs.
   - Note PR is now ready for design panel.

## Authorizations

- Force-push with lease to `design/immutable-arraybuffer-freezable-typedarray-emulation`.
- `gh pr edit` for base and body.
- Top-level comment.
- Do NOT un-draft (judge does that after panel).

## Out of scope

- Do NOT touch upstream endojs/endo.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/17/` naming:

- Pre/post head SHAs.
- Rebase outcome.
- Per-decision file changes + commit SHAs.
- PR #449 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: solicitor` for the design panel.

End your turn with a concise summary back to the orchestrator.
