---
ts: 2026-06-17T23:05:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--2314f6
model: sonnet
prs:
  - repo: endojs/endo-but-for-bots
    pr: 452
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/452
  - https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4736281422
---

# dispatch: cleaner — #452 re-gamut on Option A + tests scope

Builder bcdbd8 landed Option A (`fc5fe2271`) + tests
(`12384721d`) at 23:02Z, with isAbandonError answer posted
inline. The PR's expanded scope (peer-formula revocation) now
needs the gauntlet re-run starting at the cleaner stage.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#452`, READY (not draft) — but
  the scope just expanded; the gauntlet's re-run applies.
- **Base** `llm`, head `kriskowal-iroh-heartbeat` at
  `12384721d`.

## Task

In your `project/` worktree at `12384721d`:

1. Read `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md`.
2. Run `pre-push-gates`. Builder noted 2 pre-existing
   `packages/errors` lint errors and pre-existing
   `no-inline-import-jsdoc` / `security-md-hash-uniform` probe
   failures — confirm they predate this PR.
3. Audit PR body (does it now describe Option A + the
   peer-formula revocation contract? if not, update via
   `gh pr edit 452 --body @-`).
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

- Do NOT touch Option A's substance.
- Do NOT touch #449 or #442.
- Do NOT mark PR draft (already ready).

## Deliverable

A `result` entry per the standard cleaner deliverable shape.
End your turn with a concise summary back to the orchestrator.
