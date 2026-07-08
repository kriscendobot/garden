---
title: Objectives over state machines — the lesson from ticket-level delegation
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

Abstract: The central design lesson of Symphony — **give agents objectives, not strict state transitions.** Moving from interactive steering to ticket-level assignment cost the ability to nudge agents mid-flight; the response was not to patch results by hand but to add **guardrails and skills** so agents succeed next time (end-to-end tests, driving the app through Chrome DevTools, QA smoke tests, clearer documentation of "what good looks like"). The team found that treating agents as rigid nodes in a state machine works poorly — models get smarter and outgrow the box — so they moved toward giving agents goals the way a good manager assigns a goal to a direct report: give them tools and context and let them reason. Not every task fits this style; ambiguous, judgment-heavy work still wants an interactive session, and those are usually the most interesting tasks.

Operating at this level comes with tradeoffs. Moving from steering agents interactively to assigning them work at the ticket level meant losing the ability to constantly nudge them mid-flight and course-correct. Sometimes an agent produced something that completely missed the mark — which was useful: those failures revealed gaps in the system and helped make it more robust.

**Guardrails and skills instead of manual patches.** Rather than patch a bad result by hand, the team added guardrails and skills so agents could succeed the next time. Over time this added new harness capabilities — running end-to-end tests, driving the app through Chrome DevTools, managing QA smoke tests — and significantly improved documentation, clarifying "what good looks like."

**Not every task fits.** Some problems still require engineers working directly with interactive Codex sessions, especially ambiguous problems or work needing strong judgment and expertise — usually the most interesting and enjoyable tasks. Symphony handles the bulk of routine implementation, which lets engineers focus on one hard problem at a time instead of context-switching between many small ones.

**Objectives, not rigid transitions.** The team also learned that treating agents as **rigid nodes in a state machine doesn't work well.** Models get smarter and can solve bigger problems than the box you try to fit them in. Early versions only asked Codex to implement the task; that proved too limiting. Codex is perfectly capable of creating multiple PRs, reading review feedback and addressing it, closing old PRs, or pulling reports on completed vs. abandoned work — tasks well outside the initial feature-implementation box. So they gave it tools (the `gh` CLI, skills to read CI logs, and so on) and eventually moved toward giving agents **objectives instead of strict transitions**, much like a good manager assigns a goal to a direct report. The power of models comes from their ability to reason: give them tools and context and let them cook.

> This is the same design stance the garden's role briefs encode: a role's `AGENT.md` gives a gardener **bounded authority and a definition of done** plus a list of skills, not a rigid transition table — the agent reasons its way to the objective. Symphony's "guardrails and skills so the agent succeeds next time" is the same loop as the garden's [self-improvement](../../../skills/self-improvement/SKILL.md) channel feeding lessons back into roles and skills.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
