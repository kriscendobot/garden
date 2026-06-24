---
title: Connection to the wider library
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

This section is the **canonical *cross-cutting design that subsumes a UI-only predecessor* worked example**. Three threads:

1. **The self-addressed message pattern** — using the existing `from === to` corner case (currently suppressed by `mail.js`) as the *intentional* design surface, with one-line type-aware lift of the suppression. The change is *minimal in mechanism, maximal in semantics*.

2. **The audit-trail-as-bonus discipline** — one design solves the original motivation *plus* a parallel concern (capability-bank observability). Naming both in the same design doc makes the cross-cutting value visible to reviewers.

3. **The design-dependency-graph footer** — explicit cross-references to six related designs in a table that names the *relationship* (predecessor, dispatcher, donor, consumer, etc.). The reader can navigate to neighboring designs to understand the architectural context.

The §contrast with cycle 99's chat-reply-chain-visualization (deprecated): that design was UI-only; this design moves the same kind of *focus-and-context* concern into the daemon layer. The §`chat-pending-commands` is named explicitly as the UI-only predecessor that *this* design subsumes.
