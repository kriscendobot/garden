---
ts: 2026-06-15T05:09:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--ad6fd9
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4704746420
  - https://github.com/endojs/endo-but-for-bots/pull/440
---

# dispatch: fixer — symmetric F keybind on PR #440

Maintainer directive on PR #440 (kriskowal, 2026-06-15T05:07Z):

> Let's change the accelerator key binding for "flip to formula" and "flip to value" symmetric, so F flips either way.

Currently `F` only flips Value → Formula (per builder's cut 3 design). The maintainer wants `F` to be bidirectional: F flips Value → Formula AND Formula → Value.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#440`, OPEN (un-drafted), base `llm`, head `0407bfb54`.

## Task

In your `project/` worktree at `0407bfb54`:

1. Read `packages/chat/value-component.js` to find the F keybind handler. It's likely a `keydown` listener that responds to `key === 'F'` or `key === 'f'` only when the value face is active.
2. Make F bidirectional: pressing F on the value face flips to formula; pressing F on the formula face flips back to value.
3. Update the design-doc reference if any (the mode-line hint "F = flip to formula" should remain accurate; if a separate hint exists for the back face, it should also reflect F).
4. Update the test (`packages/chat/test/component/value-component-flip.test.js`) to cover both directions.
5. Run `corepack yarn workspace @endo/chat test` to verify.
6. Run pre-push-gates from project/.
7. Commit: `fix(chat): make F keybind symmetric for value/formula flip per kriskowal #issuecomment-4704746420`.
8. Push to `feat/formula-inspector` (append only).
9. Post a brief top-level comment on PR #440 at-mentioning `@kriskowal` with the SHA and resolution.

## Authorizations

- Push commit to `feat/formula-inspector` (append only).
- Top-level summary comment on PR #440.

## Out of scope

- Do NOT touch daemon or CLI substance (this is chat-only).
- Do NOT change other keybinds (Escape, Shift+P) unless they share the handler and need symmetric treatment.
- Do NOT re-draft.

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- The 1 commit SHA.
- File:line for the keybind change.
- Test result.
- pre-push-gates result.
- PR #440 comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: orchestrator monitors CI; then conductor for merge after kriskowal approves`.

End your turn with a concise summary back to the orchestrator.
