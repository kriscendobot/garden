role: scholar

Ingest this external source into the cross-cutting reference library under
journal/library/, per roles/scholar/AGENT.md:
  https://allenpike.com/2026/how-to-not-spend-10k-on-coding-agents/

- Acquire it with scripts/jobs/fetch-source.sh <url> (do NOT hand-roll the fetch);
  record provenance (source_fetched_via) per conventions. If the page cannot be
  fetched, surface that plainly in the result rather than guessing at contents.
- Curate faithfully into library sections/sources/topics. This concerns the COST /
  economics of coding agents (spend management, efficiency). If it opens a domain the
  existing taxonomy does not cover, add new topic(s) rather than bending it, and
  cross-reference to the garden's own cost/usage material where they genuinely meet
  (the usage-meter / token-quota machinery, scripts/jobs/usage-meter.sh) — without
  overstating a connection.

Library curation only — no fork, no upstream, no external systems.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 10
  claimed_at: 2026-07-08T04:26:39Z
