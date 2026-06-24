---
source: designs/daemon-value-message.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  **Status: Complete** — value message type, persistence, delivery
  via submit(), Chat UI rendering, VALUE edge, standalone sendValue
  method on Mail/Host/Guest, and send-value CLI command all
  implemented. The 331-line design defines a new `value` message
  type — *the foundational reply primitive* on top of which higher-
  level patterns build (cycle 101's daemon-commands-as-messages
  reuses it for command-result replies). Three structurally
  interesting moves: (1) the *reply-only* invariant (required
  `replyTo` field, unlike `package`'s optional `replyTo`) constrains
  value messages to the reply-with-result pattern that motivates
  them; (2) the *auto-retain* mechanism via optional `resultName`
  hint — recipient's `deliver()` writes the value to the pet store
  under the hint name, enabling zero-ceremony value delivery for
  the common case while preserving recipient autonomy; (3) the
  *recipient-inferred-from-parent* rule — `sendValue` doesn't take
  a recipient argument because the parent message's other-party
  *is* the recipient, mirroring `reply` and preventing sending
  values to unrelated parties (security-by-topology).
  
  Twenty-third endo-but-for-bots design ingest. Single-section
  cohesion-honest ingest (like cycles 95, 100, 101). The 331-line
  file is *one tight unified proposal* (introduce a new message
  type for value-replies); the apparent four-part decomposition
  (problem / design / decisions / files-modified) is one cohesive
  argument with implementation appendices. The 14-row Files
  Modified table spans daemon (7 files), cli (3 files), test (1),
  and chat (3 files) — the *design-doc-as-implementation-tracker*
  shape captures the full surface a new-message-type addition
  needs to touch.
---

> Abstract: `designs/daemon-value-message.md` defines a new `value`
> message type for the *give-a-value-to-another-agent* gap in
> Endo's message taxonomy. The opening *Problem* names four
> downstream consequences of the current `package`-with-empty-
> template-strings workaround: template-string noise, no clear
> reply semantics, adopt ceremony, and LLM agent tool results
> (the *core loop of agentic interaction: human sends task, agent
> replies with result*). The §Design proposes a new `value`
> message type carrying exactly one `valueId: FormulaIdentifier`
> with **required** `replyTo: FormulaNumber` — every value
> message is a reply. The §`sendValue(messageNumber,
> petNameOrPath, resultName?)` method on Mail/Host/Guest infers
> the recipient from the parent message's other-party (same logic
> as `reply`); looks up the value's formula identifier; constructs
> the hardened ValueMessage; and posts. The §auto-retain
> mechanism — recipient's `deliver()` writes the value to the pet
> store under the `resultName` hint when present. The §message
> hub directory exposes seven edges (FROM/TO/DATE/TYPE/MESSAGE/
> REPLY/VALUE) with VALUE as the primary payload. The §five
> Design Decisions name *reply-only* (unsolicited values stay as
> `package`), *single value* (multi-value uses multiple messages),
> *auto-retain optional* (resultName is hint, not guarantee), *no
> promise/resolver infrastructure* (fire-and-forget; the value
> already exists), *recipient inferred from parent* (security-by-
> topology). The §14-row Files Modified table spans daemon
> (types.d.ts + mail.js + host.js + guest.js + interfaces.js +
> help-text.js + daemon.js), cli (endo.js + commands/send-value.js
> + commands/inbox.js), test (daemon/test/endo.test.js), and chat
> (inbox-component.js + command-registry.js + command-executor.js).
> The §Related Designs cross-reference names three sibling designs
> (daemon-form-request as consumer of the value-reply pattern,
> chat-reply-chain-visualization for connector-line rendering,
> daemon-capability-bank as future capability-grant-delivery
> mechanism).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [value-message-type-and-reply-only-design](../sections/endo-but-for-bots--llm-designs-daemon-value-message--value-message-type-and-reply-only-design.md) | daemon | current |

The 331-line file is honestly one cohesive argument-cluster — one central design move (introduce a new `value` message type) supported by problem-narrative, mechanism, decisions, and implementation surface. Single-section ingest preserves the document's unified structure; forcing a multi-section split would create artificial divisions between the design and its rationale/implementation appendices.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-03-02 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 331 lines.
- **Twenty-third endo-but-for-bots design ingest**. The §Status header explicitly says *Complete* with implementation details enumerated — value message type, persistence via submit(), Chat UI rendering, VALUE edge, standalone sendValue method, and send-value CLI command all shipped.
- Cycle 103 was scheduled for chat-lane but chat-cluster is exhausted; pivoted to daemon-design-lane (per cycle 101's precedent). The §rotation discipline extends gracefully when a lane runs out.
- Single-section cohesion-honest count. The 331-line file is *one tight unified proposal* — one new message type, one reply discipline, one set of decisions, one implementation surface. The apparent four-part decomposition (problem / design / decisions / files-modified) is one cohesive argument.
- **Pairs structurally with cycle 101's `daemon-commands-as-messages`**: this design establishes the value-as-reply pattern; cycle 101's design *reuses* it for every command's result reply. Together they form the *daemon's reply-primitive layer*.
