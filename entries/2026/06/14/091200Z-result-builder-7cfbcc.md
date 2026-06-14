---
ts: 2026-06-14T09:12:00Z
kind: result
role: builder
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: liaison
dispatch_root: /home/kris/dispatches/builder--7cfbcc
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: head
    branch: feat/formula-inspector
    base: llm
refs:
  - entries/2026/06/14/084500Z-dispatch-builder-7cfbcc.md
  - entries/2026/06/14/085200Z-result-investigator-b25691.md
  - entries/2026/06/13/072236Z-result-builder-256add.md
  - https://github.com/endojs/endo-but-for-bots/pull/440
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701290208
---

# result: builder - chat cut 3 (Value modal Formula back face) landed on PR #440

## Summary

Landed the deferred chat-side cut of the formula-inspector design (PR #440), now reachable on the `llm` base after the weaver rebased cuts 1+2 onto the roadmap branch.
Four commits added on top of `f01499f1a`.
Tests: 35 new passing; full chat-package ava suite 496 / 496.

The chat surface adds a single Value modal back face (the Formula view).
It is reachable via `F`, the modal-header gear icon, or a new per-row gear icon on every inventory row.
Stack-model navigation with `Backspace` pop and no cycle unwinding, per the design's principle-of-least-surprise ruling.

## Commits

| SHA | Subject |
|---|---|
| `e894ffc09` | feat(chat): Value modal Formula back face with card-flip (#439) |
| `3e5f44604` | chore(chat): replace gear character literal with String.fromCodePoint (#439) |
| `b446f5cc3` | test(chat): cover Formula back face, flip, back-stack, gear icon (#439) |
| `ab50308a3` | chore(chat): prettier-format formula-inspector cut 3 files (#439) |

## Files

```
packages/chat/formula-view-registry.js                                new (~260 lines)
packages/chat/formula-view-component.js                               new (~210 lines)
packages/chat/value-component.js                                      edit (+300 / -25)
packages/chat/inventory-component.js                                  edit (+50)
packages/chat/chat.js                                                 edit (+45 / -10)
packages/chat/index.css                                               edit (+240)
packages/chat/test/unit/formula-view-registry.test.js                 new (7 cases)
packages/chat/test/component/formula-view-component.test.js           new (8 cases)
packages/chat/test/component/value-component-flip.test.js             new (9 cases)
packages/chat/test/component/inventory-component.test.js              edit (+2 cases)
packages/chat/test/e2e/formula-inspector.spec.ts                      new (6 fixme stubs)
```

## Behavior pinned by the test suite

- `F` flips the modal between front and back; calling `getFormula` lazily.
- Per-modal-session FormulaRecord cache so flip-flip-flip is one round-trip per id.
- Reference buttons labeled by the formula's property name (eval -> `worker`), not by the target's pet name.
- Reference-list entries labeled by entry key (endowments -> codeName), preserving the design's truthfulness rule.
- Escape on front face closes; Escape on back face flips to front (Escape Consistency).
- Backspace on back face pops the back-stack; the stack is per-modal-session, dropped on close.
- `Shift+P` Enter Profile when the front-face button is visible; no-op otherwise.
- `F` ignored when keyup target is a form input (so typing `F` into the rename input does not flip).
- Per-row gear icon opens the Value modal already flipped (focusValueFormula path), falls back gracefully when no formula handler supplied.
- Keypair back face renders publicKey but explicitly suppresses any privateKey literal with a "Private key not displayed" note.
- Stack hint (`stack N/M`) on back face when depth > 1.
- aria-live region announces "Showing formula for X" and "Showing value for X" on each flip.
- Forward-compatible: properties present on a record but absent from the spec still render (so a daemon-side addition is never invisible).
- Reduced-motion fallback uses opacity cross-fade instead of rotation (covered by Playwright stub; the CSS rule is in `index.css`).

## Design departures (surfaced in the PR comment)

- The promise-formula view's dynamic affordances ("View next value" subscribe, "View trace" trace fetch) are *not* wired today.
  The registry renders the static `store` reference for `promise` and `resolver`.
  The dynamic affordances depend on `daemon-message-streaming.md` shipping the subscription substrate; the back face is structured to absorb them when that design lands.
- The card-flip animation uses inline CSS variables (`--card-flip-duration`, `--card-flip-easing`) rather than a chat-wide animation register.
  The design explicitly anticipates this ("Once an animation register exists at the Chat level, this design conforms to it").

## Pre-push-gates result

The deterministic gate's only probe failures are in pre-existing files outside this PR's diff (`packages/chat-network-view/src/peers.js` non-ASCII glyphs, `packages/9p-server` and `packages/agent-tools` em-dashes, `packages/chat/add-space-modal.js` and several test files' bare `#<n>` references).
None are in the files this dispatch touched.
My only U+2699 gear character is rendered via `String.fromCodePoint(0x2699)` in JS source and `&#9881;` in the chat.js HTML template, so the ASCII source rule is satisfied.

`yarn lint:eslint`: 0 errors (warnings baseline unchanged).
`yarn lint:types` for packages/chat: net new errors 0 (two pre-existing errors on `__getMethodNames__` and `text` at value-component.js lines 124 and 642 are in untouched code paths).
`yarn ava` packages/chat: 496 / 496 passing.

## PR comment

Posted top-level summary at-mentioning kriskowal:
https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701290208

## Recommended next stage

**cleaner re-gamut on the expanded scope.**
The prior cleaner dispatch (`5c4828`) ran on `f01499f1a`, which carried cuts 1 + 2 only; the four commits above expand the scope into `packages/chat/` with substantial new surface area (new files, new tests, modified DOM structure, new CSS).
A fresh cleaner pass reviews the chat-side commits for build hygiene before the panel.
After cleaner, gamut to barrister.

If the maintainer wants to revisit any of the design departures (the deferred promise affordances, the inline CSS variables) before the panel runs, signal here and a fixer dispatch can address them before the cleaner runs.

Self-improvement: prettier's repository-wide run touched a daemon test file (`packages/daemon/test/endo.test.js`) that cut 1 had landed without prettier-clean formatting; I reverted the daemon-test reformatting so the diff stays scoped to chat.
The lesson is local to the builder's pre-push discipline: when prettier auto-fix runs at the repository root, restore any unintended cross-package whitespace touches before commit so the diff stays scoped to the dispatch's purpose.
Not enough novelty to warrant a structural change to the role file.
