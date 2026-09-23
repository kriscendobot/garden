---
ts: 2026-06-08T04:58:00Z
kind: dispatch
role: steward
host: endolinbot
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--52156c
refs:
  - https://www.npmjs.com/package/chat
---

# dispatch: researcher — refs for chat-bridge designer (integrate npm `chat` as multi-platform bridge plugin)

User directive (2026-06-08T04:51Z):

> Please dispatch a designer to create or modify (or acknowledge
> that the design already exists) that integrates
> https://www.npmjs.com/package/chat as a plugin for bridging
> chat with other platforms. Review the daemon's chat verbs, the
> exposed chat interface, and identify gaps. Note the ongoing
> work for editing messages in flight. Note the need for
> tokenized references (capability links). Discuss options. This
> may simply be amendments to existing designs that are open for
> review, or a new design PR if necessary.

The downstream is a **designer** dispatch. Researcher precedence
applies.

## What you should look for

- **`chat` npm package** at <https://www.npmjs.com/package/chat>:
  read the package's surface (API, README, supported platforms).
  Specifically: what platforms does it bridge to (Slack, Discord,
  iMessage, SMS, Telegram, WhatsApp, etc.)? What is the abstraction
  shape (a unified message API, a per-platform adapter, a
  middleware pattern)? Is it actively maintained?
- **The daemon's existing chat surface**: scan `packages/daemon/
  src/` for chat verbs (`sendMessage`, `editMessage`,
  `messageHistory`, `cancelMessage`-pending, etc.) and the exposed
  chat interface. Library entries on daemon-commands-as-messages
  and chat-spaces.
- **`designs/chat*.md`** on `origin/llm@11a76ae6` (current tip):
  - `designs/chat-inventory-create-menu.md` (PR #404, active)
  - `designs/chat-spaces-gutter.md` (library has section)
  - `designs/chat-edit-message-ui.md` (PR #305)
  - `designs/chat-inventory-cancel-and-liveness.md`
  - any other `designs/chat*` files
- **Ongoing edit-message work**: PR #125 (`feat(daemon): add
  editMessage and messageHistory`) just got kriskowal's answers
  on the linked-list edit-history shape. The chat-bridge design
  should align with the new schema (initial-reserves-slot, edits
  replace in place, persist chain on `done`, new
  `cancelMessage` verb).
- **Tokenized references / capability links**: how does the daemon
  currently encode pet-name handles for cross-platform sharing?
  Library entries on dehydrate-hydrate, space-references,
  `@host` / `@root` special places.
- **Plugin architecture precedent**: how does the bot fork
  structure plugins today? Is there a precedent like the
  daemon-capability-bank's nine sibling capabilities?
- **Maintainer's "or acknowledge that the design already exists"
  framing**: critical — is there an existing design that already
  covers the bridge shape? `designs/endopi.md` discusses the
  Pi-vs-Endo split; `designs/chat-spaces-gutter.md` covers
  pet-store-as-typed-namespace; `designs/endoclaw.md` discusses
  parity-comparison with OpenClaw / ClawdBot which itself bridges
  multiple platforms. Surface these as candidates and the gap
  analysis (does any existing design fully cover the npm `chat`
  integration shape, or does it need amendment, or net-new?).

## Deliverable

Per `roles/researcher/AGENT.md`: a `result` entry with the
standard `## Library and project references` section the steward
will inline.

Five-minute wall time target.
