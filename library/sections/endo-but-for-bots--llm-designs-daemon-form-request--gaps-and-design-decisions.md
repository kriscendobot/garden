---
title: The §five named Gaps documenting what's *not yet implemented* — *no forwarding or sharing* (host cannot forward a form to another agent), *replyTo and messageId should use FormulaIdentifier* (currently FormulaNumber is node-local; not multi-node-ready), *limited pattern vocabulary* (Chat UI widgets only cover M.string/number/boolean/scalar; richer patterns validated server-side but fall back to text input; CLI has no way to specify patterns), *CLI values are strings only* (`--field` parser produces `Record<string, string>` but daemon accepts arbitrary passables — *the CLI's string-only limitation is a CLI concern, not a daemon design constraint*), *no reusable form templates* (each `form()` call constructs fields inline); the §ten numbered Design Decisions with concrete rationale: (1) *fields-as-ordered-array-not-record* (separates semantic key from display text); (2) *multi-submission via value replies* (instead of single-response promise/resolver pattern; corrections + multi-agent + reply-chain history); (3) *fire-and-forget sending* (no promise allocated; simplifies internals — no formulatePromise, no PROMISE/RESOLVER/RESULT edges); (4) *daemon-enforced field patterns* via `mustMatch()` (*patterns are a contract, not a hint*); (5) *values support capability references* (form values are full passables including capability references resolved from pet names; CLI's string-only is CLI concern not daemon); (6) *no form templates* (agents can build their own abstractions for reuse; no new formula type needed); (7) *`/submit` command in Chat UI* — pattern-driven widget selection: `M.string()` → text input, `M.number()` → number input, `M.boolean()` → checkbox, `M.remotable()`/`M.promise()` → pet-name path selector, `M.scalar()` → text input, unrecognized → text input fallback; number input may infer min/max from `M.gte(0)`/`M.lte(100)` guards; (8) *modal form builder for /form command* (recipient picker + description field + dynamic Add-field button; --name option removed since responses no longer promise-based); (9) *inline form rendering in inbox* (both sender and receiver see input fields and can submit; previous submissions appear as value messages in reply chain below); (10) *simplified internals* — makeForm generates messageId + envelope without promise/resolver pair; makeStampedMessage doesn't reconstruct promises for forms; makeMessageFormula doesn't store promiseId/resolverId; message hub registers only DESCRIPTION + standard FROM/TO/DATE/TYPE/MESSAGE edges (no PROMISE/RESOLVER/RESULT); the §three Related Designs (`daemon-value-message`, `daemon-capability-persona`, `daemon-capability-bank`)
source: designs/daemon-form-request.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
source_lines: "298-435 (Gaps + Design Decisions + Related Designs)"
topics: [daemon]
status: current
notes: |
  Section 2 of cycle 116's daemon-form-request ingest (sister to
  section 1 which covers Problem + Type + Implementation + What
  Works Today). This section captures the *rationale and remaining
  work* layer: 5 named Gaps + 10 numbered Design Decisions + 3
  Related Designs.
  
  Three structurally important moves in section 2: (1) the *5-gap
  enumeration* names what's *not yet done* honestly — no
  forwarding/sharing, FormulaNumber-not-FormulaIdentifier (forward-
  safety concern for multi-node), limited pattern-to-widget
  vocabulary, CLI string-only limitation, no reusable templates;
  (2) the *10-numbered-decision* rationale block — each decision
  is justified with a one-paragraph explanation; the *pattern → widget* table in decision (7) names the 6-pattern Chat UI widget mapping with extensible-by-pattern discipline; (3) the *simplified internals* (decision 10) names what's *not* allocated — no formulatePromise, no PROMISE/RESOLVER/RESULT edges in the message hub — making the fire-and-forget claim concrete at the implementation level.
  
  The §6-pattern Chat UI widget table is reusable for any
  *pattern-driven dynamic form rendering* situation. The §extensible-
  by-pattern discipline (unrecognized patterns fall back to text
  input) preserves forward-compatibility as new patterns are added.
---

## Abstract

The §Gaps section (lines 298-334) enumerates five named limitations:

