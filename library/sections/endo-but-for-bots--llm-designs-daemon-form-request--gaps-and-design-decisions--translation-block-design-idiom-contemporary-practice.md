---
title: Translation block (design idiom → contemporary practice)
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
