---
ts: 2026-06-08T20:30:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--b2581a
prs:
  - repo: endojs/endo-but-for-bots
    pr: 290
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/290
  - https://github.com/endojs/endo-but-for-bots/pull/290#issuecomment-4653227904
---

# dispatch: fixer — rebase + shepherd PR #290 to green per kriskowal @-mention

Maintainer @-mention on `endojs/endo-but-for-bots#290`
(`refactor(lal): adopt genie's pi-based harness + memory
internals`) at 2026-06-08T20:27:54Z (kriskowal):

> @kriscendobot rebase and shepherd until CI is green.

Eyes reactji (`367265329`) posted before this dispatch.

## State at dispatch time

- **PR #290**, base `llm`, head `feat/lal-pi-harness` at full
  SHA `b5d903d...` (read via gh-api for lease anchor).
- mergeable: **CONFLICTING**, mergeStateStatus: **DIRTY**,
  reviewDecision: CHANGES_REQUESTED, draft: false.
- Current `llm` tip: `11a76ae6` (from #426 merge this cycle).

## Task

In your `project/` worktree on `feat/lal-pi-harness`:

1. **Mint or reuse frozen base** `llm-11a76ae` (existing from
   prior dispatches). Push if missing.
2. **Rebase** onto the frozen base:
   `git fetch origin && git rebase llm-11a76ae`. PR is currently
   CONFLICTING — resolve per
   `skills/conflict-resolution/SKILL.md`.
3. **Force-with-lease push**:
   `git push --force-with-lease=feat/lal-pi-harness:<full-sha-of-b5d903d> origin HEAD:feat/lal-pi-harness`.
4. **Retarget PR base** to `llm-11a76ae`:
   `gh pr edit 290 -R endojs/endo-but-for-bots --base llm-11a76ae`.
5. **Shepherd CI to green**: watch CI propagate; classify
   failures per the four-bucket scheme. For CI-fixables (lint,
   lockfile, format, autofix), push the fix. For fixer-shaped
   beyond surgical scope, surface as `next: fixer` (but this
   dispatch IS the fixer, so iterate until green or escalate).
6. **Reply on PR #290** with the rebase outcome, CI status,
   and any pushes made. The maintainer's directive includes
   "until CI is green" — keep going until green or escalate
   if you hit a real-and-deeper failure that needs liaison.

## Authorizations (per-action, forwarded by steward)

- **Push** frozen-base (if needed) + force-with-lease rebase
  + CI-fixable iterations.
- **Retarget PR base**.
- **Reply comment** on PR #290 + intermediate progress comments
  if useful (`endo-but-for-bots` standing broad-comment
  authorization).
- **Re-enqueue** flake-classified jobs via
  `gh run rerun <id> --failed`.

## Out of scope

- Do NOT trigger panel/judge.
- Do NOT touch other PRs.

## Deliverable

A `result` entry under `journal/entries/2026/06/08/` naming
pre/post head SHAs, the frozen-base ref used, conflict notes,
per-iteration CI-fixable push SHAs, the final CI state, the
reply-comment URL(s), and a `Self-improvement: ...` line.

If you escalate, name the `next: <role>` classification.

End your turn with a concise summary back to the orchestrator.
The orchestrator tears down your dispatch root on return.
