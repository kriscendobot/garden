role: scholar

Ingest this external source into the cross-cutting reference library under
journal/library/, per roles/scholar/AGENT.md:
  https://openai.com/index/open-source-codex-orchestration-symphony/

- Acquire it with scripts/jobs/fetch-source.sh <url> (do NOT hand-roll the fetch);
  record provenance (source_fetched_via) per conventions. If the page cannot be
  fetched (JS-only / bot-blocked / paywalled), surface that plainly in the result
  rather than guessing at contents.
- Curate faithfully into library sections/sources/topics. This is an agent-
  orchestration source (Codex / multi-agent orchestration); if it opens a domain the
  existing endo-centric taxonomy does not cover, add new topic(s) for it rather than
  bending the taxonomy, and cross-reference to the garden's own orchestration material
  where they genuinely meet (skills/orchestration, the orchestrator role) — without
  overstating a connection.

Library curation only — no fork, no upstream, no external systems.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 8
  claimed_at: 2026-07-08T04:25:05Z
