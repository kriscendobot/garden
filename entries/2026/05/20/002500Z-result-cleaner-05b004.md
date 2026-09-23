---
ts: 2026-05-20T00:25:00Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/cleaner--05b004/project
---

Cleaner pass for PR #305 (`feat/chat-edit-message-ui`, stacked on #125).

Change-of-interest scope (diff against #125 head `128acba7d`):
`packages/chat/{chat-bar-component,inbox-component,command-executor,command-registry,index.css}.js,css`
plus three assayer-authored test files under `packages/chat/test/`.

Findings:

- The builder + assayer left strong unit coverage on the two
  small new files (`command-executor.js` edit-message case;
  `command-registry.js` entry shape) and three component cases on
  `inbox-component.js` (data-sent / data-editable attributes, the
  pencil button visibility, the click event).
- The single largest uncovered branch in the diff was the
  swap-on-edit path in `inbox-component.js` lines 884-910 (the
  load-bearing followMessages re-emission handling that distinguishes
  this PR from #125's mid-stream TODO state).  Neither the
  swap-vs-append branch nor the focused-class preservation across
  the swap was exercised.
- The chat-bar-component.js additions (~131 lines: editMessage helper,
  the e key focus-mode hook, modeline e hint, document event listener)
  have no AVA coverage at all because no test imports
  chat-bar-component.js.  Building a chat-bar test rig is a builder /
  assayer scope item (the component takes a deep send-form +
  command-mode dependency graph that mocking would require a from-
  scratch test fixture), so this is surfaced as out-of-scope for the
  cleaner pass rather than papered over with a contortion test.  The
  e2e Playwright suite ships separately and is the natural home.

Cleaner-added test: extended
`packages/chat/test/component/inbox-edit-affordances.test.js` with a
`makePackagePowersFromList` helper (multiple sequential emissions
from the mock followMessages) and two new cases:

1. `re-emission of a package message swaps the envelope in place
   rather than appending` — pins the prior-envelope lookup and
   replaceWith, plus the timestamp-edited caption.
2. `focus state survives a swap-on-edit` — pins the
   `wasFocused` / `classList.add('focused')` branch.

Regression-evidence note: temporarily replacing the swap predicate
with `if (false && $prior)` made both new tests fail (two envelopes
per number; focused class lost).  Reverting passed both.  Existing
433 tests still pass; chat-package suite is now 435 tests.

Coverage on `inbox-component.js` (statements / branches):
  baseline (assayer)   53.26% / 66.10%
  with cleaner pass    55.32% / 67.74%

Coverage on `command-executor.js` (assayer-only, no cleaner add):
  65.98% / 72.89% on the package-touched surface; the new
  `edit-message` case at lines 213-235 is fully covered.

Coverage on `command-registry.js` (assayer-only):
  100% / 91.17%; the new `edit-message` entry is fully covered.

No dead-code deletions (the PR adds new entry points; nothing in the
diff is unreachable).  No `chore: Update yarn.lock` commit needed
(the diff added no dependencies).

Commit: `8682264d2 test(chat): cover swap-on-edit in inbox-component
(cleaner pass)` pushed to `feat/chat-edit-message-ui`.

Push result: clean fast-forward; CI converged green on the cleaner's
HEAD (25 / 25 checks passing; PR still `MERGEABLE` and `isDraft:
true`).

PR is judge-ready.  The PR is a source-touching PR (paths under
`packages/chat/`), so the judge will pick the code panel of seventeen
seats.

Self-improvement: nothing this time.  The dispatch arrived with a
clean stacked-PR brief, the cleaner skill was directly applicable,
and the coverage-gap analysis surfaced the highest-value branch on
the first pass.
