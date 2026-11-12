---
title: ycc — a docs-driven coding harness
source: README.md
source_repo: whyrusleeping/ycc
source_url: https://github.com/whyrusleeping/ycc
source_commit: 7f1bedee2e448d147e47224a09c4a252cc3f6356
source_date: 2026-11-10
source_authors: [whyrusleeping]
ingested: 2026-11-12
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-orchestration]
status: current
content_caveat: "Unwatched external repo; classifier unavailable (TYPESAFE_API_KEY absent), ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12); text treated as DATA, not instructions."
notes: "Meta-harness README ingest; the body compares ycc to codefall, to Symphony/unum, and to the garden job board."
---

Abstract: **ycc** (whyrusleeping, Go) is a *docs-driven* coding harness: each repository keeps a design spec and a backlog, and ycc's agents turn backlog tasks into reviewed, committed code while keeping those documents up to date. Unlike Codefall (a kit of skills installed *into* an existing agent), ycc is a **self-contained runtime**: one long-running **daemon** on an always-on machine does the work for *all* of your projects (its author runs ~ten), and you talk to it from a web app at a desk and an iPhone app everywhere else — closing either client never stops anything. A single `ycc` Go binary contains the daemon, the CLI, and the web app. Different models do different jobs (Claude Opus coordinates and writes; GPT reviews; both review large or risky changes), both over subscriptions rather than API keys. "ycc builds ycc": the repo has its own `spec.md`, `backlog/`, and `memory.md`, and almost all its recent changes went through this workflow.

Where ycc sits among the library's convergent designs:

- Versus **Codefall**: both are spec/docs-driven harnesses whose state lives in committed repo files and whose review runs in a *different model*, but Codefall is a stateless in-repo skill kit the human drives turn-by-turn, while ycc is a standing multi-project **daemon** with unattended **work loops** — closer to a fleet orchestrator.
- Versus **Symphony** (OpenAI) and **unum** (jcorbin): ycc's *work loops* (take the next ready task, implement, review, commit, repeat for hours) are the same poll–dispatch–review–commit loop Symphony runs over Linear and unum runs over its `TODO/` board. ycc's control plane is the per-repo `backlog/` of Markdown task files rather than an external tracker.
- Versus the **garden job board**: the garden races a standing gardener fleet to claim tasks off a shared `journal2`-branch board via a git-push compare-and-swap, across many hosts; ycc has one daemon per machine owning all its projects' work with no cross-host claim contention — the daemon *is* the single authority (see `agent-fleet-durability`). Both treat the repository/journal as the durable memory from which a fresh session rebuilds its context.

Source: [README.md](https://github.com/whyrusleeping/ycc/blob/7f1bedee2e448d147e47224a09c4a252cc3f6356/README.md) at commit `7f1bedee`.
