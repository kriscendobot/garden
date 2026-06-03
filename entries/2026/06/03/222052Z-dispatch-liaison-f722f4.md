---
ts: 2026-06-03T22:20:52Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: conductor
dispatch_root: /home/kris/dispatches/conductor--f722f4
prs:
  - repo: endojs/endo-but-for-bots
    pr: 400
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/400
---

# dispatch: conductor — #400 merge

kriskowal APPROVED PR #400 (`groom: rebucket roadmap for
shortest-route MCP-bridge gateway`) at 2026-06-03T22:20:24Z
(review `4423229570`, empty body).

Per memory `feedback_approved_pr_dispatches_conductor.md`,
APPROVED PRs dispatch to conductor.

## Target

- PR: endojs/endo-but-for-bots#400
- Head: `956500ad7` (the renumbering applied by fixer
  `0b44dc`).
- Base: `llm`.
- State: DRAFT? — verify in worktree. If still DRAFT, un-draft
  before merging.

## Per-action authorizations

- `gh pr ready 400` if needed (un-draft). Authorized.
- Merge per the conductor's canonical norm. (Per memory
  `feedback_no_merge_method_in_conductor_prompts.md`, this
  dispatch does NOT name the merge method.) Authorized.

## Not authorized

- Force-pushing.
- Re-drafting.
- Closing without merging.

## Dispatch protocol

Read in order:

1. `/home/kris/dispatches/conductor--f722f4/garden/roles/COMMON.md`
2. `/home/kris/dispatches/conductor--f722f4/garden/roles/conductor/AGENT.md`
3. Other skills referenced just-in-time.

Project worktree at `project/` on `groom/mcp-bridge-rebucket`
(head `956500ad7`).

## Report

A `result` journal entry. Include:

- Merge SHA on `llm`.
- Merge method used.
- Whether un-draft was needed.
- Branch cleanup status.
