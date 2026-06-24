---
title: Connection to the wider library
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
