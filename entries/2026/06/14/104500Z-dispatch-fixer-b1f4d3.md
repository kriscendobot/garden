---
ts: 2026-06-14T10:45:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b1f4d3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
---

# dispatch: fixer — composite tsconfig regen on PR #442

PR #442 CI on `5215d7a26` failed lint with: `Drift detected: packages/daemon/tsconfig.composite.json`. The composite tsconfig generator wasn't re-run after the daemon-cas extraction added a new package-edge from `@endo/daemon` → `@endo/daemon-cas`.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442`, DRAFT, base `llm-c85d618`, head `5215d7a26`.

## Task

In your `project/` worktree at `5215d7a26`:

1. Run `corepack yarn build:types:gen` (or whatever the project's composite-tsconfig regen script is — the error message names it).
2. Verify only `packages/daemon/tsconfig.composite.json` changed (or any other composite tsconfig that's drift-fixed; should be minimal).
3. Verify `corepack yarn build:types:check` now passes.
4. Commit: `chore(daemon): regenerate composite tsconfig for daemon-cas edge`.
5. Push to `feat/daemon-cas-extraction` (append only).
6. Post a brief top-level comment on PR #442 at-mentioning `@kriskowal` with the SHA + note that this completes the composite tsconfig regen after the daemon-cas extraction.

## Authorizations

- Push commit to `feat/daemon-cas-extraction` (append only).
- Top-level summary comment on PR #442.

## Out of scope

- Do NOT touch other files.
- Do NOT un-draft (orchestrator after CI green).

## Deliverable

A `result` entry under `journal/entries/2026/06/14/` naming:

- Pre/post head SHAs.
- The 1 commit SHA.
- The `yarn build:types:check` result.
- PR #442 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: orchestrator un-drafts PR #442 after CI green; then conductor for merge`.

End your turn with a concise summary back to the orchestrator.
