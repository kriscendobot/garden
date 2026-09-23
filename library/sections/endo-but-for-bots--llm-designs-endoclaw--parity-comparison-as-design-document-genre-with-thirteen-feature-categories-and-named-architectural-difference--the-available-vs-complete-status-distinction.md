---
source: designs/endoclaw.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/endoclaw.md
section_kind: design
ingested: 2026-06-06
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Joshua T Corbin (edited)
topics:
  - daemon
  - capability-security
status_at_ingest: Reference
genre: §endo-but-for-bots-design §parity-comparison-as-design-document
cycle: 196
lane: designs
status: current
title: §The-§§"Available" vs §§"Complete" status distinction
parent: endo-but-for-bots--llm-designs-endoclaw--parity-comparison-as-design-document-genre-with-thirteen-feature-categories-and-named-architectural-difference
---

§The-status-tags-include-both-§§"Available" and-§§"Complete".
§What's-the-difference?

Reading the design:

- **§§"Available"**: the feature exists in Endo, can be
  used by callers (e.g., "Multi-agent routing" in Agent-
  Management table).
- **§§"Complete"**: the feature is shipped + tested + the
  primary path callers reach for (e.g., "WebChat" → "Chat UI
  packages/chat").

§The-distinction-is-subtle-but-named-implicitly through
usage. §Complete-implies-finished; Available-implies-usable-
even-if-still-evolving.

§Compare-to-cycle-188-perf's §seven-distinct-design-lifecycle-
statuses (Complete / In Progress / Proposed / Active /
Reference / Implemented / Not Started). §Cycle-196-uses-five-
status-tags within the feature-tables (a different vocabulary
for feature-completeness rather than design-lifecycle).

§Tier-1-borrowing: §status-tag-vocabulary-for-feature-tables
distinct from §design-lifecycle-status. §Available + Complete
+ Designed + Not designed + Not planned are §feature-
implementation-states; not design-document-states.
