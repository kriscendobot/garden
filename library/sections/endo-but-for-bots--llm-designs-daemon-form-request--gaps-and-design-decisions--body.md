---
title: Body
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
parent: endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions
---

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
