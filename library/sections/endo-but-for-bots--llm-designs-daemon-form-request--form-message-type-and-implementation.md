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
---

## Abstract

The §opening Problem block (lines 10-35) frames the *structured-question* gap. Endo agents communicate via inbox messages: free-text (`package`), code-eval (`eval-request` + `definition`), and request-with-promise (`request`/`form-request`/old). *None of these message types provide a way for an agent to ask a structured question — one with named fields, labels, and eventually typed constraints — and receive a structured answer*. The §three motivating scenarios: (1) *LLM agent configuration* — AI coding agent needs API keys / project paths / preference settings from the user; today it must parse free-text or rely on host pre-configuration; (2) *capability requests with parameters* — a guest requesting access to a resource may need to specify parameters (port number, file path, scope); a form lets the host *see exactly what is being asked* and fill values with validation; (3) *multi-field input* — some interactions require several related values at once (e.g., name + email + role for an invitation); collecting these one at a time through separate messages is *fragile and hard to correlate*. The §solution: *the form message type solves this by letting any agent send a structured form to any other agent. The form carries a description and a set of named fields with labels. Recipients respond by submitting values, which arrive as `value` messages replying to the original form. A form can be submitted any number of times*.

The §Type Definitions (lines 41-86) define the `FormField` + `Form` types. `FormField = { name: string; label: string; example?: string; pattern?: unknown }`. `Form = MessageBase & { type: 'form'; replyTo?: FormulaNumber; description: string; fields: FormField[] }`. The §discipline names the *array-vs-record* trade-off: *the array representation guarantees field ordering and separates the semantic field name from the display label, which were previously conflated when the key served double duty as both identifier and display text*. The §`Form` is included in the `Message` union and `MessageFormula` persistence type so form messages survive daemon restarts. The §`Mail` interface exposes `form(recipientNameOrPath, description, fields)` for sending and `getForm(messageNumber)` for retrieving. Both `EndoGuest` and `EndoHost` expose `form()` and `submit()`.

The §Sending a Form (lines 88-113) defines `makeForm` (envelope-builder) + `form` (guest-facing method) + `validateEnvelope`. The §multi-submission discipline:

> Because `submit` sends a `value` message reply rather than resolving a promise, it can be called any number of times on the same form. Each submission produces a new `value` message in the reply chain.

The §Submitting a Form (lines 114-132) defines `submit` — calls `getForm` for the fields array, iterates each `{name, pattern}`, throws if values lacks the key, validates via `mustMatch()` (no-pattern → `M.string()` default), marshals via `formulateMarshalValue`, sends a `value` message with `replyTo` pointing to the form's `messageId`. The §Retrieving (lines 134-144) defines `getForm` — looks up + asserts type is `'form'` + returns `{description, fields, messageId, guestHandleId}`.

The §Interface Guards (lines 146-167) — `form`: `M.call(NameOrPathShape, M.string(), M.arrayOf(M.record())).returns(M.promise())`; `submit`: `M.call(MessageNumberShape, M.record()).returns(M.promise())`. The §Help Text (lines 169-195) provides per-method documentation. The §CLI Commands (lines 197-220) — `endo form <recipient> <description> --as <agent-name> --field "fieldName:label"` (repeatable); `endo submit <message-number> --as <agent-name> -f "fieldName:value"` (repeatable). The §CLI Command Implementations (lines 222-230) — `form.js` parses `--field` as `fieldName:label` pairs using *first colon as delimiter*; `submit.js` parses `--field`/`-f` as `fieldName:value` pairs. The §CLI Inbox Display (lines 232-242) — `0. "fae" sent form "Configure project settings" (fields: projectName, apiKey) at "..."` extracts field names via `fields.map(f => f.name)`.

The §What Works Today (lines 244-296) gives the end-to-end walk-through: CLI flow (form → inbox shows form → submit → another submit) demonstrates multi-submission; Chat UI dual support — *Sending* via `/form` modal form builder (recipient picker + description field + dynamic Add-field rows producing `{name, label}` objects); *Receiving* via inline labeled inputs (`field.label` as display label, `field.example || field.name` as placeholder) + Submit button calling `E(powers).submit()`.

## Body

### §The three-scenario problem framing

The §opening lines (12-29) name *structured-question + structured-answer* as the missing surface:

> Endo agents communicate through a message-passing inbox system that currently supports free-text requests, code evaluation proposals, and package sends. None of these message types provide a way for an agent to ask a structured question — one with named fields, labels, and eventually typed constraints — and receive a structured answer.

