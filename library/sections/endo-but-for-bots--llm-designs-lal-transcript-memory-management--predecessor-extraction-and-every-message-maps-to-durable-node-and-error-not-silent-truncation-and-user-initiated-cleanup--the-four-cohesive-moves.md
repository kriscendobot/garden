---
title: The four cohesive moves
source-slug: endo-but-for-bots--llm-designs-lal-transcript-memory-management
section-id: predecessor-extraction-and-every-message-maps-to-durable-node-and-error-not-silent-truncation-and-user-initiated-cleanup
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/lal-transcript-memory-management.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/lal-transcript-memory-management.md
status: Not Started
ingest-cycle: 216
ingest-date: 2026-06-07
lane: designs
parent: endo-but-for-bots--llm-designs-lal-transcript-memory-management--predecessor-extraction-and-every-message-maps-to-durable-node-and-error-not-silent-truncation-and-user-initiated-cleanup
---

### §Predecessor-extraction with §explicit-Predecessor-section

The design opens with a §Predecessor heading naming the source document:

> This design was extracted from Phase 5 of [lal-reply-chain-transcripts](lal-reply-chain-transcripts.md), which implemented the transcript chain data model (Phases 1-4) and deferred durable persistence concerns as future work.

§Phase-5-extracted-to-separate-design is the §parent-design-side language; §extracted-from-Phase-N-of-predecessor is the §child-design-side language. §Two-sides-of-the-same-relationship-named-explicitly.

### §Existing-Infrastructure named with bullet-list

A §Predecessor sub-section lists §five-named-pieces of inherited infrastructure:

- **`TranscriptNode`** — node in the conversation tree with `messageId`, `parentMessageId`, and `messages` array.
- **`nodeCache`** — in-memory `Map<string, TranscriptNode>` as write-through cache.
- **`getNode(messageId)`** — checks cache, falls back to `E(powers).lookup('transcript-<messageId>')`.
- **`putNode(node)`** — writes to both cache and durable storage via `E(powers).storeValue()`.
- **`assembleTranscript(leafMessageId)`** — walks chain leaf→root, collects messages, reverses, flattens.

Plus the §Alias-entries item (outbound `messageId` aliases the conversation-turn node).

§Inherit-don't-redescribe — by enumerating existing infrastructure, the design §says-what-is-already-there-so-the-Description-only-says-what-is-new. §Borrowable-pattern: §design-document-that-inherits-from-a-predecessor opens with the §Existing-Infrastructure list so readers can find the §additive-deltas easily.

### §Every-message-maps-to-a-durable-node

The §Message-to-Node Mapping section names §two-cases-with-symmetric-treatment:

- **Inbound** messages create a new node containing user content; chain to `replyTo` node or create a fresh root.
- **Outbound** messages (agent's own replies, observed via `followMessages()`) create §alias-entries — mapping outbound `messageId` to the node containing the conversation turn.

§The-symmetry-is-the-point: §future-replies-to-the-agent-can-find-the-correct-chain via the §alias mechanism. §Borrowable-pattern: §every-conceptual-event-must-map-to-the-canonical-durable-representation; §asymmetric-events-get-asymmetric-representations-that-converge-on-the-same-lookup.

### §Durability-beyond-message-lifecycle

The §inbox-vs-transcript-store separation is named explicitly:

> Transcript nodes are stored in the agent's pet store, not in the inbox. Dismissing inbox messages does not affect transcript nodes.

§Two-different-stores-with-two-different-lifecycles: inbox (ephemeral; user-dismissible) vs transcript (durable; agent-managed). §The-user's-action-on-the-inbox-does-not-cascade-to-the-transcript.

The §accumulation-is-intentional language is borrowable:

> Transcript nodes accumulate over the agent's lifetime. This is intentional — they are the agent's memory of past conversations.

§Name-the-policy-not-just-the-mechanism: the §accumulation is §a-feature-not-a-bug; the §design-explicitly-defends-the-policy. §Borrowable-pattern: §when-an-accumulating-resource-might-look-like-a-leak, §name-it-as-intentional-policy-in-the-design.

### §Error-not-silent-truncation

The §Reliable Assembly section names the §missing-node-handling policy:

> If any node in the chain is missing (e.g., due to data corruption), assembly fails and the agent should report the broken chain rather than producing a partial transcript.

§Fail-loud-not-degrade-silently. §Borrowable-pattern from cycle 100 (unhandled-rejection-display + makeRejectionHandlers): §fail-loud-not-degrade. Cycle 100 phrased it as §return-undefined-on-engines-without-FinalizationRegistry; this design phrases it as §report-broken-chain-not-silent-truncation. §The-same-discipline-at-the-application-layer.

### §User-initiated-cleanup

Storage cleanup is §user-initiated-not-automatic:

> If a user wants to reclaim storage, they can discard the agent entirely or use another agent to export transcripts (e.g., to JSONL) before cleanup.

§Two-named-cleanup-paths: §discard-agent-entirely (coarse) or §export-via-another-agent-then-cleanup (fine). §Out-of-Scope-cross-references: §Garbage-collection out-of-scope ("storage is cheap; users can discard the agent"); §Transcript-export-tooling out-of-scope ("useful companion feature, but a separate design concern"). §The-design-resists-feature-creep-by-naming-future-features-as-out-of-scope.
