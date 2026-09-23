---
title: See also
source: designs/daemon-form-request.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
source_lines: "1-296 (Problem + Type Definitions + Implementation + Interfaces + Help + CLI + What Works Today)"
topics: [daemon]
status: current
notes: |
  Thirty-first endo-but-for-bots design ingest. **Status:
  Implemented**. The 435-line design defines the `Form` message
  type — *the* structured-question-with-named-fields message type
  that lets any agent send a form to any other agent. Section 1
  covers Problem + Type Definitions + Implementation + Interfaces
  + What Works Today (lines 1-296); section 2 covers Gaps +
  Design Decisions + Related Designs (lines 298-end).
  
  Three structurally interesting moves in section 1: (1) the
  *fields-as-ordered-array-vs-record* design choice that
  *separates the semantic key (name) from the display text
  (label)* — the previous record form conflated them; (2) the
  *fire-and-forget sending + multi-submission via value replies*
  pattern — `form()` returns immediately, doesn't allocate a
  promise; submissions produce `value` message replies with
  `replyTo` pointing to the form's messageId, enabling
  multi-submission; (3) the *daemon-enforced field patterns*
  discipline — daemon validates each submitted value via
  `mustMatch()` against the field's pattern; fields with no
  pattern default to `M.string()`; if a value doesn't match,
  `submit` throws — *patterns are a contract, not a hint*.
  
  Cycle 116 section 1 of 2. The design has substantial structural
  content (10 numbered Design Decisions in section 2) that
  warrants the split. Cycle 116 chose this design as
  *frequently-named in prior cycles* (cycle 101's daemon-commands-
  as-messages, cycle 103's daemon-value-message, cycle 107's
  daemon-agent-tools all cite daemon-form-request as a reply-
  pattern donor or sibling).
parent: endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation
---

- [[daemon]] (topic) — the endo daemon architecture; this design extends the mail system.
- `endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions` — the next section: 5 named Gaps + 10 numbered Design Decisions + pattern-to-widget Chat UI table.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the *value-message reply mechanism* this design's `submit` uses; foundational reply primitive.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names this design as a *reply-pattern donor*.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — uses forms for *form-based capability provisioning*.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — capability framework; *forms could be the mechanism for requesting capability configurations*.