The §three scenarios:

**§(1) LLM agent configuration**:

> An AI coding agent needs API keys, project paths, or preference settings from the user. Today it must parse free-text responses or rely on the host to pre-configure values.

The §LLM-motivation framing names *parse-free-text-or-rely-on-pre-config* as the current workaround. Forms eliminate the parsing burden by letting the agent specify *exactly what it needs*.

**§(2) Capability requests with parameters**:

> A guest requesting access to a resource may need to specify parameters (port number, file path, scope). A form lets the host see exactly what is being asked and fill in values with validation.

The §capability-request framing connects to cycle 105's `daemon-capability-bank` and cycle 107's `daemon-agent-tools`. A capability grant may have *parameters* (a Dir capability needs a path; a Shell capability needs an allowlist). The form is the canonical *parameter-collection mechanism*.

**§(3) Multi-field input**:

> Some interactions require several related values at once (e.g., name + email + role for an invitation). Collecting these one at a time through separate messages is fragile and hard to correlate.

The §correlation argument: multiple separate messages would require the recipient to *track which message is responding to which*. Forms bundle related fields atomically.

The §discipline: *enumerate concrete scenarios* before designing the type. The §three-scenario framing makes the design's value visible: it's not just *another message type*; it's *the structured-question surface* for three concrete use cases.

### §The fields-as-array-vs-record design choice

The §`FormField` type (lines 47-53):

```ts
export type FormField = {
  name: string;
  label: string;
  example?: string;
  pattern?: unknown;
};
```

The §rationale (lines 72-74):

> The array representation guarantees field ordering and separates the semantic field name from the display label, which were previously conflated when the key served double duty as both identifier and display text.

The §two structural moves:

- **Array preserves ordering** — `FormField[]` is order-deterministic. A `Record<string, ...>` doesn't guarantee key iteration order (though modern V8 does, ECMA-262 doesn't require it for arbitrary records).
- **Separates name (semantic key) from label (display text)** — previously the record key served *both* roles; the array form has explicit `name` + `label` fields.

The §`example` and `pattern` optional fields:

- **`example?: string`** — placeholder text for the input. Independent of `name` and `label`.
- **`pattern?: unknown`** — Passable pattern from `@endo/patterns` (cycles 102 / 104 / 110 / 115). When omitted, defaults to `M.string()`.

The §design intent: *the four FormField properties cover four distinct concerns*. The array-of-records shape is *more verbose than the record-shape* but *correctly separates* concerns that were previously conflated.

### §The Form message type and persistence

The §`Form` type (lines 55-61):

```ts
export type Form = MessageBase & {
  type: 'form';
  replyTo?: FormulaNumber;
  description: string;
  fields: FormField[];
};
```

The §five-field shape:

- **`type: 'form'`** — discriminator.
- **Inherits `MessageBase`** — `from`, `to`, `date`, `number`, `messageId`.
- **`replyTo?: FormulaNumber`** — optional reply-to (forms can reply to other forms).
- **`description: string`** — the form's prompt/heading.
- **`fields: FormField[]`** — the ordered field array.

The §persistence: *`Form` is included in the `Message` union type and in the `MessageFormula` persistence type, which means form messages survive daemon restarts*. The §discipline: *durable forms*. A form sent before a daemon restart is recoverable after restart.

### §The fire-and-forget + multi-submission patterns

The §`form` method semantic (lines 101-106):

> 1. Resolves the recipient name to a handle.
> 2. Calls `makeForm` to create the envelope.
> 3. Posts the form to the recipient via `post(to, req)`.
> 4. Returns. Does not block or print output.

The §`form()` is *fire-and-forget* — it sends the form and returns immediately. *No promise or resolver is allocated*. The §discipline: *the caller discovers responses by watching for `value` messages whose `replyTo` matches the form's `messageId`*.

The §multi-submission discipline (lines 130-132):

> Because `submit` sends a `value` message reply rather than resolving a promise, it can be called any number of times on the same form. Each submission produces a new `value` message in the reply chain.

The §rationale: *promise-based responses* would be *single-response*. *Value-message replies* allow:

- **Corrections** — host realizes they typed the wrong API key; resubmit.
- **Multiple-agent responses** — if the form is somehow shared (future feature), each agent can submit.
- **Reply-chain history** — each submission is a separate `value` message; the chain shows the full history.

The §discipline is reusable for any *form-question that benefits from multi-response*.

### §The daemon-enforced field patterns

