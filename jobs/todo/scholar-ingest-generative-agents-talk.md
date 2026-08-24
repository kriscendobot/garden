---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Ingest source: "Generative Agents" talk (Abhinav Chinta)

Source: https://abhinavchinta.com/files/generative_agents_talk.pdf

Verified not yet in the library (no hit in library/sources/, library/topics/,
library/concepts/, or keywords.md for this URL or "generative agents") as of
2026-08-19.

Ingest per the scholar's normal per-source procedure
(roles/scholar/AGENT.md § Per-job procedure; journal/library/conventions.md).
It's a PDF talk deck — use scripts/jobs/fetch-source.sh (not a hand-rolled
fetch) to retrieve it and extract text; expect slide-deck-shaped content
(sparser prose, more figures/bullets than a paper), so use judgment on section
granularity rather than assuming paper-style prose sections.

Route into whichever topic(s) the content actually supports (agent
architecture, memory/reflection, simulated social behavior, etc. -- read
first, don't presume) and cross-link into journal/projects/ where a concrete
connection to Endo's own agent work is clear, same as any other source.
Normal section budget applies; if the deck is large, a faithful first pass is
enough and a follow-on scholar-ingest-source job names what's left.
