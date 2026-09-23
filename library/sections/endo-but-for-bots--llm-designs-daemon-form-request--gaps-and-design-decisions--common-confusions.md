---
title: Common confusions
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
