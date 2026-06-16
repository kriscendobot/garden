---
title: Common confusions
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

- **"`fields: FormField[]` is just a `Record<string, ...>` with extra steps."** The array *guarantees ordering*; records don't (per ECMA-262, though modern engines do preserve key order). And the array *separates `name` from `label`*; the record form conflated them.
- **"`form()` returning without a result is awkward — the caller has to poll."** It is — *intentionally*. The §multi-submission discipline requires *multiple results over time*; promises would force *one result*. The caller's polling-or-event-listener for `value` messages with matching `replyTo` is the canonical *multi-response observation* shape.
- **"`mustMatch()` could reject a valid value."** It rejects values that *don't match the field's pattern*. The §discipline: *patterns are a contract*; the field author specified what values are acceptable; values that don't match are *not acceptable*.
- **"Default `M.string()` is too restrictive — what about numbers?"** The default applies *only when no pattern is specified*. Fields that need numbers should specify `M.number()`. The default is for *the most-common case (free-text input)*.
- **"`form()` is a `EndoGuest` method — can `EndoHost` also send forms?"** Yes — both `EndoGuest` and `EndoHost` expose `form()` and `submit()`. The §discipline: *any agent can send a form to any other agent*. The host-vs-guest distinction is about *who controls the powers*, not *who can send forms*.
- **"`endo submit 0` runs twice in the example — that's a bug."** It's *the multi-submission demonstration*. The first submit sends one `value` reply; the second submit sends another. Both replies live in the reply-chain history. The §discipline: *multi-submission is a feature, not a bug*.
- **"`--field "fieldName:label"` with colons in labels is ambiguous."** It's *unambiguous via first-colon-only parsing*. The CLI parses up to the *first* colon as the name; everything after is the label/value. Labels containing colons (e.g., `"Format: YYYY-MM-DD"`) work correctly.
- **"Chat UI modal vs inline render is inconsistent."** It's *role-specific*. The modal is for *constructing* a new form (sender's role); the inline render is for *responding* to a received form (recipient's role). Different roles need different UX.
- **"`field.example || field.name` placeholder is just falling back."** It's *graceful fallback*. If the form author provided an example, show it; otherwise show the field's identifier. The §discipline: *every input always has visible guidance*.
- **"`Form` extending `MessageBase` is just inheritance."** It's *type-system positioning*. `MessageBase` provides the standard message fields (from, to, date, number, messageId); `Form` adds form-specific fields (description, fields). The §discipline: *one base type with type-specific extensions*.
