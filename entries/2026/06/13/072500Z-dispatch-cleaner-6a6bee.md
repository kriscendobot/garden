---
ts: 2026-06-13T07:25:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: cleaner
dispatch_root: /home/kris/dispatches/cleaner--6a6bee
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/13/072236Z-result-builder-256add.md
---

# dispatch: cleaner — stage 1 of #440 gamut (formula-inspector daemon+cli cuts)

Continuing the gamut on the fresh DRAFT PR #440 that builder
`256add` opened with cuts 1+2 of the formula-inspector
implementation (daemon `getFormula` + `@info` drop, CLI
`endo inspect` verb). Cut 3 (chat) was DEFERRED at impasse —
master has `packages/goblin-chat`, not `packages/chat` per the
merged design's assumption. Builder surfaced this in PR body's
"Design departures" section.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`
  ("feat(daemon,cli,chat): drop @info name hub for
  formula-inspector design (#439)"), DRAFT, base
  `master-4a04d07`, head `feat/formula-inspector` at
  `121e4b1e6` (per dispatch-prepare). FETCH if newer.

## Task

In your `project/` worktree at `121e4b1e6`:

1. **Read** `garden/skills/pre-pr-checklist/SKILL.md` and
   `garden/skills/pr-formation/SKILL.md`.
2. **Run `pre-push-gates`**. Builder reported PASS after
   fixing 2 findings; verify still clean.
3. **Audit the PR body** against `pr-formation`. The
   "Design departures" section's discussion of the chat
   impasse (cut 3 deferred) is structural and should
   be left untouched.
4. **Audit the diff** against modern hygiene skills:
   - `changeset-discipline` (this is a daemon API change;
     a changeset is likely needed)
   - `em-dash-style`
   - `no-latin-shorthand`
   - `relative-paths`
   - `test-title-spec-spelling`
5. **No rebase** — PR is fresh on current frozen base.
6. **Commit hygiene fixes** per category.
7. **Push** (append push only).
8. **Post a top-level summary** on PR #440 ending with:
   "Next stage: barrister panel."

## Authorizations

- **Push commits** to `feat/formula-inspector` (append push
  only).
- **Edit the PR body** via `gh pr edit`.
- **Top-level summary comment**.

## Out of scope

- Do NOT address cut 3 chat impasse — it's a design-level
  scope decision that needs maintainer routing.
- Do NOT touch source beyond hygiene.
- Do NOT touch PR #441 (separate llm-base PR).

## Deliverable

A `result` entry under `journal/entries/2026/06/13/` naming:

- Pre/post head SHAs.
- Hygiene commits.
- Per-skill audit results.
- pre-push-gates result.
- The top-level summary comment URL.
- **Recommended next stage**: barrister panel.
- A `Self-improvement: ...` line.

End your turn with a concise summary back to the orchestrator. The
orchestrator dispatches the next stage and tears down your
dispatch root on return.
