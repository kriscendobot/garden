---
ts: 2026-06-14T08:52:00Z
kind: result
role: investigator
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
dispatch_root: /home/kris/dispatches/investigator--b25691
prs:
  - repo: endojs/endo-but-for-bots
    pr: 440
    role: target
refs:
  - entries/2026/06/14/083900Z-dispatch-investigator-b25691.md
  - https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701223194
---

# result: investigator — chat vs goblin-chat overlap analysis (no overlap; cut 3 lands in chat)

Worktree at `feat/formula-inspector` head `f01499f1a` (post-weaver rebase onto `llm`).
Both `packages/chat/` and `packages/goblin-chat/` reachable.

## Per-package summary

| | `@endo/chat` | `@endo/goblin-chat` |
|---|---|---|
| Tracked files | 122 (71 top-level `.js`) | 26 (10 src js + entry + bin + 2 tests) |
| Total JS LOC | ~35,251 | ~3,933 |
| Runtime | Browser (Vite + React 19 DOM) | Terminal TUI (Ink + React 19) |
| Protocol | Endo daemon over WebSocket + CapTP | OCapN (Spritely Goblins interop) |
| Main entry | `index.js` re-exports `chat.js` (`make`), `connection.js`, `message-parse.js`, `ref-iterator.js` | `api.js` re-exports `backend.js` (`makeChatroom`, `makeUserControllerPair`), `uri-parse.js` |
| Subpath exports | `.` + `package.json` | 6 named subpaths (backend, interop-driver, uri-parse, chat-state, use-goblin-chat, state-store) |
| Headline objects | `valueComponent`, `inventoryComponent`, `channelComponent`, file-explorer, debugger-panel, spaces-gutter, value-render, command-executor, ... | `^chatroom`, `^user`, `^user-controller`, `^user-messaging-channel`, `^authenticated-channel` (Guile port) |
| Has Value modal? | **Yes** — `value-component.js` (512 lines) renders `#value-frame` / `#value-title` / `#value-close` over an `ERef<EndoHost>` | **No.** No modal, no inventory, no capability inspection. |
| Talks to `EndoHost`? | Yes (typed `@import { EndoHost } from '@endo/daemon'`) | No — only `@endo/eventual-send` for OCapN promises. |
| Branch presence | `llm` only (not on master) | both `master` and `llm` |

## Overlap matrix

Per-file: **zero filename matches** beyond standard chrome (`package.json`, `README.md`, `SECURITY.md`, `LICENSE`, `tsconfig*.json`).
Exports: **fully disjoint surface**. `chat` exports a single `make(...)` entry plus a few utilities; `goblin-chat` exports the protocol primitives (`makeChatroom`, `makeUserControllerPair`, `parseLocator`).
Both depend on React 19, but for opposite reasons (browser DOM vs Ink terminal renderer).

## Are they forks?

No.
`goblin-chat`'s `README.md` § Bit-for-bit interop names it a JS port of Spritely's `(goblin-chat backend)` Guile reference, with a Guile-talks-to-JS interop harness (`test/guile-interop/`).
`chat`'s `README.md` § Overview names it extracted from `packages/cli/demo/cat.js` as a standalone Vite app.
Independent implementations of different protocols on different runtimes; the name collision on the word "chat" is the only relationship.

## Formula-view / value-modal surface in each

- `@endo/chat`: the design's target file `packages/chat/value-component.js` already exists.
  Its export `valueComponent($parent, powers, { dismissValue, enterProfile })` builds the front-face Value modal the design extends.
  The design's two new files (`formula-view-component.js`, `formula-view-registry.js`) are siblings of an existing file.
  The inventory-row gear-icon entry point named in the design lives in `inventory-component.js` (1,267 lines), whose row builder starts at line 538 and is the insertion point.
- `@endo/goblin-chat`: no analogous component, no modal, no inventory rows, no formula vocabulary anywhere.
  Grep for `formula | inspect | value-modal | value-component` returns one false positive in `animated-logo.js` (the word "formulation" in an HSL→RGB comment).

## Cut 3 implementation strategy

**Option A — implement in `packages/chat/` only.**

Rationale:

1. The design names `packages/chat/` files by absolute path.
   `goblin-chat` has no surface to land cut 3 in.
2. Cuts 1 (`feat(daemon): add host-only getFormula and retire @info name hub`, `4fa742351`) and 2 (`feat(cli): add endo inspect verb for formula records`, `4e7a975c1`) already on `f01499f1a` presuppose the `chat`-side back face on the same branch.
   Routing cut 3 elsewhere strands the daemon work behind a missing client.
3. `goblin-chat`'s UI vocabulary (rooms, users, messages, authenticated channels) does not include capability inspection.
   Adding it would be a new design, not this one.
4. Options C (mirror) and D (defer + escalate) presume a relationship that does not exist.
   These are unrelated apps that happen to share four letters in their name.

The only cross-package note worth registering separately: the package-naming collision can mislead future readers into assuming one supersedes the other.
A README cross-link ("see also: `@endo/goblin-chat` — unrelated OCapN chatroom") would inoculate against that.
Sits outside the formula-inspector design; does not block cut 3.

## PR comment

Posted on PR #440 at-mentioning `@kriskowal`:
https://github.com/endojs/endo-but-for-bots/pull/440#issuecomment-4701223194

## Files examined

- `packages/chat/package.json`, `README.md`, `value-component.js`, `inventory-component.js`, `index.js`, plus tracked-file enumeration (122 files).
- `packages/goblin-chat/package.json`, `README.md`, `api.js`, `index.js`, `src/use-goblin-chat.js`, `src/chat-state.js`, plus tracked-file enumeration (26 files).
- `designs/formula-inspector.md` (the merged consolidated spec).
- `packages/daemon/src/host.js` (the landed `getFormula` host-only method around line 1488).
- `packages/daemon/src/interfaces.js`, `packages/daemon/src/daemon.js` (confirmed cuts 1 and 2 landed; `InspectorHubInterface` still present but `@info` row removed from host special names).
- Branch presence per file: `git log origin/{master,llm} -- packages/chat packages/goblin-chat`.

Self-improvement: nothing this time.
The dispatch brief was tight and answerable from a file-and-name walk; no skill or role lesson surfaced.
