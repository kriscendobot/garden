---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/howto-messaging.md
source_commit: 81f1d64b8c28470e44014cf23e7f24805fbda7f3
source_date: 2026-04-09
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 441 designs-lane ingest. 97-line howto-messaging.md
  from @endo/lal's agent-facing primer. Completes the howto-*
  quad alongside howto-code.md (cycle 409), howto-capabilities.md
  (cycle 437), and howto-inventory.md (cycle 439). Eighty-ninth
  AUTHORED conformant single-body section doc in post-refactor
  era. One-hundred-and-thirty-first consecutive non-garden source
  after the pivot (310-441).
  §one-hundred-and-thirty-one-cycles-with-named-pivot-domain-stay.

  Single most structurally interesting move: §the-named-four-
  command-context-lifecycle-vocabulary — lines 35-53 name four
  user-facing strategies for managing conversation context:
  (1) start a new conversation (fresh guest, clean slate), (2)
  reply to a specific message (/reply <msgnum> for thread control),
  (3) dismiss stale messages (/dismiss, /clear), (4) continue
  (accumulate context as baseline). These four strategies form a
  complete vocabulary for managing LLM context lifecycle at the
  user level. Endo treats context accumulation as a first-class
  architectural concern with four named operations at the human-UI
  layer. §the-named-four-command-context-lifecycle-vocabulary as
  tier-3 meta-pattern.

  §the-named-threaded-reply-anchored-to-message-number-at-both-
  surfaces — /reply <msgnum> (user layer) mirrors reply(messageNumber,
  ...) (agent layer, cycle 413). Threading discipline consistent:
  reply is positional and anchor is explicit at both surfaces.

  §the-named-adopt-as-user-facing-cap-transfer-with-dual-naming —
  /adopt <msgnum> <edge-name> -n <pet-name> exposes the same dual-
  naming pattern cycle 413 named: sender's edge name vs receiver's
  pet name; two distinct names one per side of the trust boundary.

  §the-named-grantor-perspective-on-request-resolve-reject — cycle
  437 named the request-resolve flow from the requester's perspective;
  howto-messaging.md names it from the granter's perspective (/resolve
  <msgnum> cap or /reject <msgnum>). Both sides of the three-party
  protocol are now grounded.

  §the-named-form-as-bidirectional-structured-communication — /form
  @recipient shows users can INITIATE forms, not just receive them.
  Forms are a general structured-communication tool, not exclusively
  agent-to-user.

  §the-named-chat-as-primary-messaging-surface-cli-as-automation-
  complement — CLI messaging equivalents (endo send, endo reply,
  endo adopt) exist but are for scripting; Chat is the primary
  interactive surface.

  §the-named-eighty-nine-conformant-cycles-and-counting.

  The howto-* quad is now complete: howto-code (cycle 409) +
  howto-capabilities (cycle 437) + howto-inventory (cycle 439) +
  howto-messaging (cycle 441). All four user-facing howto documents
  in the lal/primer are ingested.

  Closes ten citation arcs: cycle 440 (1, adjacent forward) +
  cycle 439 (3, howto-* quad complete) + cycle 437 (3, granter
  perspective on request-resolve-reject) + cycle 413 (5, MAJOR
  COMPLETION — user-facing messaging grounds agent-facing protocol;
  threading, dual-naming, dismiss discipline all confirmed at user
  layer) + cycle 409 (3, Chat-as-primary confirmed) + cycle 326
  (75) + cycle 322 (75) + cycle 405 (3, three-surfaces framing
  grounded at user layer) + cycle 403 (3, reply-and-dismiss
  discipline confirmed at user layer) + cycle 412 (3, user-facing
  side of protocol cycle 412 addressed at provider layer). Pushes
  citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-SEVENTY-TWO
  (862 + 10 net new).
---

97-line howto-messaging.md from @endo/lal's agent-facing primer. Completes the howto-* quad alongside howto-code.md (cycle 409), howto-capabilities.md (cycle 437), and howto-inventory.md (cycle 439). Designs-lane after cycle 440 chat-lane familiar/src/protocol-handler.js. **Single most structurally interesting move**: §the-named-four-command-context-lifecycle-vocabulary — *lines 35-53 name four user-facing strategies for managing conversation context: (1) start a new conversation (fresh guest, clean slate), (2) reply to a specific message (/reply <msgnum> for thread control), (3) dismiss stale messages (/dismiss, /clear), (4) continue accumulating context as baseline. These form a complete vocabulary for managing LLM context lifecycle at the user level; Endo treats context accumulation as a first-class architectural concern with four named operations at the human-UI layer.* §the-named-four-command-context-lifecycle-vocabulary as tier-3 meta-pattern. §the-named-threaded-reply-anchored-to-message-number-at-both-surfaces (user /reply <msgnum> mirrors agent reply(messageNumber,...); threading discipline consistent at both surfaces). §the-named-adopt-as-user-facing-cap-transfer-with-dual-naming (cycle 413's dual-naming pattern confirmed at user layer via /adopt <msgnum> <edge-name> -n <pet-name>). §the-named-grantor-perspective-on-request-resolve-reject (cycle 437's requester perspective complemented with granter perspective; three-party protocol grounded from both sides). §the-named-form-as-bidirectional-structured-communication (users can INITIATE forms, not just receive them; forms are general structured-communication). §the-named-chat-as-primary-messaging-surface-cli-as-automation-complement. §the-named-eighty-nine-conformant-cycles-and-counting. The howto-* quad is now complete. Ten citation arcs closed; pushes citation-arc-closures-in-pivot to EIGHT-HUNDRED-AND-SEVENTY-TWO.

| Section | Topics | Status |
|---------|--------|--------|
| [four-command-context-lifecycle-vocabulary](../sections/endo-but-for-bots--packages-lal-primer-howto-messaging-md--four-command-context-lifecycle-vocabulary.md) | messaging, capability-security, daemon | current |