- **§No forwarding or sharing** (lines 300-303) — *A host cannot forward a form to another agent for them to answer. The form is delivered to the original recipient's mailbox only*.
- **§`replyTo` and `messageId` should use `FormulaIdentifier`** (lines 305-313) — currently `FormulaNumber` (node-local); *safe in the current single-node implementation but will not generalize to multi-node messaging where a reply may reference a message on a different node. All message types that inherit from `MessageBase` — including `Form` — should migrate `replyTo` and `messageId` to `FormulaIdentifier` for forward safety*.
- **§Limited pattern vocabulary** (lines 315-322) — Chat UI widgets cover only `M.string()`, `M.number()`, `M.boolean()`, `M.scalar()`; richer patterns (`M.or()`, `M.arrayOf()`, record shapes) are validated server-side but fall back to text input. *The CLI has no way to specify patterns; all fields default to `M.string()`*.
- **§CLI values are strings only** (lines 324-328) — *The CLI `--field` parser produces `Record<string, string>`. The daemon's `submit` accepts `Record<string, unknown>` and marshals arbitrary passables, but the CLI cannot express numbers, booleans, or references*.
- **§No reusable form templates** (lines 330-334) — *Each `form()` call constructs the fields inline. There is no way to define a form template once and reuse it across multiple requests*.

The §Design Decisions section (lines 336-424) names ten numbered rationale points:

1. **Fields as an ordered array, not a record** (lines 338-346) — separates `name` (semantic key) from `label` (display text); array guarantees ordering; allows `example` placeholder property independent of name and label.
2. **Multi-submission via value replies** (lines 348-353) — *Instead of the single-response promise/resolver pattern, form submissions produce `value` messages replying to the original form. This allows any number of responses: the host can correct mistakes, multiple agents can respond if the form is forwarded, and the reply chain provides a natural history of submissions*.
3. **Fire-and-forget sending** (lines 355-360) — *`form()` sends the form and returns immediately. It does not allocate a promise or block waiting for a response. Callers discover responses by watching for `value` messages with matching `replyTo`. This simplifies the internal machinery — no `formulatePromise`, no `PROMISE`/`RESOLVER`/`RESULT` edges in the message hub*.
4. **Daemon-enforced field patterns** (lines 362-368) — *The daemon validates each submitted value against its field's `pattern` using `mustMatch()`. Fields with no explicit `pattern` default to `M.string()`. If a value does not match, `submit` throws — patterns are a contract, not a hint. The Chat UI uses the same patterns to select appropriate input widgets (text, number, checkbox), providing client-side guidance that complements server-side enforcement*.
5. **Values support capability references** (lines 370-374) — *Form values are full passables, including capability references resolved from pet names. This enables use cases like "which worker should I use?" where the answer is a live reference. The CLI's string-only limitation is a CLI concern, not a daemon design constraint*.
6. **No form templates** (lines 376-378) — *Forms are always constructed inline in each `form()` call. Agents can build their own abstractions for reuse. No new formula type needed*.
7. **`/submit` command in Chat UI** (lines 380-403) — the centerpiece of section 2. Names the *pattern → widget* mapping table.
8. **Modal form builder for `/form` command** (lines 405-410) — *Sending a form uses a modal dialog (like the `/js` eval form) with a recipient picker, description field, dynamic "Add field" button for name+label rows. The `--name` option for response naming is removed since form responses are no longer promise-based. The modal pattern handles the variable number of fields naturally, following the established eval-form endowments UI pattern*.
9. **Inline form rendering in inbox** (lines 412-417) — *Form messages render inline in the message stream with labeled input fields and a Submit button. Both sender and receiver see input fields and can submit values. The inline form uses `field.label` for the display label and `field.example || field.name` for the input placeholder. Previous submissions appear as `value` messages in the reply chain below the form*.
10. **Simplified internals** (lines 419-424) — *`makeForm` generates a `messageId` and envelope without allocating any promise/resolver pair. `makeStampedMessage` does not reconstruct promises for form messages. `makeMessageFormula` does not store `promiseId` or `resolverId`. The message hub registers only `DESCRIPTION` and standard edges (`FROM`, `TO`, `DATE`, `TYPE`, `MESSAGE`) — no `PROMISE`, `RESOLVER`, or `RESULT` edges*.

