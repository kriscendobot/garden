---
ts: 2026-06-15T06:19:43Z
kind: result
role: fixer
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
dispatch_root: /home/kris/dispatches/fixer--0cf086
short_id: 0cf086
prs:
  - { repo: endojs/endo-but-for-bots, pr: 125, role: target }
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/125
  - https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4705107695
---

# result: fixer — rsvp Copilot feedback on #125

Maintainer directive ("rsvp copilot feedback") on PR #125 addressed.
Six Copilot inline items applied in four commits on `feat/edit-message`,
each with a threaded reply citing its addressing SHA plus a single
top-level summary.

## Heads

- pre-fix HEAD: `59224db2d` (test(chat): inbox editMessage and messageHistory affordances)
- post-fix HEAD: `e0c74756f` (docs(designs/streaming): align MessageRevision typedef and persistence note)

## Per-item resolution

| # | File:line | Commit | Resolution |
|---|---|---|---|
| 1 | packages/chat/inbox-component.js:944 | 088cbc9e9 | Resolve kept locators back to pet names via `reverseLocate`; drop bindings whose locator has no pet-name mapping. Added component test covering the kept-binding path. |
| 2 | packages/daemon/src/mail.js:727 | 99c51591d | `makeMessageFormula` now requires a boolean `done` and persists it on the formula envelope; `deliver` passes the computed value. |
| 3 | packages/daemon/src/mail.js:1422 | 99c51591d | `applyEdit` now passes `editEnvelope.done` to `makeMessageFormula`. |
| 4 | packages/daemon/src/interfaces.js:451 | 6e4d2510f | `HostInterface.editMessage` options narrowed to `M.splitRecord({}, { done: M.boolean() })` to mirror the guest guard. |
| 5 | designs/daemon-message-streaming.md:194 | e0c74756f | Implementation Sketch now states `revisionsByNumber` is in-memory only and discarded on restart; full log persistence marked TODO. |
| 6 | designs/daemon-message-streaming.md:154 | e0c74756f | `MessageRevision` typedef uses `envelope`, `date`, `timestamp` to match `packages/daemon/src/types.d.ts` and the tests. |

## Tests per workspace

- `packages/chat` `yarn ava`: 470 / 470 passed (includes the new kept-binding test "submitting an edit that preserves a binding resolves each kept locator to a pet name").
- `packages/daemon` `yarn ava --timeout=120s`: edit/message subsets all pass (`*edit*`, `*history*`, `*message*` including "mailboxes persist messages across restart"). The one failure (`git › Git.status reports merge conflicts with mount entries`) is unrelated to mail/edit and reproduces on the pre-fix base.

## Lint

- `packages/daemon` `yarn lint`: 0 errors (warnings unchanged from base).
- `packages/chat` `yarn lint`: pre-existing TS errors only (confirmed by stashing my changes and re-running; no new errors introduced).

## pre-push-gates

`pre-push-gates.sh --no-auto-fix --summary` from `project/`: the gate's failing probes all touch files my changes did not modify, and the same lines fail on the pre-fix base SHA (filename-no-stutter for `packages/chat/chat-bar-component.js`, no-ascii-banners in `designs/trust-on-first-bind.md`, no-inline-import-jsdoc / non-ASCII warnings in unrelated `packages/daemon/src/mail.js` and `interfaces.js` lines, security-md-hash-uniform, sentence-per-line-md). No new findings introduced.

## PR replies

Six threaded inline replies (one per Copilot comment), each citing the addressing SHA, plus one top-level summary:

- Item 1: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411380154
- Item 2: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411380620
- Item 3: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411381171
- Item 4: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411381264
- Item 5: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411381329
- Item 6: https://github.com/endojs/endo-but-for-bots/pull/125#discussion_r3411381403
- Top-level summary: https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4705107695

Per dispatch authorization: did NOT re-request review. The 06-08 reservation/slot redesign was not pursued (out of scope).

## Recommended next stage

`next: nothing` — Copilot review addressed; maintainer's separate 06-08 reservation/slot directive is outside this dispatch.

Self-improvement: nothing this time.
