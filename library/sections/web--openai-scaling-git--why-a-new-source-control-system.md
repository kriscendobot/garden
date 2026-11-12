---
title: Why OpenAI needed a new source control system
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc]
status: current
---

Abstract: Codex multiplied parallel work at OpenAI (more branches, pushes, merges, and fetches from dev environments, research jobs, and CI, with one engineer's several CI-ready changes each fanning out into several fetches of the same commit), and by late 2025 the monorepo's serving systems saw slow fetches and pushes, failed merges, and reliability at times below 90%. OpenAI chose to keep Git's client and workflow and rebuild the backend so pushes to different branches proceed in parallel and the same history is served to many readers concurrently. Pando scales the two dimensions separately: it **coordinates each branch independently** (accepting that a reader of several branches may see them at different points in time) and **reuses packfiles across fetches** (accepting that a client may download some objects it already has).

Codex has changed the scale and pace of development at OpenAI, enabling engineers to do far more work in parallel. That means more branches and pushes, more merges, and more fetches and clones from development environments, research jobs, and CI.

These demands compound. One engineer now has several changes ready for CI at once, and each push can set several jobs fetching the same commit.

Starting around the end of last year, the systems supporting the monorepo were struggling to keep up: slow fetches and pushes, failed merges, and reliability at times falling below 90%. Had they reached a limit of Git itself, or of the way they served the monorepo? Git grew out of a community that exchanged kernel patches by email, and for more than two decades developers have adapted their tools around it. OpenAI wanted to keep building on that work.

They saw a way to keep the familiar workflow while rebuilding the backend to handle pushes to different branches in parallel and serve the same history to many readers concurrently. Building on Git also meant client improvements could be useful beyond OpenAI and contributed upstream from OpenAI's copy of Git.

**Engineering for Git at scale.** Scaling a source control system has two essential dimensions: many writers pushing to different branches, and many readers fetching the same history. Pando optimizes for both.

- **Writes.** Pando coordinates updates to each branch independently. Updates to unrelated branches proceed in parallel, and a reader fetching a branch gets the history needed for that revision. The tradeoff is that a reader looking at several branches can see them at different points in time.
- **Reads.** Pando reuses packfiles (Git's format for compressing multiple objects together) across fetches instead of generating an individual packfile for each client. A client may download some objects it already has, but the server can serve the same bytes to many clients with little computation.

These choices let Pando scale writes across branches and serve reads from caches.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#why-we-needed-a-new-source-control-system) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
