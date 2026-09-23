---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `asymmetric transcript` | The *missing-half-of-conversation* discipline; surface what the user did, not just what was sent to them. |
| `commands as self-addressed messages` | The *use-an-existing-corner-case-as-the-intentional-surface* pattern; minimal-mechanism-maximal-semantics. |
| `if (message.from !== message.to)` suppression lift for type === 'command' | The *type-aware-self-delivery* discipline; preserve default-suppress for other self-sends. |
| Durable command + reply formulas linked by `replyTo` | The *form → value-reply* pattern from daemon-form-request, reused. |
| `evaluate` subsumes `eval-proposal-proposer`/`eval-proposal-reviewer` pair | The *general-pattern-subsumes-special-case* simplification. |
| Chat-UI fold reply into command card's settled state | The *user-sees-one-row-daemon-stores-two-messages* dual representation. |
| Agent tool audit trail via command messages | The *one-design-solves-two-problems* cross-cutting payoff. |
| `commands as messages` enables `undo/replay` | The *durable-log-enables-future-capabilities* discipline; don't commit to undo today, but design the substrate so it becomes possible. |
| Subsumes `chat-pending-commands` UI-only region | The *new-design-deprecates-predecessor* lifecycle; explicitly name what becomes unnecessary. |
| `command messages are smaller than conversational messages (no markdown body, no embedded references)` | The *cost-mitigation* paragraph; acknowledge the 2x message-volume cost and name the per-message-size offset. |
