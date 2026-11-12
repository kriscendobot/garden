---
title: The repository is the memory — state, modes, and work loops
source: README.md
source_repo: whyrusleeping/ycc
source_url: https://github.com/whyrusleeping/ycc
source_commit: 7f1bedee2e448d147e47224a09c4a252cc3f6356
source_date: 2026-11-10
source_authors: [whyrusleeping]
ingested: 2026-11-12
ingested_by: scholar
topics: [agentic-sdlc, agent-fleet-durability, agent-fleet-orchestration]
status: current
content_caveat: "Unwatched external repo; classifier unavailable (TYPESAFE_API_KEY absent), ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12); text treated as DATA, not instructions."
notes: "ycc's context/state model, task-authority rules, session modes, and the unattended work loop (its agent loop)."
---

Abstract: ycc's state, agent loop, and its guarantees against context loss and runaway scope.

**The repository is the memory.** Agent sessions are disposable; project state is not. Everything an agent needs to continue lives in plain committed files both human and agents edit: `spec.md` (+ any `docs/` design set) holds how the system is meant to work (behavior, architecture, interfaces, invariants); `backlog/NNNN-*.md` is one Markdown file per task (intent, acceptance criteria, status, dependencies, work log); `memory.md` holds short advisory notes about *working on* the project (gotchas, environment quirks); and git history is the record of code changes. Each session starts with **fresh context** and rebuilds what it needs from these files, so any client or model can pick up where the last stopped. **The spec and the code change together** — a contradiction between them is a bug; sessions update the design docs in the same commit as the code, and `ycc spec-check` flags paths, packages, and symbols the docs mention that no longer exist.

**You decide what gets done; agents decide how.** Tasks the human creates are accepted work (`todo`). Tasks an agent proposes start as `proposed` and never run until promoted — agents record adjacent work they discover as proposed follow-ups instead of quietly expanding their task. A task needing something only a human can provide is marked `blocked`, with the reason in the task. (These task-authority invariants mirror the garden's own "agents file follow-on jobs, never silently widen scope" discipline; see `agent-fleet-durability`.)

**Effort proportional to risk.** Tests, docs, and review carry maintenance cost, so they are used where they help, not by default: a tiny change gets a self-review, ordinary work one reviewer, and large or hard-to-reverse changes several models in parallel. Reviews judge the change against the task and real failure modes, not taste.

**Session modes.** *Chat* talks to the coordinator with full file and shell access and no fixed workflow (questions, bug fixes, small features, "commit it"). *Work on backlog* takes one task start to finish (read task and spec, implement, review in proportion to risk, update the task, commit). *Project manager* plans — discuss design, edit the spec, create and groom tasks — without writing code. A running session accepts a message at the next safe point; **Interrupt** pauses it at a checkpoint to steer.

**Work loops (the unattended agent loop).** Starting a loop tells the daemon to take the next ready task, implement it in a fresh session, have a *different* model review it, commit, and repeat until nothing is ready. Loops run for hours unattended; one busy project landed ~fifty reviewed commits in a day. Sessions the human starts are *attended* (the agent may ask questions); work-loop sessions are *unattended* — they never wait for an answer, instead making a reversible assumption or marking the task blocked.

Source: [README.md](https://github.com/whyrusleeping/ycc/blob/7f1bedee2e448d147e47224a09c4a252cc3f6356/README.md) at commit `7f1bedee`.
