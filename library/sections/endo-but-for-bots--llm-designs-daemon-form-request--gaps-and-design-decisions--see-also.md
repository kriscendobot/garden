---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture.
- `endo-but-for-bots--llm-designs-daemon-form-request--form-message-type-and-implementation` — the previous section: Problem + Type Definitions + Implementation + Interfaces + What Works Today.
- `endo-but-for-bots--llm-designs-daemon-value-message--*` (cycle 103) — the value-message reply mechanism this design's `submit` uses; foundational reply primitive.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — names this design as a *reply-pattern donor*.
- `endo-but-for-bots--llm-designs-daemon-agent-tools--*` (cycle 107) — *form-based capability provisioning* extension.
- `endo-but-for-bots--llm-designs-daemon-capability-persona--*` (already ingested) — persona/epithet system; *forms could carry sender identity information*.
- `endo-but-for-bots--llm-designs-daemon-capability-bank--*` (cycle 105) — capability management framework; *forms could be the mechanism for requesting capability configurations*.
