---
title: Abstract
source: designs/daemon-commands-as-messages.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-11
source_authors: [Kris Kowal (prompted)]
source_lines: "1-253 (full file: problem + design + enables + costs + dependencies + affected packages + prompt)"
topics: [daemon]
status: current
notes: |
  First non-chat endo-but-for-bots design ingest in the library
  (chat-cluster fully ingested as of cycle 99). The 253-line *Not
  Started* design proposes that every user/agent command be logged
  as a *self-addressed message* in the issuer's own inbox, with
  results delivered as replies. Single cohesive argument with
  unified Problem → Design → Enables/Costs → Dependencies structure.
  Three structurally interesting moves: (1) the *asymmetric
  transcript* problem-framing — `followMessages()` shows what
  others said but not what you did, which makes agents' inbox-
  follow context incomplete; (2) the *self-addressed message* trick
  — lift the `mail.js` self-delivery suppression *for commands only*
  to enable command-as-message without inbox noise from internal
  delegation; (3) the *agent tool audit trail* bonus — capability-
  confined agents' tool invocations become commands too, giving
  the daemon-capability-bank a built-in observability surface
  without a separate logging system. The §Which-operations-become-
  commands table is the canonical mapping from current behavior to
  the proposed command-message form (8 operations enumerated). The
  *evaluate subsumes eval-proposal pair* line is a structural
  simplification — the existing two-message eval-proposal-proposer /
  eval-proposal-reviewer pattern collapses into one command + one
  value-reply, mirroring daemon-form-request / daemon-value-message.
parent: endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design
---

The §opening Problem block (lines 9-40) frames *commands* as a missing-half-of-conversation gap in the daemon's mail system. The daemon's `followMessages()` records inbound messages (things sent *to* a user or agent) but not the user's outbound commands (`dismiss`, `adopt`, `resolve`, `evaluate`, `send`); these execute as promises that *settle and vanish*. The §four enumerated problems: (1) *asymmetric transcript* — reconstructing a session requires correlating inbox changes with unrecorded commands; (2) *no agent visibility* — Lal and Fae follow the user's inbox to build context, so they cannot distinguish *the user dismissed that request* from *the request was never delivered*; (3) *no audit trail* — for capability-confined agents, tool invocations are equally invisible; (4) *chat UI workarounds* — the `chat-pending-commands` UI-only region duplicates bookkeeping the daemon should own. The §Design (lines 42-191) proposes that every command becomes a *self-addressed message* in the issuer's own inbox; the result is delivered as a *reply* message via the same `replyTo` mechanism used by `daemon-form-request` / `daemon-value-message`. The §new `command` message type carries `commandName` + structured `args` + `promiseId`/`resolverId`. The §self-delivery suppression in `mail.js` (`if (from !== to) await deliver(message);`) is lifted *for commands only* — other self-sends remain suppressed to avoid inbox noise from internal delegation. The §persistence story: command and reply messages are durable formulas, survive daemon restart, replay on `followMessages()` so an agent or Chat UI can reconstruct full session history. The §Which-operations-become-commands table maps 8 operations (`dismiss`/`adopt`/`resolve`/`reject`/`evaluate`/`request`/`send`/`grant`) from their current *promise, no trace* form to *command + reply* form, with `evaluate` subsuming the existing `eval-proposal-proposer`/`eval-proposal-reviewer` paired-message pattern. The §Chat UI rendering specifies command messages as visually-distinct, compact one-line cards with pending-spinner / settled-checkmark / error indicator folded into the same card (no separate reply rendering). The §Agent tool audit trail extends the design to `daemon-agent-tools` — Fae's `readFile`/`exec` calls become commands too. The §What This Enables (lines 193-204) lists four benefits: unified transcript, agent-visible history, undo/replay foundation, tool audit trail. The §What It Costs (lines 206-216) names three costs: mail.js + types.d.ts core changes; 2x message volume; UI rendering work. The §Dependencies (lines 218-227) cross-references six related designs as a *design dependency graph* describing how this design fits into the broader endo-but-for-bots architecture.
