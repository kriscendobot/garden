---
ts: 2026-06-14T10:33:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--bbff49
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
---

# dispatch: fixer — surgical prettier fix on PR #442

PR #442 (daemon-cas extraction) CI is 23 SUCCESS / 2 FAILURE; both failures are the `lint` job failing on prettier drift in `packages/registry-capability/types.d.ts` (inherited from PR #403). This is the only thing blocking the un-draft of PR #442 after the appellate + fixer round completed cleanly.

The diff is tiny (9 lines, 2 method signatures collapse to one line each per prettier rules).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442`, DRAFT, base `llm-c85d618`, head `cd7adacd8`.
- **Lint failure on `888951a9f`**: prettier drift in `packages/registry-capability/types.d.ts`.

## Task

In your `project/` worktree at `cd7adacd8`:

1. Run `npx prettier --write packages/registry-capability/types.d.ts`. The diff should be 9 lines (2 method signatures collapse to one-liners).
2. Verify `npx prettier --check packages/registry-capability/types.d.ts` passes.
3. Verify nothing else is touched (`git status` shows only this one file).
4. Run `corepack yarn lint` to confirm clean (or fall back to per-package `eslint` if `yarn lint` would be heavy).
5. Commit: `chore(registry-capability): prettier-format types.d.ts`.
6. Push to `feat/daemon-cas-extraction` (append only).
7. Post a brief top-level comment on PR #442 at-mentioning `@kriskowal`:
   - SHA of the fix.
   - Note that this resolves the lint failure on the inherited registry-capability content (from PR #403); same fix is applicable to PR #403's branch independently.

## Authorizations

- Push commit to `feat/daemon-cas-extraction` (append only).
- Top-level summary comment on PR #442.

## Out of scope

- Do NOT touch any other file (the cleaner already reverted multi-package auto-fix).
- Do NOT also push to PR #403 (separate concern; #403's CHANGES_REQUESTED is unresolved).
- Do NOT mark PR ready (orchestrator un-drafts after CI green).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- The 1 commit SHA.
- pre-push-gates result (informational; the in-scope file should pass cleanly).
- PR #442 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: orchestrator un-drafts PR #442 after CI green; then conductor for merge`.

End your turn with a concise summary back to the orchestrator.
