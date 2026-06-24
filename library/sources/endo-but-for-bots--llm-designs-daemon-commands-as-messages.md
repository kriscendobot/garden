---
source: designs/daemon-commands-as-messages.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-11
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  **Status: Not Started.** First non-chat endo-but-for-bots design
  ingest in the library (chat-cluster fully ingested as of cycle 99).
  The 253-line design proposes that every user/agent command be
  logged as a *self-addressed message* in the issuer's own inbox,
  with results delivered as replies. Unified Problem → Design →
  Enables/Costs → Dependencies structure; single cohesive argument
  with one central move (`from === to` self-sends as the intentional
  surface). Three structurally interesting moves: (1) the
  *asymmetric transcript* problem-framing — `followMessages()` shows
  what others said but not what you did, which makes agents'
  inbox-follow context incomplete; (2) the *self-addressed message*
  trick — lift the `mail.js` self-delivery suppression *for commands
  only* to enable command-as-message without inbox noise from
  internal delegation; (3) the *agent tool audit trail* bonus —
  capability-confined agents' tool invocations become commands too,
  giving the daemon-capability-bank a built-in observability surface
  without a separate logging system. The §Which-operations-become-
  commands table is the canonical mapping from current behavior to
  the proposed command-message form (8 operations enumerated). The
  *evaluate subsumes eval-proposal pair* line is a structural
  simplification — the existing two-message eval-proposal-proposer
  / eval-proposal-reviewer pattern collapses into one command + one
  value-reply, mirroring daemon-form-request / daemon-value-message.
  
  Twenty-second endo-but-for-bots design ingest (and the first
  daemon-* ingest in this rotation; daemon-* sources already in the
  library are: daemon-256-bit-identifiers / daemon-agent-network-
  identity / daemon-capability-persona / daemon-content-store-gc /
  daemon-cross-peer-gc / daemon-locator-terminology / daemon-
  retention-paths — those are largely older cycles' design-rationale
  ingests). Single-section ingest is cohesion-honest for this
  unified single-proposal design (like cycles 95, 100 single-section
  ingests).
---

> Abstract: `designs/daemon-commands-as-messages.md` proposes that
> every user/agent command be logged as a *self-addressed message*
> (`from === to`) in the issuer's own inbox, with the result
> delivered as a *reply* message via the same `replyTo` mechanism
> used by `daemon-form-request` / `daemon-value-message`. The
> opening *Problem* block frames four downstream consequences of
> the current *commands settle and vanish* behavior: asymmetric
> transcript (the user can't reconstruct what they did); no agent
> visibility (Lal/Fae cannot see the user's commands so context is
> incomplete); no audit trail (capability-confined agent tool
> invocations are invisible); chat UI workaround (the
> `chat-pending-commands` UI-only region duplicates bookkeeping
> the daemon should own). The §Design proposes a new `command`
> message type carrying `commandName` + `args` + `promiseId` /
> `resolverId`; a one-line *type-aware lift* of `mail.js`'s
> self-delivery suppression (`if (from !== to) await
> deliver(message);` becomes type-aware so other self-sends remain
> suppressed). The §Which-operations-become-commands table maps
> 8 operations (`dismiss` / `adopt` / `resolve` / `reject` /
> `evaluate` / `request` / `send` / `grant`) from current
> *promise, no trace* form to *command + reply* form, with
> `evaluate` subsuming the existing `eval-proposal-proposer` /
> `eval-proposal-reviewer` paired-message pattern. The §Agent
> tool audit-trail extension applies the same design to
> `daemon-agent-tools` — Fae's `readFile` / `exec` calls become
> commands too, giving the `daemon-capability-bank` a built-in
> observability surface without a separate logging system. The
> §design-dependency-graph names six related designs
> (chat-pending-commands as predecessor, chat-command-bar as
> dispatcher, daemon-form-request + daemon-value-message as
> reply-pattern donors, daemon-agent-tools as parallel consumer,
> daemon-capability-bank as audit-trail beneficiary). The
> §Affected-packages list (mail.js + types.d.ts + host.js +
> inbox-component.js) is small enough to land cleanly but spans
> two packages (daemon + chat) so the work must be coordinated.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [commands-as-self-addressed-messages-design](../sections/endo-but-for-bots--llm-designs-daemon-commands-as-messages--commands-as-self-addressed-messages-design.md) | daemon | current |

The 253-line file is honestly one cohesive argument-cluster — one central design move (commands as self-addressed messages) supported by problem-narrative, mechanism, dependencies, and cost-analysis. Single-section ingest preserves the document's unified structure (problem-driven proposal); forcing a multi-section split would create artificial divisions between the problem-narrative and the design-mechanism that resolves it.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-03-11 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 253 lines.
- **First non-chat endo-but-for-bots design ingest in this rotation.** Chat-cluster (21 sources) fully ingested as of cycle 99; cycle 101 pivots to the broader designs corpus.
- Cycle 101 was originally scheduled for chat-lane but chat-cluster is exhausted; pivoted to daemon-design-lane within the same endo-but-for-bots root. The §rotation discipline (papers / chat / comments) extends gracefully when a lane runs out — pick the next-best candidate in another lane.
- Single-section cohesion-honest count. The 253-line file is *one tight argument-cluster* — one problem, one central design move, one set of consequences. Forcing a 2-section split (problem+design / costs+enables+deps) would create an artificial divide between motivation and resolution.
