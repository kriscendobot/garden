---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 133
upstream_mirror_repo: null
upstream_mirror_pr: null
created_at: 2026-05-21T12:25:43Z
last_appended_at: 2026-05-21T12:25:43Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#133

Created from the code-panel verdict (23 seats, in-band fallback) on the chat pending-command-queue PR (`feat/chat-pending-commands`).
PR ships phase 1 (the pending region above the command bar, click-to-dismiss errors, fade-out on success) of the chat pending-command-queue design.
Round 1 returned four `must-fix-loop` items, all addressed in commits `743f9bd1f`, `6b6a3c313`, `eac4fb1ee`, `4502fefbd`.
Round 2 terminated; seven deferrals warrant revisit when the PR merges.

## Items

- [ ] **Render per-card elapsed time.**
  **Source juror(s)**: ergonomist.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: open a follow-up PR adding a per-card elapsed-time tick (`0s, 1s, 2s, ...`) updated on a 250ms interval.
  The implementation tracks `startTime: Date.now()` on the entry (`packages/chat/pending-commands.js:171`) but never renders it.
  Rule: `designs/chat-pending-commands.md` § Pending commands region.

- [ ] **Add "show result" affordance on success cards that returned a value.**
  **Source juror(s)**: ergonomist.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: open a follow-up PR exposing a re-open affordance on the card for commands that produced a value (`eval`, `request`).
  The implementation currently auto-displays via `showValue` synchronously when the command resolves but does not expose a re-open affordance on the card after fade-out.
  Rule: `designs/chat-pending-commands.md` § Pending commands region.

- [ ] **Add test coverage for `pending-commands.js`.**
  **Source juror(s)**: prover.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: assayer follow-up dispatch to author `packages/chat/test/component/pending-commands.test.js`.
  Exercises: track-on-success, track-on-failure (correct after round-1 must-fix #2 landed in `6b6a3c313`), helper extraction (`transitionToSuccess` / `transitionToError`), fade-out timing with `t.timeout`.
  The chat package's test/component layout (`test/component/inline-command-form.test.js`, `test/component/send-form.test.js`) is the obvious home.
  Rule: `skills/coverage-driven-testing/SKILL.md` § every new exported factory gets at least one test.

- [ ] **Factor the fade-out / removal timeouts into an injectable scheduler.**
  **Source juror(s)**: prover.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: open a follow-up PR factoring the raw `setTimeout(..., 300)` and `setTimeout(..., 1500)` calls (`packages/chat/pending-commands.js:101-111` and `134-145`) into an injectable `scheduler` parameter to `createPendingCommands`.
  If a test ever needs to fast-forward time, these calls fight `ava`'s clock control.
  Land after the test-coverage follow-up so a test exists that needs to advance them.
  Rule: project CLAUDE.md § Testing with AVA (explicit `t.timeout` for stall regression tests).

- [ ] **Tooltip for long error messages on error cards.**
  **Source juror(s)**: ergonomist.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: open a follow-up PR adding `title="..."` to error cards carrying the full message on hover.
  `packages/chat/pending-commands.js:129` writes the raw `error.message` (or the structured `result.error.message || result.message`) into a span; no escaping is needed because it goes through `textContent`, but if the error message ever carries a long stack trace it overflows the `max-width: 200px` `.pending-command-status` cell silently.
  Rule: `designs/chat-pending-commands.md` § Failure.

- [ ] **Keyboard equivalent for click-to-dismiss on error cards.**
  **Source juror(s)**: ergonomist.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: open a follow-up PR adding `role="button" tabindex="0"` and a keydown listener for Enter/Space on the error card.
  `packages/chat/pending-commands.js:132-145` registers a one-shot click handler on error cards but never registers a keyboard equivalent; cards are not focusable, so a keyboard-only user cannot dismiss a pending error.
  Rule: [proposed-rule] pending-card-style UI elements that accept a click for dismissal should also accept a keyboard equivalent (Enter or Space) on focus.
  The proposed rule is bundled in a `message: panel → gardener` companion to this ledger append.

- [ ] **Confirm chat-package changeset convention with maintainer.**
  **Source juror(s)**: changeset-auditor.
  **Round**: 1 (carried forward to round 2).
  **Recommended action**: maintainer question (no PR action).
  The chat package has no changeset for `@endo/chat`.
  The package is `"private": true`, but `.changeset/config.json` sets `privatePackages.version: true`, so private packages do get versioned.
  The `llm` branch precedent skips changesets for chat-package PRs, so this PR is consistent with the branch's working convention.
  When the bot starts mirroring PRs to `master` (boatman path), the maintainer's policy on whether `@endo/chat` should carry changesets becomes load-bearing.
  Rule: `.changeset/config.json` § privatePackages.version.
