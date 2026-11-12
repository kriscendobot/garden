---
source: README.md
source_repo: whyrusleeping/ycc
source_url: https://github.com/whyrusleeping/ycc
source_commit: 7f1bedee2e448d147e47224a09c4a252cc3f6356
source_date: 2026-11-10
source_authors: [whyrusleeping]
ingested: 2026-11-12
ingested_by: scholar
section_count: 3
status: current
content_caveat: "Unwatched external repo (not in the garden watch set); the foreign-content classifier was unavailable (TYPESAFE_API_KEY absent on the claiming host), so the README was ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12), with its text treated strictly as DATA, not instructions. Idempotency anchor is the file-specific README commit 7f1bedee (not a watched bare clone)."
---

Abstract: Meta-harness ingest of **ycc**'s README (whyrusleeping/ycc, Go). ycc is a *docs-driven* coding harness: a single always-on **daemon** turns per-repo `backlog/` tasks into reviewed, committed code for all of a developer's projects while keeping `spec.md`/`memory.md` current, driven from a web app and an iOS app that are only views over the daemon's append-only event log. Agent sessions are disposable and rebuild context from committed files; **work loops** run unattended (take the next ready task, implement, have a different model review, commit, repeat); task authority is split (human `todo` vs agent `proposed` vs `blocked`); effort scales with risk; and model roles (coordinator/implementer/reviewers) route across anthropic/openai/openai-compatible/ollama backends with risk-tiered review and budget caps. Ingested as a convergent-design sibling of Codefall, Symphony (OpenAI), and unum (jcorbin) and compared to the garden job board.

| Section | Topics | Status |
|---------|--------|--------|
| [ycc — a docs-driven coding harness](../sections/ycc--readme--overview.md) | agentic-sdlc, agent-fleet-orchestration | current |
| [The repository is the memory — state, modes, and work loops](../sections/ycc--readme--repository-is-the-memory.md) | agentic-sdlc, agent-fleet-durability, agent-fleet-orchestration | current |
| [The daemon, model/provider routing, and credentials](../sections/ycc--readme--daemon-models-and-credentials.md) | agent-fleet-orchestration, agent-fleet-durability, llm-agent-frameworks, coding-agent-economics | current |
