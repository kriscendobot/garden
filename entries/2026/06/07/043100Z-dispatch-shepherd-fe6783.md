---
ts: 2026-06-07T04:31:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: shepherd
dispatch_root: /home/kris/dispatches/shepherd--fe6783
prs:
  - repo: endojs/endo-but-for-bots
    pr: 426
    role: target
refs:
  - entries/2026/06/07/034908Z-result-fixer-f1fc5f.md
  - entries/2026/06/07/043000Z-result-steward-403-423.md
  - https://github.com/endojs/endo-but-for-bots/pull/426
---

# dispatch: shepherd — fix #426 residual lint (numeric-separators-style on 9p-server/server.js)

PR #426's prior fixer dispatch `f1fc5f` added eslint-plugin-unicorn
to root devDeps, which resolved 4 of 5 originally-failing checks.
One lint failure remains, but with a different root cause: the
unicorn plugin is now resolving cleanly and flagging actual code
violations.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#426`, DRAFT, base `llm`, head
  `merge/actual-master-into-llm-20260606` at `1d0f019` (full SHA:
  `1d0f019a6...`). 24 SUCCESS, 1 FAILURE (lint), 0 IN_PROGRESS.
- **Failing check**: `lint`
  (https://github.com/endojs/endo-but-for-bots/actions/runs/27081909650/job/79929282727).
- **Root cause** (from the log tail):
  - `packages/9p-server/src/server.js:47:23`
    `unicorn/numeric-separators-style` ERROR — *"Invalid group
    length in numeric value"*.
  - `packages/9p-server/src/server.js:49:18`
    `unicorn/numeric-separators-style` ERROR — *"Invalid group
    length in numeric value"*.

Two numeric literals in `9p-server/src/server.js` violate the
unicorn-style rule that the rest of the codebase satisfies.
Autofixable via `--fix` or by hand. Classify as **CI-fixable**.

## Task

In your `project/` worktree (currently at `merge/actual-master-into-
llm-20260606`):

1. **Fetch + reset to current tip**: `git fetch origin` and
   `git reset --hard origin/merge/actual-master-into-llm-20260606`
   (the dispatch-prepare snapshot may have cached an earlier
   head). Confirm HEAD is at `1d0f019a6`.
2. **Read the two flagged lines** in
   `packages/9p-server/src/server.js`:47 and :49. Identify the
   numeric-literal pattern that's flagged.
3. **Apply the fix**:
   - Run `corepack yarn workspaces foreach -A --from
     '@endo/9p-server' run lint --fix` (or the equivalent
     command per the repo's lint setup) to autofix. If autofix
     doesn't cover the unicorn rule, edit by hand following the
     pattern of adjacent numeric literals in the same file (the
     other underscores tell you the expected grouping).
4. **Verify locally**: `corepack yarn workspaces foreach -A --from
   '@endo/9p-server' run lint` should now exit clean (or at least
   pass without ERROR-level findings).
5. **Commit**:
   - `style(9p-server): apply unicorn/numeric-separators-style
     autofix` (or `fix(9p-server): ...` if the violations are
     substantive). Single commit; no separate yarn.lock chore
     needed since this is source-only.
6. **Push**: `git push origin HEAD:merge/actual-master-into-llm-
   20260606` (regular append push, no force).
7. **Post a top-level summary comment** on PR #426 citing the new
   commit SHA, noting CI is now expected to converge green, and
   nodding to the fact that PR #423's failures share the same
   unicorn cascade (PR #423 will resolve once #426 merges into
   `llm`).

## Authorizations (per-action, forwarded by steward)

- **Push** to `merge/actual-master-into-llm-20260606`. Standard
  shepherd authority for CI-fixables.
- **Top-level summary comment** on PR #426
  (`endo-but-for-bots` standing broad-comment authorization).
- **Re-enqueue** via `gh run rerun --failed` if you classify any
  residual failure as a flake.

## Out of scope

- Do NOT touch any other package.
- Do NOT amend the PR's prior commits.
- Do NOT shepherd PR #423 (it'll resolve via the #426-merge flow
  once #426 lands).

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming the
fix commit SHA, the diff (two-line change expected), the post-fix
CI convergence state, the summary-comment URL, and
`Self-improvement: ...`.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
