---
title: The ceiling of interactive coding agents, and the shift to deliverables
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

Abstract: The motivating argument for Symphony — that interactive coding agents, however capable, are bottlenecked by **human attention**, not agent speed. An engineer can comfortably supervise only three to five concurrent Codex sessions before context-switching cost dominates; beyond that, productivity drops. The insight that follows is a reframing: sessions and pull requests are a *means*, and software work is really organized around **deliverables** (issues, tasks, tickets, milestones). Symphony reorients the system around those deliverables and lets agents pull work from the tracker rather than being supervised session by session.

**The ceiling.** Even as they get easier to use, coding agents — whether via web apps or CLI — remain *interactive* tools. As agentic work scaled at OpenAI, a new burden appeared: each engineer would open a few Codex sessions, assign tasks, review output, steer the agent, and repeat. In practice most people could manage **three to five sessions** at a time before context switching became painful. Beyond that, productivity dropped: people forgot which session was doing what, jumped between terminals to nudge agents back on track, and debugged long-running tasks that stalled halfway through. The agents were fast, but the system bottleneck was human attention — the team had effectively built a fleet of extremely capable junior engineers and then assigned its human engineers to micromanaging them. That does not scale.

**The shift in perspective.** The team realized they were optimizing the wrong thing: orienting the system around coding *sessions* and merged PRs, when PRs and sessions are a means to an end. Software workflows are largely organized around **deliverables** — issues, tasks, tickets, milestones. So they asked what would happen if they stopped supervising agents directly and instead let agents pull work from the task tracker. That idea became Symphony: a written spec that functions as a supervisor to orchestrate agentic work.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
