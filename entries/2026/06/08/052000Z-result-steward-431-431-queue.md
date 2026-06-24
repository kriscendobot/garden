---
ts: 2026-06-08T05:20:00Z
kind: result
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 431
    role: target
refs:
  - entries/2026/06/08/045800Z-dispatch-researcher-52156c.md
  - entries/2026/06/08/050232Z-result-researcher-52156c.md
  - entries/2026/06/08/050700Z-dispatch-designer-21f544.md
  - entries/2026/06/08/051720Z-result-designer-21f544.md
  - https://github.com/endojs/endo-but-for-bots/pull/431
---

# result: steward — chat-bridge directive landed as DRAFT PR #431; downstream queue updated

User directive (2026-06-08T04:51Z): *"dispatch a designer to
create or modify (or acknowledge that the design already exists)
that integrates npm chat as a plugin for bridging chat with other
platforms..."*. Researcher → designer chain landed:

- Researcher `52156c` discovered the design **already exists** at
  `designs/endoclaw-channel-bridges.md` (Not Started, 2026-03-03)
  and explicitly names npm `chat` as the recommended foundation.
- Designer `21f544` amended the design with 5 substantive updates
  (DCP refactor, streaming sub-section, edit-history linked-list
  sub-section, `@endo/chat` namespace-collision note, adapter
  enumeration 7→11). Grew 183 → 638 lines.

## DRAFT PR #431 details

- Title: `docs(designs): amend endoclaw-channel-bridges (DCP,
  streaming, edit-history, @endo/chat, adapter refresh)`
- Base: `llm-11a76ae` (frozen base, this cycle)
- Head: `docs/design-endoclaw-channel-bridges-amend`
- Body covers all five updates + daemon-mail-verb gap
  enumeration + tokenized-references / capability-links
  discussion per user directive.
- DRAFT (not panel/judge chained).

## Outstanding queue (awaiting maintainer or user direction)

1. **PR #125** (editMessage + linked-list edit-history):
   kriskowal answered all 4 fixer-questions
   (<https://github.com/endojs/endo-but-for-bots/pull/125#issuecomment-4645600186>).
   Maintainer's resolution per question:
   - Q1: Initial submission reserves slot (immediate); edits
     replace in place (ephemeral); persist chain only on `done`.
   - Q2: Linked-list via `message` formula's new `previous` field
     (option 1, simpler).
   - Q3: Daemon leaves ghost ephemeral on restart; user/agent
     decides cleanup.
   - Q4: No quiescence signal; needs **new `cancelMessage` verb**
     for sender-side cancel.

   **Recommended next**: designer dispatch to update
   `designs/daemon-message-streaming.md` per these answers, then
   re-dispatch the fixer to implement the schema + new
   `cancelMessage` verb. The new chat-bridge amendment in PR
   #431 already cites the settled schema.

2. **PR #404** (chat-inventory-create-menu): 3 sibling-designer
   dispatch requests surfaced by the prior designer dispatch:
   - `chat-inventory-encrypted-formulas` (line 477, maintainer-
     authorized).
   - provider-key recovery/rotation placeholder (line 484,
     maintainer-authorized).
   - `@root` + user-host split (line 363, implied by reframing).

   Each is a researcher+designer pair (6 dispatches total).
   Awaiting user/maintainer call on whether to proceed.

3. **PR #428** (lint validation probe): CLOSED by maintainer
   after the negative result (lint passed; claim not validated).
   No follow-up needed.

4. **PR #133** (chat-pending-commands): fixer dispatch
   `a1b917` was self-paced (shepherd-style). CI is green
   (22/0/0); the dispatch root remains in place pending the
   self-scheduled wakeup. If the maintainer wants un-draft or
   conductor merge, ping needed.

## Dispatch lifecycle

- Researcher `52156c`: torn down. Result entry pushed at
  `2026-06-08/050232Z`.
- Designer `21f544`: torn down. Result entry at
  `2026-06-08/051720Z`. New PR #431 + design diff landed.
- All other dispatch roots from this session: torn down.

Self-improvement: the *"or acknowledge the design already
exists"* clause in the user's directive was load-bearing —
the researcher's gap analysis (already-exists vs amend-vs-
new-sibling) closed the question without speculative-net-new
work. The pattern is worth a one-line note in
`roles/researcher/AGENT.md` § Operating norms: when the
dispatch brief includes an "or acknowledge already-exists"
clause, the researcher's first task is the literal does-it-
already-exist check before walking adjacent material. Routing
to gardener for landing surface.
