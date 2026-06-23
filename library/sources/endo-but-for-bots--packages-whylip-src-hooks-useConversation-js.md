---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/whylip/src/hooks/useConversation.js
source_commit: 1f7015e35e1d3f619342a25db83e258461105ed0
source_date: 2026-03-26
source_authors: [Kris Kowal, Dan Finlay, kumavis]
ingested: 2026-06-23
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 452 chat-lane ingest. 444-line React hook from
  @endo/whylip/src/hooks — the complete Whylip conversation
  state machine. Confirms dual-backend framing from cycle
  443 README: MemoryBackend is hard-coded (never configured);
  reconstruction from mailbox ordering is the invariant.
  One-hundred-and-forty-second consecutive non-garden
  source after the pivot (310-452). One hundredth AUTHORED
  conformant single-body section doc in post-refactor era
  (cycles 353-452). 100-CYCLE MILESTONE.

  Single most structurally interesting move:
  §the-named-format-retry-as-client-side-llm-correction-protocol
  — when parseResponse returns a parseError (the response
  looked like JSON but failed to parse) and MAX_FORMAT_RETRIES
  (= 1) is not exhausted, the hook sends the error back to
  Fae as an ordinary CapTP message. Fae receives it as a user
  message and retries with a corrected format. No Fae-side
  awareness of the error protocol is required; the CapTP
  message channel doubles as the correction channel.
  §the-named-single-retry-cap-for-correction-loop as tier-3
  meta-pattern: the max-retry constant is the correctness
  constraint preventing infinite correction loops.

  Nine citation arcs closed; pushes citation-arc-closures-
  in-pivot to NINE-HUNDRED-AND-FIFTY-THREE (944 + 9 net new).
---

444-line `packages/whylip/src/hooks/useConversation.js` — the React hook implementing Whylip's complete conversation state machine. Manages the local `ConversationTree` instance (MemoryBackend, hard-coded), syncs from the CapTP mailbox in two phases (batch init from `listMessages()`, live streaming via `followMessages()`), provides `send` / `navigateTo` / `nodes` / `activeNodeId` / `activeScene` / `activeNarrative` / `sending` to rendering components. The hook is the implementation grounding for the dual-backend architectural framing introduced in cycle 443's README: `MemoryBackend` is not chosen via config — it is the only backend the hook ever constructs. Chat-lane after cycle 451 designs-lane ocapn-tcp-syrups-framing.md. 100-CYCLE MILESTONE (100th conformant cycle since the cycle-353 pivot).

## Section list

| Section | Topics | Status |
|---------|--------|--------|
| [three-tier-parse-cascade-with-format-retry-loop-and-mailbox-streaming-sync](../sections/endo-but-for-bots--packages-whylip-src-hooks-useConversation-js--three-tier-parse-cascade-with-format-retry-loop-and-mailbox-streaming-sync.md) | chat-ui, captp, eventual-send | current |
