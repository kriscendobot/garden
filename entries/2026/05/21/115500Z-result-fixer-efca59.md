---
ts: 2026-05-21T11:55:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--efca59/project
---

Addressed kriskowal's CHANGES_REQUESTED review on PR #125 (2026-05-21T11:32:50Z)
covering: the body ask "The TODO comment looks stale. Please check.", inline
3280800932 ("Prettier") on `designs/daemon-message-streaming.md`, and inline
3280806987 ("Follow through on this. We should not land this feature without
its user interface and tests.") on `packages/chat/inbox-component.js`.

Per-ask disposition:

- **Prettier on design doc (inline 3280800932)**: verified no drift.
  `npx prettier --check designs/daemon-message-streaming.md` returns "All
  matched files use Prettier code style!" on `12989def7`. Reply
  https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3280931730
  cites the verification. No commit.

- **Chat UI + tests (inline 3280806987 and body "TODO comment looks stale")**:
  implemented. The inbox renderer now wires the daemon `editMessage` /
  `messageHistory` capability into the local agent's own package messages,
  swaps re-emitted envelopes in place, and stamps `pending` / `edited` CSS
  hooks for `done: false` / post-revision rendering. Removed the stale
  TODO at the addressed line. Two commits:
  - `02dbf50d3` `feat(chat): inbox UI for editMessage / messageHistory` —
    `packages/chat/inbox-component.js` (212 +, 14 -).
  - `12989def7` `test(chat): inbox editMessage and messageHistory affordances` —
    new `packages/chat/test/component/edit-message-inbox.test.js` (475 +).

Test counts: 8 new component-level tests in
`packages/chat/test/component/edit-message-inbox.test.js`, all passing. Full
chat-package suite green: `cd packages/chat && yarn ava` reports 432 tests
passed. ESLint clean on touched files (`yarn lint:eslint` reports 0 errors;
214 warnings are pre-existing, none in my files). Type checker reports only
pre-existing errors (verified by stashing my diff and re-running).

Reply ids: 3280931730 (prettier inline), 3280933614 (follow-through inline).

Cross-cutting decisions:

- The channel-component TODO at `packages/chat/channel-component.js:891`
  was **left in place** rather than addressed. Issue #203's body explicitly
  defers reconciling the new envelope-layer edits with the channel layer's
  existing reply-typed edit model (`packages/chat/edit-queue.js`) to a
  chat-side design doc that has not yet been chosen. Addressing it now
  would force a design decision out-of-band; the TODO accurately describes
  a real, undecided gap and reads as "ongoing follow-up" rather than "stale
  pointer". The follow-through reply on inline 3280806987 documents this.
- The edit affordance is hidden while `done: false` to avoid racing with
  the sender's own streaming update; an agent that wants to amend a
  not-yet-done message can still call `editMessage` directly via the
  daemon API.
- Token bindings (`@edge` / id pairs) on the original message are kept on
  edit when the new text still contains the `@edgeName` reference and
  dropped otherwise. This keeps the simple single-textarea editor honest
  about what the user actually wrote without requiring a richer editor in
  this PR.

Coordination with concurrent fixer (ad3397, makeClient CI fix):

- ad3397 pushed `93e9cd2d0` (`chore(ocapn): skip netlayer-tcp-syrup until
  makeClient port lands`) to `feat/edit-message` between dispatch start and
  push. I rebased onto `93e9cd2d0` (clean rebase; no conflicts) and pushed
  `02dbf50d3..12989def7` on top. Final branch tip: `12989def7`.

Push: `git push origin HEAD:feat/edit-message` accepted at
`93e9cd2d0..12989def7`.

Pre-push gates (`pre-push-gates.sh`): pre-existing probe failures on
`no-inline-import-jsdoc` (`packages/daemon/src/bus-daemon-rust-xs.js`),
`security-md-hash-uniform` (`packages/bytes/SECURITY.md`),
`sentence-per-line-md` (many pre-existing files), and ESLint findings outside
this PR's diff. None of my changes (`packages/chat/inbox-component.js`,
`packages/chat/test/component/edit-message-inbox.test.js`,
`designs/daemon-message-streaming.md`) hit any probe.

CI status / re-request review: deferred. The maintainer's two outstanding
asks on this PR are "Please shepherd" (2026-05-21T11:28:29Z) and the
"TODO/UI/tests" review I just addressed. CI on this branch is in shepherd's
lane, not mine; the steward will dispatch shepherd next. Re-request of
review will follow once CI is green per the fixer norm "drive CI to green
BEFORE re-requesting maintainer review".

Self-improvement: nothing this time.
