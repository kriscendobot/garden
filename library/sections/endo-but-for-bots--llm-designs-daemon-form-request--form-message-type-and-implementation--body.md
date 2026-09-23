---
title: Body
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