The §Related Designs (lines 426-435) cross-references three sister designs: `daemon-value-message` (the value-message reply mechanism this design uses), `daemon-capability-persona` (forms could carry sender identity), `daemon-capability-bank` (forms could be the mechanism for requesting capability configurations).

## Body

### §The five Gaps — honest current-state limitations

The §Gaps section is *honest current-state-with-named-limitations*. Each gap names *what's missing* and (where applicable) *why it's deferred*.

**§Gap 1: No forwarding or sharing**:

> A host cannot forward a form to another agent for them to answer. The form is delivered to the original recipient's mailbox only.

The §discipline: *forms are point-to-point, not broadcast*. Forwarding would require additional design (who can submit? who sees the responses?). The §future-extension is named without committing to implementation.

**§Gap 2: `replyTo` / `messageId` should use `FormulaIdentifier`**:

> The `replyTo` and `messageId` fields on `MessageBase` are typed as `FormulaNumber` (node-local), not `FormulaIdentifier` (node-qualified). This is safe in the current single-node implementation but will not generalize to multi-node messaging where a reply may reference a message on a different node. All message types that inherit from `MessageBase` — including `Form` — should migrate `replyTo` and `messageId` to `FormulaIdentifier` for forward safety.

The §forward-safety concern: *FormulaNumber is single-node-only*. Multi-node messaging requires *node-qualified* identifiers. The §discipline: *name the future-incompatibility now even though the current impl works*.

**§Gap 3: Limited pattern vocabulary**:

> The daemon validates field values against patterns, but only a small set of patterns (`M.string()`, `M.number()`, `M.boolean()`, `M.scalar()`) have corresponding Chat UI widgets. Richer patterns (e.g., `M.or()`, `M.arrayOf()`, record shapes) are validated server-side but have no specialized input rendering — they fall back to a text input.

The §discipline: *server-side validation is universal; client-side rendering is opportunistic*. The richer patterns work for daemon validation; the Chat UI just shows a text input for them.

