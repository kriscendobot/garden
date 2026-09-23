---
ts: 2026-06-15T05:52:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--0cf086
prs:
  - repo: endojs/endo-but-for-bots
    pr: 125
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/125
  - https://github.com/endojs/endo-but-for-bots/pull/125#pullrequestreview-(copilot 2026-06-14T21:08:09Z)
  - https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4704947390
---

# dispatch: fixer — apply Copilot feedback on PR #125 per kriskowal

Maintainer directive (kriskowal on PR #125, 2026-06-15T05:50:51Z):

> @kriscendobot rsvp copilot feedback.

Copilot review (COMMENTED, 2026-06-14T21:08:09Z) carries 6 inline findings on PR #125 (editMessage / messageHistory feature). Apply all 6.

## State at dispatch time

- **PR** `endojs/endo-but-for-bots#125`, OPEN, not draft, reviewDecision CHANGES_REQUESTED (from kriskowal 06-08; deeper redesign for reservation/slot pattern is separate from this dispatch), base `llm`, head `59224db2d`.
- **Copilot inline comments** (6 items):
  1. **`packages/chat/inbox-component.js:944`** — inline editor submits `message.ids` (externalized locators) as the 4th argument to `powers.editMessage`, but the daemon API expects pet names / name paths (it calls `directory.identify` after `nameForLocator`). Adjust the call site to pass pet names (or implement a locator → name resolution at the boundary).
  2. **`packages/daemon/src/mail.js:727`** — `deliver()` computes a `done` flag but does not persist it in the stored message formula. Since `makeStampedMessage()` reads `done` from the persisted formula (defaulting to true), `done: false` messages become indistinguishable from `done: true` on reload. Persist the flag.
  3. **`packages/daemon/src/mail.js:1422`** — Edits are persisted via `persistMessage(messageNumber, formula)`, but the persisted formula currently omits the edited `done` state. Same persistence concern as item 2; persist the edited `done` state.
  4. **`packages/daemon/src/interfaces.js:451`** — `HostInterface.editMessage` accepts an untyped optional record, but `GuestInterface.editMessage` constrains the options to `{ done: boolean }`. To keep host/guest behavior consistent and catch invalid options earlier, narrow the host's options to the same shape.
  5. **`designs/daemon-message-streaming.md:194`** — Section claims the revision log is persisted across daemon restarts, but the current implementation explicitly keeps `revisionsByNumber` in-memory only (and the PR description notes persistence is deferred). Update the design text to match the current implementation (or land persistence in this PR — designer's call; the maintainer's earlier 06-08 directive about reservation/slot pattern suggests in-memory-then-persist-on-done is the intended path, so a doc fix is the lighter touch).
  6. **`designs/daemon-message-streaming.md:154`** — `messageHistory` typedef describes a `payload` field, but the implemented API and types elsewhere in this PR use an `envelope` field (and include an ISO `date`). Update the typedef to `envelope` and add `date`.

## Task

In your `project/` worktree at `59224db2d`:

1. Read the Copilot review body + the 6 inline comments verbatim (gh api endpoints).
2. Apply each item per its citation; verify against the actual code/spec at the cited line.
3. Run `corepack yarn workspace @endo/daemon test`, `corepack yarn workspace @endo/chat test`, `corepack yarn workspace @endo/fae test`, `corepack yarn workspace @endo/lal test`, `corepack yarn lint`.
4. Run pre-push-gates from project/.
5. Commit per logical group (1 file ≈ 1 commit OK; or per-package):
   - `fix(chat): pass pet names instead of message ids to powers.editMessage`
   - `fix(daemon): persist done flag on initial deliver and edits`
   - `fix(daemon): narrow HostInterface.editMessage options to { done: boolean }`
   - `docs(designs): correct messageHistory typedef field name and add date`
   - `docs(designs): align persistence note with in-memory implementation`
6. Push to `feat/edit-message` (append only).
7. Reply to each Copilot inline comment (use the PR review thread API if available; otherwise post a top-level summary at-mentioning @kriskowal that lists per-item SHA + resolution).

## Authorizations

- Push commits to `feat/edit-message` (append only).
- Reply to Copilot inline comments (PR review thread API).
- Top-level summary comment at-mentioning @kriskowal.
- Do NOT re-request review (the maintainer's CHANGES_REQUESTED has its own substance from 06-08 that this fixer does NOT address; the maintainer will re-engage).

## Out of scope

- Do NOT pursue the 06-08 reservation/slot pattern redesign (that's separate; the maintainer's earlier directive describes a substantial implementation change with persistence-on-`done`).
- Do NOT touch unrelated packages or features.
- Do NOT mark PR ready/un-ready (it's already not draft).

## Deliverable

A `result` entry under `journal/entries/2026/06/15/` naming:

- Pre/post head SHAs.
- Per-item resolution mapping (file:line + commit SHA).
- Test results per workspace.
- pre-push-gates result.
- PR #125 reply URL(s) or summary comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: nothing` (maintainer's 06-08 reservation/slot directive is separate scope and outside this dispatch).

End your turn with a concise summary back to the orchestrator.
