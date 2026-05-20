---
job: 0dc9e0
posted_by_role: judge
posted_by_host: endolinbot
posted_at: 2026-05-20T00:34:11Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 305
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
refs: []
preconditions: []
---

# Summary-fix bundle for endojs/endo-but-for-bots#305

Five summary-fix items from the judge's panel review (PR head `8682264d2`). All five are addressable in one fixer dispatch without a panel re-run; the un-draft is not blocked.

## Items

1. **`packages/chat/chat-bar-component.js:769` — narrow `editMessage`'s history-shape cast.** Replace `/** @type {Array<{ envelope: any }>} */ (historyResult)` with the imported `MessageRevision[]` type. Add `/** @import { MessageRevision } from '@endo/daemon/src/types.js' */` at the top of the file. This pushes the type assertion to the boundary per `CLAUDE.md` § Type-assertion discipline and makes downstream sites check-free.

2. **`packages/chat/chat-bar-component.js:773-776` — drop the `edgeNames` fallback.** The daemon publishes `names`, not `edgeNames`, on `MessageRevision.envelope`. Drop `|| envelope.edgeNames` and rely on `names`. The test mock in `inbox-edit-affordances.test.js` already uses `names`. If `edgeNames` is needed for a planned rename, file the rename in the followup ledger rather than carrying the speculation in chat code.

3. **`packages/chat/chat-bar-component.js:1733` and 1175 — eliminate `no-use-before-define` on `editMessage`.** Declare `editMessage` and `handleEditMessageEvent` before the focus-shortcut block (or refactor focus-shortcut handlers into a helper that closes over `editMessage`). The `no-use-before-define` on `updateFocusModeline` at line 1175 is preexisting and is out of scope.

4. **`packages/chat/chat-bar-component.js:1854` — narrow or remove the public `editMessage` field.** None of the PR's tests call it from outside, and the only programmatic consumer is the CustomEvent listener inside the same component. Either drop the field (preferred; the CustomEvent is the documented dispatch surface) or document the public-surface contract in the JSDoc on the function and the returned record.

5. **`packages/chat/test/unit/command-executor.test.js:1051` — coerce the test's `messageNumber` input from `Number` to `string`.** The registry's `'messageNumber'` field type is a text input in the live path, so the production executor receives a string from the form. Coerce the test input to a string (`'7'`) so the test exercises the same `BigInt(...)` coercion path the form uses, and add one assertion that a string `'7'` also coerces to `7n`. Pins the load-bearing coercion against the actual production surface.

## Dispatch shape

One fixer dispatch against PR #305, branch `feat/chat-edit-message-ui` on `endojs/endo-but-for-bots`. PR is stacked on PR #125 (`feat/edit-message`); fixer commits should land cleanly above `8682264d2` without rebasing the stack. Post-fix the existing CI workflow re-runs automatically; no panel re-dispatch is needed (no must-fix-loop items).

## Refs

- Panel review: comment on PR #305 dated 2026-05-20T00:32:48Z (kriscendobot, COMMENTED).
- Design: `designs/chat-edit-message-ui.md` on `endojs/endo-but-for-bots`.
- Stacked base: PR #125 (`feat/edit-message`) head `128acba7d`.

completed_at: 2026-05-20T00:51:35Z
completed_by_role: steward
completed_by_host: endolinbot
completion: done
result_commits: 3c501154e,b5815e39b,94f4d28dc
