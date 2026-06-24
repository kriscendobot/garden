---
ts: 2026-05-19T23:31:41Z
kind: result
role: builder
worktree: dispatches/builder--f4075c/project
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Built `designs/chat-edit-message-ui.md` per maintainer directive.

PR opened as DRAFT: [endojs/endo-but-for-bots#305](https://github.com/endojs/endo-but-for-bots/pull/305), base `llm`, head `feat/chat-edit-message-ui`, commit `7c668c6e7`.

Stacked on PR #125 (`feat/edit-message`, the daemon-side `editMessage` / `messageHistory` capability re-opened from #23 under the bot), since the design's dependency on those daemon methods is not yet merged to `llm`.  The PR body cites the stack and notes the daemon commits will drop out of the diff once #125 lands.

Files touched:
- `packages/chat/command-registry.js` (new `edit-message` entry + `editmsg` alias; legacy blob `/edit` untouched)
- `packages/chat/command-executor.js` (new `case 'edit-message'` calling `E(powers).editMessage(...)`)
- `packages/chat/chat-bar-component.js` (FOCUS_SHORTCUTS adds `e`; `editMessage(messageNumber)` helper pre-fills the form from `messageHistory`; `chat:edit-message` CustomEvent listener; conditional `<kbd>e</kbd>` in focus-mode modeline)
- `packages/chat/inbox-component.js` (data-sent / data-editable dataset attributes; hover pencil button alongside dismiss x; in-place envelope swap on follow-up emissions with `edited <timestamp>` caption)
- `packages/chat/index.css` (`.edit-button` and `.timestamp-edited` styles)
- `packages/chat/test/unit/command-registry.test.js` (3 new tests: registry shape, alias, legacy `/edit` non-regression)
- `packages/chat/test/unit/command-executor.test.js` (2 new tests: `edit-message` dispatch + bigint coercion, legacy `edit` does not call `editMessage`)
- `packages/chat/test/component/inbox-edit-affordances.test.js` (new file, 4 tests: outgoing settled shows attrs + button, incoming has neither, streaming has data-sent without data-editable or button, click dispatches CustomEvent)

Tests: 9 new (3 + 2 + 4), 433 total in `packages/chat` pass (chat suite ran clean, exit 0).  Local verification:
- `npx prettier --check` clean on all touched files
- `npx eslint` 0 errors (33 warnings, all pre-existing patterns in adjacent code; my changes added no new warnings after typing the `message.done` cast as `{ done: boolean }` instead of `any`)
- `tsc --noEmit -p packages/chat/tsconfig.json` 205 errors before, 205 after (parity)
- Regression-evidence sanity check: flipped `if (isSent)` to `if (false)` in the envelope-attribute block and confirmed 2 of the 4 component tests failed, then restored.

Open questions surfaced (called out in PR body as reviewer questions, design open questions, and the deferred follow-up #203):

1. Slash-command surface (design open question 1): the maintainer's resolution to the `/edit` collision was "overload on referent type".  This PR ships `/edit-message` as a distinct slug + `/edit` unchanged, with the rationale that the load-bearing UI (focus key + hover button) does not depend on the slash surface and an overload can be a follow-up.  Reviewer should pick between (a) keep `/edit-message`, (b) rename to `/revise` or `/amend`, or (c) collapse to `/edit` with type dispatch.
2. Form widget choice: the design says "reuse `send-form.js`" for the body editor; this PR reuses `inline-command-form.js`'s existing `message` field type (which already chip-renders `@`-completions via `tokenAutocompleteComponent`) to keep the diff small.  Easy to swap.
3. Visibility of edit history to recipients (design open question 2) and the rich revision panel: deferred.  Only the inline `edited <timestamp>` caption ships.
4. Per `endojs/endo-but-for-bots#203` (the broader inbox-envelope integration follow-up), this PR delivers the bare in-place swap on edit; the rich progress affordance for partial-stream edits and the cross-envelope-level / channel-layer reconciliation are still in #203's scope.

The orchestrator's PR-creation-flow scan will pick this up DRAFT on its next cycle and run cleaner → judge → fixer-loop → un-draft.

Self-improvement: when a design's listed dependency is on a still-open PR, the role file should explicitly call out the `stacked-pr-build` skill as the right tool rather than (or in addition to) leaving the builder to discover it.  I checked `stacked-pr-build` only after finding that the daemon API wasn't on `llm`; consulting it earlier would have shortened the deliberation about whether to stop at impasse vs. stack.  Will surface this as a message to the liaison in a separate journal entry if the pattern shows up again.
