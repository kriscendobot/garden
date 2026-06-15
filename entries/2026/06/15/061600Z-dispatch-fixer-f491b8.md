---
ts: 2026-06-15T06:16:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--f491b8
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4704746420
  - https://github.com/endojs/endo-but-for-bots/pull/440#pullrequestreview-(kriskowal 2026-06-15T06:15:12Z CHANGES_REQUESTED)
---

# dispatch: fixer — PR #440 review 2 changes per kriskowal

Maintainer's CHANGES_REQUESTED review on PR #440 (kriskowal, 2026-06-15T06:15:12Z) plus prior top-level comment carries 2 asks:

1. **F-symmetric keybind** (kriskowal top-level 2026-06-15T05:07:40Z): "Let's change the accelerator key binding for 'flip to formula' and 'flip to value' symmetric, so F flips either way." Currently F only flips Value → Formula; make it bidirectional.

2. **Changeset update or addition for chat** (kriskowal inline 2026-06-15T05:08:20Z at `.changeset/formula-inspector-getformula.md:1`): "Update to reflect all changes or add additional changeset for chat." The existing changeset covers `@endo/daemon: minor` + `@endo/cli: minor` for the user-observable shape (`EndoHost.getFormula(identifier)` + `@info` removal + `endo inspect`). It does NOT name the chat cut (`@endo/chat` Value modal Formula back face). Decide:
   - Update existing changeset's body to also describe chat surface user-visible changes.
   - OR add a new changeset for chat. NOTE: `@endo/chat` is `"private": true`, so changeset semantics may not apply — verify whether `@endo/chat` even gets changesets in this repo.
   - The maintainer wants ONE of these; pick the cleaner option.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, OPEN, not draft, reviewDecision CHANGES_REQUESTED, base `llm`, head `0407bfb54`.

## Task

In your `project/` worktree at `0407bfb54`:

1. Find the F keybind handler in `packages/chat/value-component.js` (likely a `keydown` listener with `key === 'F'` or `key === 'f'`).
2. Make F bidirectional: pressing F on the value face flips to formula; pressing F on the formula face flips back to value. Update the mode-line hint(s) if any.
3. Update test (`packages/chat/test/component/value-component-flip.test.js`) to cover both directions.
4. Inspect `.changeset/formula-inspector-getformula.md`. If `@endo/chat` is private (check `packages/chat/package.json`), update the body to NOTE the chat surface user-visible changes (not as a separate package row but as a body description). If `@endo/chat` is public, add a new changeset.
5. Run `corepack yarn workspace @endo/chat test`.
6. Run pre-push-gates.
7. Commit per logical group:
   - `fix(chat): make F keybind symmetric for value/formula flip per kriskowal review`
   - `chore(changeset): describe chat surface changes per kriskowal review`
8. Push to `feat/formula-inspector` (append only).
9. Post a brief top-level comment on PR #440 at-mentioning @kriskowal with both SHA + item resolution.

## Authorizations

- Push commits to `feat/formula-inspector` (append only).
- Top-level comment on PR #440.
- Re-request review from kriskowal (this is the response to CHANGES_REQUESTED).

## Out of scope

- Do NOT touch daemon-cas (separate PR #442).
- Do NOT pursue other features.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- 2 commit SHAs.
- File:line for the keybind change + changeset summary.
- Test result.
- pre-push-gates result.
- PR #440 comment URL + re-request-review URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: liaison` (maintainer re-reviews).

End your turn with a concise summary back to the orchestrator.