The §`The CLI has no way to specify patterns; all fields default to `M.string()`* observation is the *CLI-extensibility gap*. The CLI surface is *intentionally simple* (strings only); the daemon surface is *intentionally rich* (full pattern language).

**§Gap 4: CLI values are strings only**:

> The CLI `--field` parser produces `Record<string, string>`. The daemon's `submit` accepts `Record<string, unknown>` and marshals arbitrary passables, but the CLI cannot express numbers, booleans, or references.

The §honest *CLI-vs-daemon-asymmetry* admission: the daemon is more capable than the CLI. Programmatic callers (Chat UI, other agents) can use the full range; CLI users get strings only.

**§Gap 5: No reusable form templates**:

> Each `form()` call constructs the fields inline. There is no way to define a form template once and reuse it across multiple requests, or to share form definitions between agents.

The §discipline: *templates are deferred to agent-level abstractions*. The §rationale (in Decision 6): *Agents can build their own abstractions for reuse. No new formula type needed*.

### §The ten-decision rationale block

The §Design Decisions are *the canonical-rationale-list*. Each decision names *what was chosen* and *why*. Reading the decisions in order reveals the design's *internal logic*.

**§Decision 1 — Fields as ordered array** (covered in section 1's §array-vs-record discussion).

**§Decision 2 — Multi-submission via value replies**:

> Instead of the single-response promise/resolver pattern, form submissions produce `value` messages replying to the original form. This allows any number of responses: the host can correct mistakes, multiple agents can respond if the form is forwarded, and the reply chain provides a natural history of submissions.

The §three motivations:

- **Corrections** — multiple submits possible.
- **Forwarding** — *if forms could be forwarded* (Gap 1), multiple agents could respond.
- **Reply-chain history** — every submission is a separate `value` message; chain visible in inbox.

The §pattern: *replies-are-multi-response-by-construction*. Single-response promises would foreclose this.

**§Decision 3 — Fire-and-forget sending**:

> `form()` sends the form and returns immediately. It does not allocate a promise or block waiting for a response.

The §benefit (named explicitly): *simplifies the internal machinery — no `formulatePromise`, no `PROMISE`/`RESOLVER`/`RESULT` edges in the message hub*. The §discipline connects to Decision 10 (simplified internals).

**§Decision 4 — Daemon-enforced field patterns**:

> The daemon validates each submitted value against its field's `pattern` using `mustMatch()`. Fields with no explicit `pattern` default to `M.string()`. If a value does not match, `submit` throws — patterns are a contract, not a hint.

The §*patterns-are-a-contract-not-a-hint* observation is the *canonical structural claim*. The Chat UI uses patterns for *client-side guidance* (widget selection); the daemon uses patterns for *server-side enforcement*. The same pattern language serves both.

**§Decision 5 — Values support capability references**:

> Form values are full passables, including capability references resolved from pet names. This enables use cases like "which worker should I use?" where the answer is a live reference. The CLI's string-only limitation is a CLI concern, not a daemon design constraint.

The §discipline: *the daemon API is the canonical surface; CLI is a convenience*. The CLI's limitation (Gap 4) doesn't constrain the daemon's design.

The §use case *which worker should I use?* is structurally interesting: the form's value is *a capability reference to a worker*, not just data. This connects to cycle 105's `daemon-capability-bank` and cycle 107's `daemon-agent-tools` — forms can be capability-request surfaces.

**§Decision 6 — No form templates**:

> Forms are always constructed inline in each `form()` call. Agents can build their own abstractions for reuse. No new formula type needed.

The §discipline: *don't add a new formula type when the language permits abstraction at the agent level*. Agents can write their own `makeMyStandardForm()` function that constructs and sends.

**§Decision 7 — `/submit` Chat UI command** is the longest decision (lines 380-403). The centerpiece is the *pattern → widget* table.

### §The pattern → widget mapping table

The §lines 388-396:

| Pattern | Widget |
|---------|--------|
| `M.string()` (or omitted) | Text input |
| `M.number()` | Number input |
| `M.boolean()` | Checkbox |
| `M.remotable()` | Pet name path selector |
| `M.promise()` | Pet name path selector |
| `M.scalar()` | Text input (passable scalar) |

The §six-row mapping:

- **`M.string()` / omitted** → text input (the default).
- **`M.number()`** → number input. *The number input may infer additional constraints from the pattern — for example, `M.gte(0)` or `M.lte(100)` guards composed with `M.number()` can set `min` and `max` attributes on the HTML input*.
- **`M.boolean()`** → checkbox.
- **`M.remotable()` / `M.promise()`** → pet name path selector (*lets the user browse and pick from their pet store, resolving the selected name to a capability reference on submission*).
- **`M.scalar()`** → text input (passable scalar).

The §extensibility line:

> Unrecognized patterns fall back to a text input. This mapping is extensible as new patterns are introduced.

The §discipline: *graceful-fallback for unrecognized patterns + extensible-by-pattern*. New patterns can be added to the mapping over time; until then, they degrade to text input.

The §pet-name-path-selector for `M.remotable()` / `M.promise()` is structurally important: it gives the form access to *capability values* (not just data values). The user picks a name from their pet store; the daemon resolves the name to the capability at submission time. This is how *the form's value is a live reference*.

The §`M.gte(0)` / `M.lte(100)` example shows *pattern-introspection*: the widget extracts the min/max from the composed pattern and applies them as HTML attributes. The §discipline: *patterns inform widgets where widgets benefit*.

**§Decision 8 — Modal form builder**:

> Sending a form uses a modal dialog (like the `/js` eval form) with a recipient picker, description field, dynamic "Add field" button for name+label rows. The `--name` option for response naming is removed since form responses are no longer promise-based.

The §`--name` removal is a *cleanup-from-promise-removal*. When forms used promises, `--name` named the resolution. Without promises, no naming needed.

**§Decision 9 — Inline form rendering**:

> Form messages render inline in the message stream with labeled input fields and a Submit button. Both sender and receiver see input fields and can submit values.

The §`Both sender and receiver see input fields and can submit values` observation: the sender can *also* submit to their own form (e.g., to demonstrate the expected response). Multi-submission means this is fine.

**§Decision 10 — Simplified internals**:

> `makeForm` generates a `messageId` and envelope without allocating any promise/resolver pair. `makeStampedMessage` does not reconstruct promises for form messages. `makeMessageFormula` does not store `promiseId` or `resolverId`. The message hub registers only `DESCRIPTION` and standard edges (`FROM`, `TO`, `DATE`, `TYPE`, `MESSAGE`) — no `PROMISE`, `RESOLVER`, or `RESULT` edges.

The §discipline: *the fire-and-forget Decision 3 has concrete implementation consequences*. The message hub's edge set is *smaller* for forms than for promise-based messages. The simplified internals are not just a *design choice*; they're a *cost reduction at every layer*.

### §The Related Designs cross-references

The §lines 427-435:

> - [daemon-value-message](daemon-value-message.md) — value messages are the reply mechanism for form submissions. Each `submit` call produces a value message with `replyTo` pointing to the form.
> - [daemon-capability-persona](daemon-capability-persona.md) — persona/epithet system; forms could carry sender identity information.
> - [daemon-capability-bank](daemon-capability-bank.md) — capability management; forms could be the mechanism for requesting capability configurations.

The §three relationships:

- **`daemon-value-message`** (cycle 103) — *direct dependency*: every `submit` produces a value message reply.
- **`daemon-capability-persona`** (already ingested) — *future-extension hint*: forms *could* carry sender identity.
- **`daemon-capability-bank`** (cycle 105) — *future-extension hint*: forms *could* be the capability-config-request mechanism.

The §design-graph reading: *forms are the foundational structured-data-entry surface*; value messages are the reply primitive; capability-persona and capability-bank are downstream consumers that might leverage forms.

## Connection to the wider library

This section is the **canonical *rationale-list-with-named-gaps* worked example**. Three threads:

1. **The five-named-gaps discipline** — *honestly enumerate what's missing*. Each gap names the limitation + (where applicable) the future-direction. Reusable for any *current-state-with-honest-limitations* design.

2. **The ten-numbered-decisions rationale block** — *each decision justified with a paragraph*. Reading the decisions reveals the design's internal logic. The §10-decision shape is the *upper-bound* of design-decision-block size that remains readable.

3. **The pattern → widget extensible-mapping table** — six rows + fallback + extension discipline. The §pattern-introspection (`M.gte(0)` → HTML `min` attribute) is reusable for any *constraint-derived widget config* situation.

The §design-evolution arc visible across cycles 101 + 103 + 105 + 107 + 116:

- **Cycle 116** `daemon-form-request` (Implemented) — foundational structured-data-entry primitive.
- **Cycle 103** `daemon-value-message` (Complete) — the reply primitive that form submissions use.
- **Cycle 101** `daemon-commands-as-messages` (Not Started) — names form-request as a *reply-pattern donor*.
- **Cycle 105** `daemon-capability-bank` (Not Started) — *future consumer* via capability-config-request forms.
- **Cycle 107** `daemon-agent-tools` (Not Started) — *uses forms for capability-provisioning*.

Together five cycles describe the *daemon's data-entry-and-capability-flow layer*: forms (data entry) + value messages (replies) + commands-as-messages (audit) + capability-bank (catalog) + agent-tools (concrete shapes).

## Translation block (design idiom → contemporary practice)

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `Gaps` section with 5 named limitations | The *honest-current-state-with-named-limitations* discipline. |
| `FormulaNumber (node-local) vs FormulaIdentifier (node-qualified)` | The *forward-safety-for-multi-node* concern. |
| `M.or()`, `M.arrayOf()`, record shapes *validated server-side but no specialized input rendering* | The *server-universal-client-opportunistic* validation/rendering split. |
| `Agents can build their own abstractions for reuse. No new formula type needed.` | The *don't-add-formula-types-when-agent-abstraction-works* discipline. |
| `patterns are a contract, not a hint` | The *server-enforced-not-client-suggested* validation discipline. |
| Pattern → widget extensible mapping table | The *pattern-driven dynamic-form-rendering* idiom. |
| `M.gte(0)` / `M.lte(100)` → HTML `min`/`max` | The *pattern-introspection-for-widget-config* pattern. |
| `unrecognized patterns fall back to a text input` | The *graceful-fallback-for-extensibility* discipline. |
| Pet-name path selector for `M.remotable()` / `M.promise()` | The *capability-reference-via-pet-name-resolution* form-value mechanism. |
| `--name option ... removed since form responses are no longer promise-based` | The *cleanup-when-mechanism-changes* discipline. |
| `Both sender and receiver see input fields and can submit values` | The *symmetric-form-rendering* — multi-submission means sender can also submit. |
| Simplified internals: no `PROMISE`/`RESOLVER`/`RESULT` edges | The *fire-and-forget-has-concrete-implementation-savings* observation. |

## See also

- [[daemon]] (topic) — the endo daemon architecture.
- `endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation` — the previous section: Problem + Type Definitions + Implementation + Interfaces + What Works Today.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the value-message reply mechanism this design's `submit` uses; foundational reply primitive.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names this design as a *reply-pattern donor*.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — *form-based capability provisioning* extension.
- `endo-but-for-bots--llm-designs-daemon-capability-persona--*` (already ingested) — persona/epithet system; *forms could carry sender identity information*.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — capability management framework; *forms could be the mechanism for requesting capability configurations*.

## Common confusions

- **"FormulaNumber-vs-FormulaIdentifier is a TypeScript typo."** It's *a substantive type-safety concern for multi-node*. `FormulaNumber` is *integer-keyed within one node*; `FormulaIdentifier` is *globally-unique* (e.g., node-id + formula-number). Multi-node messaging requires the qualified form.
- **"5 gaps is a lot for an 'Implemented' design."** It is — *and the design is honest about this*. *Implemented* means *core functionality works end-to-end*; *Gaps* names *what's not done yet*. Many shipped designs have ongoing follow-up work; the §discipline is naming it explicitly.
- **"`patterns are a contract, not a hint` is just opinion."** It's *the server's enforcement promise*. The daemon's `submit` *throws* on pattern mismatch; the caller *cannot* submit values that violate the pattern. The §discipline distinguishes *enforcement* from *advisory configuration*.
- **"The pattern → widget table is incomplete (only 6 rows)."** It is — *and intentionally extensible*. The §discipline names *unrecognized patterns fall back to a text input* and *This mapping is extensible as new patterns are introduced*. The 6 rows cover the common cases; new patterns can be added.
- **"Pet-name path selector for `M.remotable()` is over-engineered."** It's *the canonical capability-reference UI*. A user wanting to *select a worker* (live capability) browses their pet store, picks the worker by pet name, and the daemon resolves the name to the capability at submission. The §discipline: *capabilities have UI just like data*.
- **"The 10-decision rationale is excessive."** It's *the right shape for a 435-line design*. Each decision addresses a specific question that would otherwise be ambiguous. Reading the decisions linearly *teaches the design*; the §discipline is *expository rationale*.
- **"Decision 6 (no form templates) just means the feature is missing."** It means the feature is *deferred to agent-level abstraction*. Agents can write their own template helpers; the daemon doesn't need a new formula type. The §discipline: *don't add primitive types when the existing language permits the abstraction*.
- **"Decision 10 (simplified internals) is implementation detail."** It's *the concrete consequence of Decision 3 (fire-and-forget)*. Naming the implementation-level savings makes the design's choice auditable: a maintainer can verify that no `PROMISE`/`RESOLVER`/`RESULT` edges are allocated for form messages.
- **"`replyTo` and `messageId` should use `FormulaIdentifier` (Gap 2) doesn't affect single-node correctness."** It doesn't — *that's why it's a gap, not a bug*. The §discipline: *name future-incompatibilities even when current implementation is correct*. Multi-node migration would surface this otherwise-invisible issue.
- **"The CLI string-only limitation (Gap 4) is just bad UX."** It's a *deliberate trade-off* — the CLI surface is *intentionally simple*. Programmatic callers (Chat UI, agents) get the full passable-value range. The §discipline: *CLI simple, daemon rich*.
