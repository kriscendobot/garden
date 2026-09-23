---
ts: 2026-06-14T08:42:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--5c4828
prs:
  - repo: endojs/endo-but-for-bots
    pr: 442
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/442
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/14/083800Z-result-builder-ef91a0.md
---

# dispatch: cleaner — stage 1 of #442 gamut (daemon-cas extraction)

Continuing gamut on freshly-opened PR #442 (daemon-cas
extraction; sibling-PR on top of #403).

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#442`, DRAFT, base
  `llm-c85d618`, head `feat/daemon-cas-extraction` at
  `d2d3e11b9`.

## Task

In your `project/` worktree at `d2d3e11b9`:

1. Read `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md`.
2. Run `pre-push-gates`. Builder reported ASCII-in-source
   probe clean.
3. Audit PR body.
4. Audit diff per hygiene skills (changeset, em-dash,
   no-latin-shorthand, relative-paths,
   test-title-spec-spelling).
5. Push hygiene fixes per category.
6. Post top-level summary comment ending with "Next stage:
   barrister panel."

## Authorizations

- Push commits (append only).
- Edit PR body via `gh pr edit`.
- Top-level summary comment.

## Out of scope

- Do NOT touch the daemon-cas extraction substance.
- Do NOT touch PR #403 directly.

## Deliverable

A `result` entry per the standard cleaner deliverable shape.
End your turn with a concise summary back to the orchestrator.
