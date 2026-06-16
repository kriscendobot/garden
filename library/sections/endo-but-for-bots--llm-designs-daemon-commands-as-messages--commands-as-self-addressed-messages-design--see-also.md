---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture; this design extends the mail system at the core.
- `endo-but-for-bots--llm-designs-chat-pending-commands--*` — the *UI-only predecessor* this design subsumes; chat-pending-commands tracks in-flight commands in ephemeral DOM state, which this design moves into the daemon's durable message log.
- `endo-but-for-bots--llm-designs-chat-command-bar--*` (cycles 71+) — the command bar that *dispatches* commands; under this design, each dispatch posts a command message before executing.
- `endo-but-for-bots--llm-designs-chat-reply-chain-visualization--*` (cycle 99, deprecated) — sibling UI-side reply-relationship visualization; this design is the *daemon-side* counterpart that makes the reply data durable.
- `endo-but-for-bots--llm-designs-chat-focus-message--*` — the successor reply-visualization design; consumes the daemon-side message-relationship data this design produces.
