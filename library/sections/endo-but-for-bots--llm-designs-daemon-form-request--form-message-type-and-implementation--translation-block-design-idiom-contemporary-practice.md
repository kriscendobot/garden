---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `FormField` ordered array vs `Record<string, {label}>` | The *separate-key-from-display-text* discipline; record-key conflated identifier with placeholder. |
| `pattern?: unknown` with default `M.string()` | The *patterns-from-@endo/patterns + default-to-string* discipline. |
| `fire-and-forget from the sender's perspective` | The *send-and-return-no-promise* discipline; caller polls for `value` replies. |
| `multi-submission via value replies` | The *replies-as-multi-response* pattern; corrections + reply-chain history. |
| `mustMatch()` daemon-side enforcement | The *patterns-are-a-contract-not-a-hint* discipline. |
| `formulateMarshalValue` for the values record | The *make-the-reply-a-formula* discipline; reply is durable. |
| `fields.map(f => f.name)` for inbox display | The *show-names-in-preview-labels-at-submit* discipline. |
| `--field "fieldName:label"` colon-on-first-occurrence | The *colon-as-name/value-delimiter* CLI shape. |
| `field.example \|\| field.name` placeholder fallback | The *graceful-placeholder-fallback* discipline. |
| `/form` modal in Chat UI | The *modal-builder-for-variable-field-count* idiom. |
