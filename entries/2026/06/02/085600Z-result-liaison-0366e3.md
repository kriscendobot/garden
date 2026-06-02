---
host: endolin
role: liaison
dispatch_id: 0366e3
date: 2026-06-02
kind: result
---

# result(librarian, cycle 103): daemon-value-message — the foundational reply-primitive (1 section)

**Cycle**: 103 (pivoted from chat-lane to daemon-design-lane; chat-cluster exhausted as of cycle 99).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/daemon-value-message.md` (331 lines), last touched 2026-03-02 by Kris Kowal (prompted).

## What

Ingested the **Complete** `daemon-value-message` design — the foundational `value`-as-reply primitive that defines a new message type for the *give-a-value-to-another-agent* gap. The 331-line design is *one tight unified proposal* and ingests as a single section.

### Section drafted

1. **Value-message-type-and-reply-only-design** (full file, lines 1-331) — single cohesive ingest. The §opening Problem block frames four downstream consequences of the current `package`-with-empty-template-strings workaround: template-string noise, no clear reply semantics, adopt ceremony, and LLM agent tool results (*the core loop of agentic interaction: human sends task, agent replies with result*). The §Design proposes a new `value` message type carrying exactly one `valueId: FormulaIdentifier` with **required** `replyTo: FormulaNumber` — every value message is a reply. The §`sendValue(messageNumber, petNameOrPath, resultName?)` method on Mail/Host/Guest infers the recipient from the parent message's other-party (same logic as `reply`); looks up the value's formula identifier; constructs the hardened ValueMessage; posts. The §auto-retain mechanism — recipient's `deliver()` writes the value to the pet store under the `resultName` hint when present (zero-ceremony common case while preserving recipient autonomy). The §message hub directory exposes seven edges (FROM/TO/DATE/TYPE/MESSAGE/REPLY/VALUE) with VALUE as the primary payload. The §five Design Decisions: *reply-only* (unsolicited values stay as `package`), *single value* (multi-value uses multiple messages), *auto-retain optional* (resultName is hint, not guarantee), *no promise/resolver infrastructure* (fire-and-forget; value already exists), *recipient inferred from parent* (security-by-topology). The §14-row Files Modified table spans daemon (types.d.ts + mail.js + host.js + guest.js + interfaces.js + help-text.js + daemon.js), cli (endo.js + commands/send-value.js + inbox.js), test (daemon/test/endo.test.js), and chat (inbox-component.js + command-registry.js + command-executor.js). The §Related Designs cross-reference names three sister designs (daemon-form-request as consumer, chat-reply-chain-visualization for connector-line rendering, daemon-capability-bank as future capability-grant-delivery mechanism).

### Library state after this cycle

- **604 sections** (was 603) / **148 sources** (was 147) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~30 daemon-value-message keywords (value message type / required replyTo / sendValue / recipient inferred from parent / security-by-topology / auto-retain / VALUE edge primary payload / fire-and-forget / foundational reply-primitive / 14-row Files Modified / design-doc-as-implementation-tracker).

## Daemon reply-primitive layer

This cycle *complements* cycle 101's `daemon-commands-as-messages` design. Together they form the daemon's *reply-primitive layer*:

- **Cycle 103** `daemon-value-message` (Complete, shipped 2026-03-02) — the *foundational* `value`-as-reply primitive. Every reply with a retained value uses this type.
- **Cycle 101** `daemon-commands-as-messages` (Not Started) — the *consumer*. Every command's result reply is a `value`-typed message with `replyTo` pointing to the command.

The layering: value messages are the *primitive*; commands-as-messages is the *application*. The value-message design stands alone and is shipped; commands-as-messages depends on it and remains proposed.

## Rotation discipline

Cycle 103 was scheduled for chat-lane but chat-cluster is exhausted (21 chat-* designs ingested through cycle 99). Pivoted to daemon-design-lane (following cycle 101's precedent). The §rotation discipline (papers / chat / comments) extends gracefully when a lane runs out.

## Notes

- The §*required `replyTo`* invariant is encoded at the *type level* (the TypeScript typedef), not just the implementation. The §discipline: prevent unsolicited value-messages at compile time. The constraint is structural, not aspirational.
- The §*recipient-inferred-from-parent* rule is a *security feature*: `sendValue` doesn't take a recipient argument, so values can only flow along existing conversation edges. The message-graph topology determines who can receive what; sending to unrelated parties is structurally impossible.
- The §*auto-retain optional* pattern (with `resultName` as a hint, not a guarantee) preserves recipient autonomy while offering ergonomics for the common case. The recipient can ignore the hint or rename after.
- The §*envelope-vs-out-of-band carriage* open question is *honestly unresolved* — the design names the trade-off (envelope visibility vs recipient autonomy) and chose envelope for common-case ergonomics. Future revision could move to out-of-band if recipient autonomy becomes paramount.
- The §14-row Files Modified table is a worked example of the *design-doc-as-implementation-tracker* shape. A new message-type addition needs to touch *every type-aware layer* (typedef + mail + interfaces + Guest/Host wrappers + CLI command + chat rendering); the table surfaces all of it explicitly.

## Next

- Cycle 104 (papers-lane): retry with fresh candidates — *Saltzer-Schroeder 1975 Principle of Least Privilege*; *KeyKOS* (Hardy 1985); *EROS* (Shapiro 1999); fresh URL search for Stiegler-Miller HPL-2006-116.
- Cycle 105 (chat-lane): chat-cluster exhausted. Pivot to broader endo-but-for-bots designs. Promising candidates: daemon-form-request (Implemented; 435 lines — likely 2 sections); daemon-agent-tools (Not Started; 350 lines); daemon-capability-bank (Not Started; 159 lines — single section); familiar-* (10 designs).
- Cycle 106 (comments-lane): `packages/ses/src/error/tame-console.js` (197 lines / ~24% density); `packages/exo/src/exo-makers.js`; `packages/marshal/src/marshal-justin.js`; `packages/patterns/src/keys/compareKeys.js` (264 lines, sister file to checkKey.js).

ScheduleWakeup 1500s for cycle 104.
