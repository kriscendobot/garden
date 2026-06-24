---
title: Connection to the wider library
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

This section is the **canonical *structured-question-via-typed-fields* worked example**. Four threads:

1. **The fields-as-ordered-array-vs-record design choice** — separates *semantic key* from *display text*. The §rationale: previous record form conflated these; the array form gives `name` (key) + `label` (display) + `example` (placeholder) + `pattern` (validation) as four distinct concerns.

2. **The fire-and-forget + multi-submission via value-message-replies pattern** — `form()` returns immediately; submissions produce `value` message replies; multi-submission allowed. Reusable for any *question with potentially-multiple responses* shape.

3. **The daemon-enforced field patterns discipline** — *patterns are a contract, not a hint*. Failed `mustMatch()` throws; Chat UI uses the same patterns to select input widgets. The same `@endo/patterns` language (cycles 102 / 104 / 110 / 115) is consumed here.

4. **The CLI/Chat dual surface** — `endo form` + `endo submit` CLI commands paired with `/form` modal + inline labeled inputs in Chat UI. Both surfaces use the same underlying daemon `form()` + `submit()` methods.

The §design-graph context (form-as-foundational-primitive):

- **Cycle 101** `daemon-commands-as-messages` (Not Started) — named `daemon-form-request` as a *reply-pattern donor*.
- **Cycle 103** `daemon-value-message` (Complete) — the *value-message reply mechanism* this design's `submit` uses.
- **Cycle 107** `daemon-agent-tools` (Not Started) — named `lal-fae-form-provisioning` as a sibling that uses forms for agent setup.
- **Cycle 116** (this ingest) `daemon-form-request` — *the form primitive itself*.

Forms are the *structured-data-entry surface*; value messages are the *result-delivery surface*; together they form the *parameter-and-result* core of the daemon's interaction layer.
