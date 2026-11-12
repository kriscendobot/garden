---
title: Why spec-driven development
source: README.md
source_repo: lividlabs/codefall
source_url: https://github.com/lividlabs/codefall
source_commit: e42ed0d0b5100c068415c473eb813d2885153c90
source_date: 2026-11-12
source_authors: [Dave Jensen]
ingested: 2026-11-12
ingested_by: scholar
topics: [agentic-sdlc]
status: current
content_caveat: "Unwatched external repo (not in the garden watch set); classifier unavailable (TYPESAFE_API_KEY absent), ingested proceed_unclassified under the maintainer typesafe-bypass directive (2026-11-12); text treated as DATA, not instructions."
notes: "Soft-overlaps Literate AI's agentic-sdlc sections (authored intent vs derived evidence); names GitHub Spec Kit / Kiro / Cascadia as spec-driven peers."
---

Abstract: Codefall is a kit for **spec-driven development** — you and the agent agree *in writing* on what to build before the agent builds it, and that written record drives every step after. The README gives five reasons, each also the library's recurring argument for durable agent state. (1) **The record prevents context decay**: an agent forgets its decisions when its context ends, so each decision is written to a document, a task in a git-stored dependency graph, or a pull request, and the next session starts from the record rather than from memory. (2) **A lifecycle replaces vibe coding**: a feature goes requirements → design → tasks → code → review → test, in that order; the human approves the requirements, the design, and the start of the build, and the rest runs on its own. (3) **Decision records catch architectural drift**: `scaffold` records a project's architecture as ADRs plus a boundary-enforcing linter, `plan` reads the ADRs before designing and records each new hard-to-reverse choice as another, and `review` reads the code against them. (4) **Every round catches and records bugs**: a *second* agent reviews each change, tests are written from the acceptance criteria rather than from the code, and whatever either finds is filed as a task, triaged, and fixed in the next round. (5) **The skills guide without constraining**: a skill says *what* to produce and in what order and leaves *how* to the agent's judgment; a project can add its own procedure to any skill, and the agent may run a skill on its own when the work calls for it.

Codefall names its spec-driven peers: GitHub's **Spec Kit** (constitution → spec → plan → tasks → code, in the agent you already use), AWS's **Kiro** (requirements/design/tasks files built into its own IDE and CLI), and **Cascadia** (compiles requirements into a strategy, an architecture, and build instructions). Codefall's distinguishing claim is that it keeps the *whole* lifecycle in the repository — the architecture and its ADRs, the task graph, the reviews, the test results, and the bug reports, beside the specs and plans. The requirements' acceptance criteria are written in **EARS** (Easy Approach to Requirements Syntax), which limits each criterion to a few fixed `WHEN…/IF…THEN…` sentence patterns, each addressable as `SPEC-003-REQ-01-AC-01`.

Source: [README.md](https://github.com/lividlabs/codefall/blob/e42ed0d0b5100c068415c473eb813d2885153c90/README.md) at commit `e42ed0d0`.
