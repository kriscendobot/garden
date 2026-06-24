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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--abstract.md)
- [Body](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-daemon-form-request--gaps-and-design-decisions--common-confusions.md)