The §`submit` validation (lines 118-128):

```
1. Calls getForm(messageNumber) to retrieve the form's fields array.
2. Iterates each {name, pattern} in the fields array. For each field:
   - Throws if values does not contain a key matching name.
   - Validates the value against pattern using mustMatch(). Fields with
     no explicit pattern default to M.string().
3. Marshals the values record via formulateMarshalValue so it can be
   stored as a formula.
4. Sends a value message with replyTo pointing to the form's messageId,
   carrying the marshalled values as the valueId.
```

The §two layers of validation:

- **Key-presence** — `values` must contain a key matching each field's `name`. Missing fields throw immediately.
- **Pattern match** — each value validated against its field's `pattern` via `mustMatch()`. Failed match throws.

The §default pattern is `M.string()` when none is specified. The §rationale: *backward-compatible default*. Forms with simple string fields don't need explicit patterns.

The §marshalling: `formulateMarshalValue` produces a passable form of `values` (a record), and that record becomes the `valueId` payload of the reply `value` message. The §discipline: *forms produce structured replies via the durable value-message pattern from cycle 103*.

The §`submit` is the *type-checked-data-entry* surface: the daemon enforces field patterns at submission time; the caller cannot send malformed values.

### §The CLI surface — endo form + endo submit

The §`endo form` (lines 201-210):

```
endo form <recipient> <description> \
  --as <agent-name> \
  --field <field>  (repeatable, format "fieldName:label")
```

The §`endo submit` (lines 213-218):

```
endo submit <message-number> \
  --as <agent-name> \
  -f, --field <field>  (repeatable, format "fieldName:value")
```

The §`--field` repeatable arg pattern with `fieldName:label` and `fieldName:value` colon-delimited formats. The §colon-as-delimiter parses the *first* colon only, so labels and values can contain colons themselves (e.g., `apiKey:sk-abc:def-123` parses as `{name: 'apiKey', value: 'sk-abc:def-123'}`).

The §CLI inbox display (line 239):

```
3. "@host" sent form "Configure settings" (fields: name, email) at "2026-02-25T..."
```

The §`fields: name, email` extracts the names via `fields.map(f => f.name)`. The §discipline: *show field names in inbox preview*; the labels are seen at submission time.

### §The Chat UI dual support

The §Chat UI (lines 282-296) supports both sending and receiving forms:

**Sending** — `/form` modal:

> The `/form` command opens a modal form builder with a recipient picker, description field, and dynamic "Add field" rows for name+label pairs. The form builder produces an array of `{ name, label }` objects.

**Receiving** — inline rendering:

> Form messages render inline in the inbox with labeled input fields. Each field uses `field.label` as the display label and `field.example || field.name` as the placeholder. A Submit button calls `E(powers).submit()` with the collected values keyed by field name.

The §placeholder fallback `field.example || field.name`: if `example` is provided, use it; otherwise fall back to the field's `name`. The §discipline: *graceful-fallback for placeholders* — every field has *something* visible in the input.

### §The end-to-end CLI walk-through

The §lines 251-278 demonstrate the full multi-submission flow:

```bash
# Guest "fae" asks Host for configuration
endo form @host "Configure project settings" \
  --as fae \
  --field "projectName:Project name" \
  --field "apiKey:API key"

# Host sees the form
endo inbox
# => 0. "fae" sent form "Configure project settings" (fields: projectName, apiKey) at "..."

# Host submits values
endo submit 0 -f "projectName:my-app" -f "apiKey:sk-1234"

# Guest sees the value message
endo inbox --as fae
# => 1. "@host" sent value in reply to #0 at "..."

# Host can submit AGAIN with corrected values
endo submit 0 -f "projectName:my-app" -f "apiKey:sk-5678"
```

The §multi-submission is *demonstrated* not just *claimed*: the same `endo submit 0 ...` is called twice; both produce separate `value` messages. The §discipline: *every claim demonstrated end-to-end via CLI examples*.

## Connection to the wider library

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

## Translation block (design idiom → contemporary practice)

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

## See also

- [[daemon]] (topic) — the endo daemon architecture; this design extends the mail system.
- `endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions` — the next section: 5 named Gaps + 10 numbered Design Decisions + pattern-to-widget Chat UI table.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the *value-message reply mechanism* this design's `submit` uses; foundational reply primitive.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names this design as a *reply-pattern donor*.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — uses forms for *form-based capability provisioning*.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — capability framework; *forms could be the mechanism for requesting capability configurations*.

## Common confusions

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
