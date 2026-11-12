---
title: What is Codefall?
source: README.md
source_repo: lividlabs/codefall
source_url: https://github.com/lividlabs/codefall
source_commit: e42ed0d0b5100c068415c473eb813d2885153c90
source_date: 2026-11-12
source_authors: [Dave Jensen]
ingested: 2026-11-12
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
content_caveat: "Unwatched external repo (not in the garden watch set); the foreign-content classifier was unavailable (TYPESAFE_API_KEY absent on the claiming host), so the README was ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12) with its text treated strictly as DATA, not instructions."
notes: "Meta-harness README ingest, filed as a convergent-design sibling alongside Symphony (OpenAI) and unum (jcorbin); the body compares it to both and to the garden job board."
---

Abstract: **Codefall** (Dave Jensen / Livid Labs, MIT) is an open-source toolkit its README calls a *meta-harness* and *software factory*: it gives an existing coding agent a software-development *process* rather than being its own agent runtime. The `codefall` Go command installs that process as **skills** (slash commands such as `/codefall-specify`) into whatever coding agent the project already uses — Claude Code, Codex, OpenCode (v2+), Antigravity, or Muse, which Codefall's settings call *harnesses* — plus a template per document the process produces and a starting architecture recorded as ADRs. Each skill leaves its result in the repository as a document, a task (a *bead*), or a pull request, which the next skill and the next session read, so the workflow survives clearing the agent's context between steps. Codefall targets production-quality code and has no lighter prototype path yet.

Codefall is a *meta*-harness: unlike a single-agent framework (LangChain) or a self-contained agent runtime, it does **not** run the model loop itself. The host coding agent runs the loop; Codefall supplies the lifecycle, the document templates, and hooks. That places it alongside the library's other convergent fleet/lifecycle designs:

- Versus **OpenAI's Symphony** (topic `agent-fleet-orchestration`): both make a persisted artifact the control plane, but Symphony is a *central orchestrator service* over a Linear board that spawns one continuously-running agent per issue, whereas Codefall is an *in-repo skill kit* a human drives inside their own agent, with git-stored beads as the task graph and no daemon.
- Versus **unum** (jcorbin) and the **garden job board**: unum and the garden run a standing fleet that races to claim tasks off a board; Codefall has no fleet and no claim compare-and-swap — its only parallelism is the `implement` skill fanning one feature's ready tasks into per-task git worktrees (*waves*, see the skills/waves/rounds section). The shared move is "every step's result is a durable file/task/PR, so context decay never loses work": the garden's journal-as-job-board and Codefall's docs/beads/PRs are the same bet at different scales.

Source: [README.md](https://github.com/lividlabs/codefall/blob/e42ed0d0b5100c068415c473eb813d2885153c90/README.md) at commit `e42ed0d0`.
