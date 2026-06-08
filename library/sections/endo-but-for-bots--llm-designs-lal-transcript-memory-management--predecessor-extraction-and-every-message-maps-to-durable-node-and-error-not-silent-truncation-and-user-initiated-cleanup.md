---
title: "lal-transcript-memory-management — §predecessor-extraction + §every-message-maps-to-durable-node + §error-not-silent-truncation + §user-initiated-cleanup"
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
---

# lal-transcript-memory-management — Phase 5 extracted to its own design

A 135-line **Not Started** design (created and updated 2026-03-05) extracted from Phase 5 of [lal-reply-chain-transcripts](https://github.com/endojs/endo-but-for-bots/blob/master/designs/lal-reply-chain-transcripts.md) (cycle 214's ingest). §Concrete-instance of the §Phase-N-extracted-to-separate-design pattern named in cycle 214 — the §extracted-Phase-5-of-a-Complete-predecessor.

## The four cohesive moves

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

## The §single-Decisions-table (vs cycle 214's two-table shape)

| Aspect | Decision |
|--------|----------|
| Node lifetime | Persists for the lifetime of the agent |
| Relationship to inbox | Independent; nodes outlive dismissed messages |
| Missing node handling | Error, not silent truncation |
| Storage cleanup | User-initiated (discard agent or export) |

§Four-row-Decisions-table — §single-list-shape (vs cycle 214's §Decisions-Made-vs-Tentative-Decisions two-table-shape). §Different-decision-categories-warrant-different-shapes: cycle 214's design was Complete-with-Phases-shipped (some decisions firmed up by implementation; others still tentative); this design is Not-Started (no decisions are yet field-tested), so the §single-table-of-named-decisions makes sense. §Borrowable-pattern: §shape-of-the-Decisions-section-tracks-the-Status-section.

## The §four-Out-of-Scope items

| Item | Reason |
|------|--------|
| Token budget enforcement | LLM provider rejects; no reliable inputs to predict |
| Automatic summarization or compression | user-initiated, not automatic |
| Garbage collection | storage is cheap; users can discard the agent |
| Transcript export tooling | useful companion feature, but a separate design concern |

§Same-shape-as-cycle-214's §four-out-of-scope-items-with-named-reason-or-pointer. §The-Out-of-Scope-section is a §discipline-pattern shared across the Lal cluster.

## Status: Not Started

§This-is-a-not-yet-implemented-design-with-five-pieces-of-existing-infrastructure-already-in-place. The §Status: Not Started field captures the §gap-between-the-data-model-shipping-(Phases-1-4) and the §durability-design-needing-its-own-treatment.

§Borrowable-pattern: §extract-the-Phase-that-needs-more-design-thought-into-its-own-document with §Predecessor-pointing-back-to-the-parent-design.

## §Five-completed-Lal/Fae-cluster-designs in library after cycle 216

| Cycle | Design | Status | Role |
|-------|--------|--------|------|
| 208 | familiar-bundled-agents | shipped | Delivery (bundling + registration) |
| 210 | lal-fae-form-provisioning | shipped | Configuration (form → guest → worker loop) |
| 214 | lal-reply-chain-transcripts | shipped (Phases 1-4) | Transcript memory (linked-chain nodes) |
| 216 | lal-transcript-memory-management | Not Started | Durability (every message → durable node) |

§The-cluster-grows-to-four-members with §a-mix-of-shipped-and-not-yet-implemented; cycle 216 is the §extracted-Phase-5 that cycle 214 named explicitly.

§A-four-design-cluster for §the-Lal-feature now.

## §Honest-design-evolution-record family — sixteenth member

§The-very-act-of-extracting-Phase-5-into-its-own-design is itself a §design-evolution-event. Cycle 214's prose said §Phase-5-extracted-to-separate-design; cycle 216 is §the-other-side of that extraction. §Sixteenth-member of the family with §a-new-shape: §design-evolution-visible-across-two-documents (vs cycle 214's §within-one-document self-correcting prose).

| Cycle | Shape |
|-------|-------|
| ... | ... (previous fifteen members) |
| 214 | §honest-design-evolution-visible-in-the-prose (§"This is getting complex. Let's simplify:" self-correcting prose) |
| 216 | §honest-design-evolution-visible-across-two-documents (§Phase-5-extracted-to-separate-design with §Predecessor-section in the child) |

§The-pattern-now-has-15+-shapes; this is one new shape in the family.

## Related material in the library

- **cycle 214 lal-reply-chain-transcripts**: §parent-design; this design is its Phase-5 extraction.
- **cycle 210 lal-fae-form-provisioning**: §sibling at the Lal/Fae configuration layer.
- **cycle 208 familiar-bundled-agents**: §sibling at the Lal/Fae delivery layer.
- **cycle 100 unhandled-rejection-display + makeRejectionHandlers**: §fail-loud-not-degrade sibling discipline.
- **cycle 203 cache-map**: §bounded-size-cache sibling — both designs §think-carefully-about-cache-lifetime; cycle 203 enforces a bound; cycle 216 declares §unbounded-is-intentional.
- **cycle 199 memoize**: §weak-key-cache sibling — cycle 199 uses §pumpkin-sentinel for absent values; cycle 216 uses §`getNode` returns the node or throws.
- **cycle 198 patterns-diagnostic-feedback**: §diagnostic-on-failure sibling — both designs say §the-data-is-already-there-just-locked-include-it-in-the-error-or-report.
- **cycle 211 @endo/common**: §tree-shaking-friendly sibling — cycle 216's §inherit-don't-redescribe is the §design-document analog of cycle 211's §tree-shaking discipline.
- **cycle 215 @endo/hex**: §native-error-rerun-polyfill sibling — both designs say §when-the-fast-path-fails-fall-through-to-the-precise-diagnostic-path.

## §Library-reaches-722-sections at cycle 216 (designs-lane lal-transcript-memory-management).
