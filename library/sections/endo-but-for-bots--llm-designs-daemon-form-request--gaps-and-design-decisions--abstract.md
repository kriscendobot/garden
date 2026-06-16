---
title: Abstract
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
