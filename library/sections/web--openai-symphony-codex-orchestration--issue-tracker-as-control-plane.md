---
title: Turning the issue tracker into an agent orchestrator
source_kind: web
source_url: https://openai.com/index/open-source-codex-orchestration-symphony/
source_snapshot: http://web.archive.org/web/2id_/https://openai.com/index/open-source-codex-orchestration-symphony/
source_content_sha256: b7c17d55f4faf42eb09282c0670a14dce360f83a5fe205834b5bbe09a7695c09
source_authors: [Alex Kotliarskyi, Victor Zhu, Zach Brock]
source_date: 2026-04-27
retrieved: 2026-07-08
ingested: 2026-07-08
ingested_by: scholar
topics: [agent-fleet-orchestration]
status: current
---

Abstract: The core operating model of Symphony — **any open task should be picked up and completed by an agent**, with the issue tracker as the control plane. Each open Linear issue maps to a dedicated agent workspace; Symphony continuously watches the board and ensures every active task has an agent running in the loop until it is done, restarting agents that crash or stall and picking up new work as it appears. Ticket statuses drive the workflow as a state machine. The model decouples work from sessions and from pull requests (one issue may produce multiple PRs across repos, or none at all for investigation tasks), lets tickets represent large units of work with a **DAG of dependencies** so unblocked tasks run in parallel, and lets agents **file their own follow-up issues** for improvements they notice out of scope.

Symphony started with a simple concept: **any open task should get picked up and completed by an agent.** Instead of managing Codex sessions across many tabs, the issue tracker becomes the control plane. Each open Linear issue maps to a dedicated agent workspace. Symphony continuously watches the task board and ensures that every active task has an agent running in the loop until it is done. If an agent crashes or stalls, Symphony restarts it. If new work appears, Symphony picks it up. The workflow is built on ticket statuses, using Linear as a state machine.

**Decoupling work from sessions and PRs.** In practice Symphony decouples work from sessions and from pull requests. Some issues produce multiple PRs across repos; others are pure investigation or analysis that never touch the codebase. Once work is abstracted this way, a ticket can represent a much larger unit of work.

**Task trees and dependency DAGs.** The team regularly uses Symphony to orchestrate complex features and infrastructure migrations. A task might ask the agent to analyze the codebase, Slack, or Notion and produce an implementation plan; once the plan is approved, the agent generates a **tree of tasks**, breaking the work into stages and defining dependencies between them. Agents only start tasks that are not blocked, so execution unfolds naturally and in parallel across the DAG. For example, marking a React upgrade as blocked on a migration to Vite means agents start the React upgrade only after the Vite migration completes.

**Agents create work themselves.** During implementation or review, agents often notice improvements outside the current task's scope — a performance issue, a refactoring opportunity, a better architecture. When that happens they simply **file a new issue** for later evaluation and scheduling; many of these follow-up tasks also get picked up by agents. This dramatically reduces the cognitive cost of kicking off ambiguous work: if the agent gets something wrong, that is still useful information, and the cost is near zero. Tickets can cheaply be filed for the agent to prototype and explore, throwing away explorations that do not pan out.

Because the orchestrator runs on devboxes and never sleeps, tasks can be added from anywhere with confidence an agent will pick them up — one engineer made three significant changes from the Linear phone app, from a cabin on poor wifi.

> The garden's job board expresses the same "every open task gets a worker" invariant differently: gardeners **race to claim** posted jobs via a git-push compare-and-swap rather than a central orchestrator reserving each issue. The garden's dependency edges (`blocked_on` + `unblock.sh`) and its [orchestration jobs](../../../skills/orchestration/SKILL.md) (serial/parallel promotion of parked child jobs) are the direct analogue of Symphony's blocked-task DAG; agents posting their own follow-on jobs mirrors Symphony's agents filing their own issues.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
