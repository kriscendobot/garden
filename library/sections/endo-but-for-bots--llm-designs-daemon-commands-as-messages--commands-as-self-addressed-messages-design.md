---
title: The four-problem motivation (asymmetric transcript + no-agent-visibility + no-audit-trail + chat-UI-pending-region-workaround) framing *commands* as a missing-half-of-conversation gap in the daemon's mail system; the unified design proposal that every command becomes a *self-addressed message* in the issuer's own inbox (`#42 You → You dismiss #5`) with the result delivered as a *reply* message (`#43 (reply to #42) ✓ dismissed` or `✗ Error: ...`); the new `command` message type carrying `commandName` + structured `args` + `promiseId`/`resolverId` for the result; the §self-delivery suppression lift (`mail.js` currently `if (from !== to) await deliver(message);` — must be lifted *for commands only* to avoid inbox noise from internal delegation patterns); the durability story (commands and replies are persistent formulas, survive restart, replay on `followMessages()`); the eight-operation table (dismiss / adopt / resolve / reject / evaluate / request / send / grant) that becomes a command; the *evaluate subsumes eval-proposal pair* simplification; the chat-UI compact-rendering with pending-spinner + settled-checkmark/error folded into one card; the agent-tool audit-trail bonus — Fae's tool calls (`readFile`, `exec`) become commands too, giving the capability bank a built-in observability surface without a separate logging system; the cost analysis (mail.js + types.d.ts core changes + 2x message volume + UI rendering work); the dependency graph that names six related designs (chat-pending-commands as predecessor, chat-command-bar as dispatcher, daemon-form-request + daemon-value-message as reply-pattern donors, daemon-agent-tools as parallel consumer, daemon-capability-bank as audit-trail beneficiary)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design--common-confusions.md)
