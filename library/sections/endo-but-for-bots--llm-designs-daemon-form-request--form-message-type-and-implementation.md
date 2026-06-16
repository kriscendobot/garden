---
title: The §three-scenario problem framing — *LLM agent configuration* (AI coding agent needs API keys / paths / preferences) + *capability requests with parameters* (port number / file path / scope) + *multi-field input* (name + email + role for an invitation); the new `Form` message type that lets any agent send a structured question with named fields, labels, and patterns; the §`FormField` type — *ordered array* of `{name, label, example?, pattern?}` with omitted-pattern defaulting to `M.string()`; the *array vs record* design choice that *separates the semantic key from the display text* (with the record form the object key served as both identifier and placeholder, conflating two distinct concerns); the §`makeForm` envelope-builder that *generates a random messageId via `randomHex256()`* and produces a `type: 'form'` envelope with description + fields (no promise/resolver allocated — *fire-and-forget from the sender's perspective*); the §`form(recipientNameOrPath, description, fields)` guest-facing method — resolves recipient + makeForm + posts + returns (does not block or print); the §`submit(messageNumber, values)` method — calls `getForm` to retrieve the fields array, iterates each `{name, pattern}`, throws if values lacks a key matching name, validates via `mustMatch()` (fields with no pattern default to `M.string()`), marshals via `formulateMarshalValue`, sends a `value` message reply with `replyTo` pointing to form's messageId; the §multi-submission discipline — *Because submit sends a value message reply rather than resolving a promise, it can be called any number of times on the same form*; the §`getForm(messageNumber)` retrieval — looks up + asserts type is `'form'` + returns `{description, fields, messageId, guestHandleId}`; the §`M.interface()` guards — `form`: `M.call(NameOrPathShape, M.string(), M.arrayOf(M.record())).returns(M.promise())`; `submit`: `M.call(MessageNumberShape, M.record()).returns(M.promise())`; the §help text + §`endo form` + §`endo submit` CLI commands with `--field "fieldName:label"` and `-f "fieldName:value"` repeatable args (colon-as-delimiter on first occurrence); the §CLI inbox display extracts field names from the array (`fields.map(f => f.name)`); the §end-to-end CLI walk-through and §Chat UI dual support (modal form builder for sending + inline form rendering with labeled inputs + Submit button for receiving)
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation--common-confusions.md)
