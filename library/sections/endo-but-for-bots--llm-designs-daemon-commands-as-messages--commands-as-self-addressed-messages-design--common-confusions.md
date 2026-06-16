---
title: Common confusions
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

- **"`from === to` self-sends are already supported."** They are *suppressed* by default — `mail.js` has `if (message.from !== message.to) await deliver(message);`. The design's central move is to lift this suppression *for `type: 'command'` messages only*. Other self-sends remain suppressed to avoid inbox noise.
- **"Why not just add a separate `commandLog` capability?"** A separate log would be a parallel mechanism to the existing message system. The §discipline is *minimal-mechanism-maximal-semantics*: use the message system that already exists, change a single conditional, get the full benefit.
- **"Why durable-formula commands? Doesn't this bloat the formula store?"** Durability is the point — commands must survive daemon restart so session reconstruction is possible. The mitigation (commands are small; no markdown body, no embedded refs) keeps the per-formula cost low. The §2x volume tradeoff is acknowledged in §What It Costs.
- **"`evaluate` already has eval-proposal-proposer / eval-proposal-reviewer messages — adding `command` is duplication."** The §design proposal *replaces* the eval-proposal pair with a single `command` + value-reply. The proposer/reviewer pair *collapses* into the general command-message pattern. This is a simplification, not an addition.
- **"The agent tool audit trail conflicts with capability confinement — the agent shouldn't see the host's view."** It doesn't conflict. The agent's *own* inbox gets the agent's *own* command messages. The host, who granted the capability and observes the agent's inbox externally, sees the audit trail. The agent sees their own actions; the host sees the agent's actions. Same data, different observer perspectives.
- **"Pending commands as messages-without-replies is fragile — what if the reply gets lost?"** The reply formula is itself durable. A reply being *lost* would require a daemon-layer bug, not a design fault. If the reply is *delayed* (long-running command), the pending state persists naturally; the user/agent sees the command remains pending.
- **"This design is *Not Started* — is it actually going to land?"** *Not Started* is a status field, not a verdict. The design is *queued* — the prerequisite designs (daemon-form-request, daemon-value-message, daemon-agent-tools, chat-pending-commands) need to land first or the dependencies aren't met. The status field is honest about the implementation order.
- **"The chat-UI reply-fold means the reply message is invisible to users."** It's not invisible — it's *integrated into the command card's settled state*. The user sees the command-and-its-result as one transcript row; the daemon stores two messages. Both data shapes are correct for their consumer.
