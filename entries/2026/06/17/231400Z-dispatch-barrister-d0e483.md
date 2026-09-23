---
ts: 2026-06-17T23:14:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: barrister
dispatch_root: /home/kris/dispatches/barrister--d0e483
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736335535
---

# dispatch: barrister — #452 code-panel (Option A + tests scope)

Cleaner 2314f6 completed at 23:13Z. Now the barrister runs the
code-panel on the expanded scope (heartbeat + Option A
peer-formula revocation + tests).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#452`, READY, base `llm`,
  head `kriskowal-iroh-heartbeat` at `b7d23855e`.

## Task

In your `project/` worktree at `b7d23855e`:

1. Read `garden/roles/barrister/AGENT.md` and panel skills.
2. Run `panel-hints.sh` (the script will likely classify as
   code-panel given the `.js` source changes; trust it).
3. Run the code-panel per
   `garden/skills/panel-review/SKILL.md` (canonical 26 seats +
   2 cross-panel; in-band fallback if no `Agent` tool).
4. Submit the verdict via `gh pr review 452 --comment --body @-`
   (self-authored PR; `--request-changes` blocked).
5. Aggregate dispositions; recommend next stage.

## Authorizations

- Submit review on PR #452 (`--comment` only).
- Append summary-fix / follow-up entries as needed.

## Out of scope

- Do NOT dispatch a fixer yourself; recommend `next: fixer` or
  `next: justice` and the orchestrator decides.
- Do NOT mark PR draft.
- Do NOT touch #442, #449, #451.

## Deliverable

A `result` entry per the standard barrister deliverable shape.
End your turn with a concise summary back to the orchestrator.
