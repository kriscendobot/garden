---
title: Abstract
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

The §opening Problem block (lines 10-35) frames the *structured-question* gap. Endo agents communicate via inbox messages: free-text (`package`), code-eval (`eval-request` + `definition`), and request-with-promise (`request`/`form-request`/old). *None of these message types provide a way for an agent to ask a structured question — one with named fields, labels, and eventually typed constraints — and receive a structured answer*. The §three motivating scenarios: (1) *LLM agent configuration* — AI coding agent needs API keys / project paths / preference settings from the user; today it must parse free-text or rely on host pre-configuration; (2) *capability requests with parameters* — a guest requesting access to a resource may need to specify parameters (port number, file path, scope); a form lets the host *see exactly what is being asked* and fill values with validation; (3) *multi-field input* — some interactions require several related values at once (e.g., name + email + role for an invitation); collecting these one at a time through separate messages is *fragile and hard to correlate*. The §solution: *the form message type solves this by letting any agent send a structured form to any other agent. The form carries a description and a set of named fields with labels. Recipients respond by submitting values, which arrive as `value` messages replying to the original form. A form can be submitted any number of times*.

The §Type Definitions (lines 41-86) define the `FormField` + `Form` types. `FormField = { name: string; label: string; example?: string; pattern?: unknown }`. `Form = MessageBase & { type: 'form'; replyTo?: FormulaNumber; description: string; fields: FormField[] }`. The §discipline names the *array-vs-record* trade-off: *the array representation guarantees field ordering and separates the semantic field name from the display label, which were previously conflated when the key served double duty as both identifier and display text*. The §`Form` is included in the `Message` union and `MessageFormula` persistence type so form messages survive daemon restarts. The §`Mail` interface exposes `form(recipientNameOrPath, description, fields)` for sending and `getForm(messageNumber)` for retrieving. Both `EndoGuest` and `EndoHost` expose `form()` and `submit()`.

The §Sending a Form (lines 88-113) defines `makeForm` (envelope-builder) + `form` (guest-facing method) + `validateEnvelope`. The §multi-submission discipline:

> Because `submit` sends a `value` message reply rather than resolving a promise, it can be called any number of times on the same form. Each submission produces a new `value` message in the reply chain.

The §Submitting a Form (lines 114-132) defines `submit` — calls `getForm` for the fields array, iterates each `{name, pattern}`, throws if values lacks the key, validates via `mustMatch()` (no-pattern → `M.string()` default), marshals via `formulateMarshalValue`, sends a `value` message with `replyTo` pointing to the form's `messageId`. The §Retrieving (lines 134-144) defines `getForm` — looks up + asserts type is `'form'` + returns `{description, fields, messageId, guestHandleId}`.

The §Interface Guards (lines 146-167) — `form`: `M.call(NameOrPathShape, M.string(), M.arrayOf(M.record())).returns(M.promise())`; `submit`: `M.call(MessageNumberShape, M.record()).returns(M.promise())`. The §Help Text (lines 169-195) provides per-method documentation. The §CLI Commands (lines 197-220) — `endo form <recipient> <description> --as <agent-name> --field "fieldName:label"` (repeatable); `endo submit <message-number> --as <agent-name> -f "fieldName:value"` (repeatable). The §CLI Command Implementations (lines 222-230) — `form.js` parses `--field` as `fieldName:label` pairs using *first colon as delimiter*; `submit.js` parses `--field`/`-f` as `fieldName:value` pairs. The §CLI Inbox Display (lines 232-242) — `0. "fae" sent form "Configure project settings" (fields: projectName, apiKey) at "..."` extracts field names via `fields.map(f => f.name)`.

The §What Works Today (lines 244-296) gives the end-to-end walk-through: CLI flow (form → inbox shows form → submit → another submit) demonstrates multi-submission; Chat UI dual support — *Sending* via `/form` modal form builder (recipient picker + description field + dynamic Add-field rows producing `{name, label}` objects); *Receiving* via inline labeled inputs (`field.label` as display label, `field.example || field.name` as placeholder) + Submit button calling `E(powers).submit()`.
