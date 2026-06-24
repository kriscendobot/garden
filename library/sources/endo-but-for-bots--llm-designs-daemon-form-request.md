---
source: designs/daemon-form-request.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-03-02
source_authors: [Kris Kowal (prompted)]
ingested: 2026-06-02
ingested_by: scholar
section_count: 2
status: current
notes: |
  Thirty-first endo-but-for-bots design ingest. **Status:
  Implemented**. The 435-line design defines the `Form` message
  type — the structured-question-with-named-fields message that
  lets any agent send a form to any other agent. **Frequently
  named in prior cycles**: cycle 101's daemon-commands-as-messages
  + cycle 103's daemon-value-message + cycle 107's daemon-agent-
  tools all cite daemon-form-request as a reply-pattern donor or
  sibling.
  
  The 435-line design decomposes into two argument-cluster
  sections. Section 1 (lines 1-296) covers the foundational
  *Problem + Type Definitions + Implementation + Interfaces +
  What Works Today*. Section 2 (lines 298-435) covers the
  *rationale + remaining work*: 5 named Gaps + 10 numbered
  Design Decisions + 3 Related Designs.
  
  Three structurally important moves across both sections:
  (1) the *fields-as-ordered-array-vs-record* design choice that
  *separates the semantic key (name) from the display text
  (label)* — the previous record form conflated them; (2) the
  *fire-and-forget sending + multi-submission via value replies*
  pattern — `form()` returns immediately, doesn't allocate a
  promise; submissions produce `value` message replies with
  `replyTo` pointing to the form's messageId, enabling
  multi-submission and reply-chain history; (3) the *daemon-
  enforced field patterns* discipline via `mustMatch()` —
  *patterns are a contract, not a hint*; Chat UI uses same
  patterns to select widgets (`M.string()` → text, `M.number()`
  → number input, `M.boolean()` → checkbox, `M.remotable()` /
  `M.promise()` → pet-name path selector); pattern-introspection
  (`M.gte(0)` → HTML `min`) where helpful; unrecognized patterns
  fall back to text input.
  
  Two-section cohesion-honest ingest. The 435-line file's
  substantial structural content (10 numbered Design Decisions
  + 5 named Gaps + 8-subsection implementation surface) warrants
  the split.
---

> Abstract: `designs/daemon-form-request.md` is the
> *structured-question-with-named-fields* message-type design.
> The §opening Problem frames three motivating scenarios — LLM
> agent configuration (API keys, project paths), capability
> requests with parameters (port, file path, scope), multi-field
> input (name + email + role). The §`Form` message type carries
> `description: string` + `fields: FormField[]`. The §`FormField`
> is `{name, label, example?, pattern?}` as an *ordered array*
> (not a record) — separates semantic key from display text. The
> §`form(recipientNameOrPath, description, fields)` method is
> *fire-and-forget* — no promise allocated; sender polls for
> `value` message replies. The §`submit(messageNumber, values)`
> method retrieves the form, iterates each `{name, pattern}`,
> validates via `mustMatch()` (default `M.string()`), marshals
> via `formulateMarshalValue`, sends a `value` reply with
> `replyTo` pointing to form's `messageId`. Multi-submission
> allowed: *any number of submissions produce separate value
> messages in the reply chain*. The §daemon-enforced patterns
> discipline: *patterns are a contract, not a hint*. The §Chat
> UI widget mapping: 6-pattern → widget table (string/scalar →
> text, number → number input, boolean → checkbox,
> remotable/promise → pet-name path selector); unrecognized
> patterns fall back to text input. The §5 named Gaps document
> *no forwarding* + *FormulaNumber vs FormulaIdentifier
> forward-safety* + *limited pattern vocabulary* + *CLI strings
> only* + *no reusable templates*. The §10 numbered Design
> Decisions justify the choices including simplified internals
> (no `PROMISE`/`RESOLVER`/`RESULT` edges in the message hub for
> form messages). The §3 Related Designs: `daemon-value-message`
> (the reply mechanism), `daemon-capability-persona` (forms
> could carry sender identity), `daemon-capability-bank` (forms
> could be capability-config-request mechanism).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [form-message-type-and-implementation](../sections/endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation.md) | daemon | current |
| [gaps-and-design-decisions](../sections/endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions.md) | daemon | current |

The 435-line file decomposes into two argument-cluster sections. Lines 1-296 are the foundational design (Problem + Type Definitions + Implementation + Interfaces + What Works Today) → section 1. Lines 298-435 are the rationale + remaining work (Gaps + Design Decisions + Related Designs) → section 2. The split honors the substantial structural content (10 numbered Design Decisions + 5 named Gaps).

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots` `origin/llm` via the local bare-clone.
- Last touched 2026-03-02 by Kris Kowal (*prompted* — LLM-collaborated authoring).
- Verified file existence via bare-clone listing: 435 lines.
- **Thirty-first endo-but-for-bots design ingest**. Pairs structurally with:
  - **Cycle 103** `daemon-value-message` — the reply mechanism that `submit` produces.
  - **Cycle 101** `daemon-commands-as-messages` — names this design as a *reply-pattern donor*.
  - **Cycle 107** `daemon-agent-tools` — uses forms for *form-based capability provisioning*.
  - **Cycle 105** `daemon-capability-bank` — *future capability-grant-config mechanism* via forms.
- Cycle 116 was scheduled for papers-lane (ninth consecutive papers-lane block) and pivoted to daemon-design-lane to ingest this *frequently-named-in-prior-cycles* design.
- Two-section cohesion-honest count. The 435-line file's substantial structural content (10 numbered Design Decisions + 5 named Gaps + 8-subsection implementation surface) warrants the split.
