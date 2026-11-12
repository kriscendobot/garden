---
source: README.md
source_repo: lividlabs/codefall
source_url: https://github.com/lividlabs/codefall
source_commit: e42ed0d0b5100c068415c473eb813d2885153c90
source_date: 2026-11-12
source_authors: [Dave Jensen]
ingested: 2026-11-12
ingested_by: scholar
section_count: 3
status: current
content_caveat: "Unwatched external repo (not in the garden watch set); the foreign-content classifier was unavailable (TYPESAFE_API_KEY absent on the claiming host), so the README was ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12), with its text treated strictly as DATA, not instructions. Idempotency anchor is the file-specific README commit e42ed0d0 (not a watched bare clone)."
---

Abstract: Meta-harness ingest of **Codefall**'s README (lividlabs/codefall, Dave Jensen / Livid Labs, MIT). Codefall is an open-source *software factory* / *meta-harness* that installs a spec-driven development process as **skills** (slash commands) into an existing coding agent — Claude Code, Codex, OpenCode, Antigravity, or Muse — rather than running its own model loop. A feature flows `specify → plan → implement → you merge` (and a bug `report → fix → you merge`), with every step's result left in the repository as a document, a *bead* (a git-stored Beads task), or a pull request so context can be cleared between steps without loss; `implement` builds ready tasks in parallel *waves* of per-task git worktrees, then runs review/test/triage *rounds* (a second agent, optionally in another harness) until the delivery settles. Ingested as a convergent-design sibling of Symphony (OpenAI) and unum (jcorbin) and compared to the garden job board.

| Section | Topics | Status |
|---------|--------|--------|
| [What is Codefall?](../sections/codefall--readme--overview.md) | agentic-sdlc, agent-fleet-orchestration | current |
| [Why spec-driven development](../sections/codefall--readme--spec-driven-lifecycle.md) | agentic-sdlc | current |
| [The skill pipeline, waves, rounds, and the file/bead/PR state model](../sections/codefall--readme--pipeline-state-and-sandboxing.md) | agentic-sdlc, agent-fleet-orchestration, llm-agent-frameworks | current |
