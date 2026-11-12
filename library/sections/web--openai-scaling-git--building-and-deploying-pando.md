---
title: Building and deploying Pando: agents, verification, and a proxy migration
source_kind: web
source_url: https://openai.com/index/scaling-git-at-openai/
source_snapshot: http://web.archive.org/web/20261110004756id_/https://openai.com/index/scaling-git-at-openai/
source_content_sha256: f93cf33cc74d4badf1d49db844bf99ef616bba6e2d3cf0f59a11ef638a1cb48e
source_authors: [Aaron Friel, Taylor Blau, Ted Nyman]
source_date: 2026-11-02
retrieved: 2026-11-12
ingested: 2026-11-12
ingested_by: scholar
topics: [source-control-architecture, agentic-sdlc, testing]
status: current
---

Abstract: How Pando was made and rolled out. Built with Codex from kick-off to production in **10 weeks**: one engineer designed the core, teams of agents implemented it, a handful of engineers deployed it; production traffic began in April 2026. Validation combined a greenfield **Rust** implementation without legacy dependencies, a **Git conformance test suite** agents could check changes against, **deterministic simulation testing** harnesses that found race conditions and regressions in negotiation and pack planning, agent-written **Lean and TLA+** formalizing a "theory of Pando" used to find bugs and prove properties, hundreds-of-hours continuous agent bug-hunting sessions, and around-the-clock agent red-teaming of Git and Pando. Deployment started as a **read- and write-through proxy** in front of the old system (keeping both in sync, deduplicating and combining requests, and warming the old backend's health as traffic moved), with clients migrated in phases through an internal Git CLI wrapper, OpenAI's public Git build shipped to developer machines and the ChatGPT desktop app, hundreds of integrations migrated, and Codex skills that migrated checkouts on request. Reported results: better merge reliability, median push latency down nearly 80%, a petabyte a day from a handful of CPU cores, and 57 TB of packs in one hour with over 99% of bytes from local disk cache.

### Building Pando

Pando was built with Codex, from kick-off to production, in just 10 weeks. The core was designed by a single engineer, implemented by teams of agents, and deployed by a handful of engineers. It began serving production traffic in April of this year and is one part of a larger system of source-control tools at OpenAI.

Validation used a wide variety of approaches, applying OpenAI's principles for building more secure software foundations:

- As a greenfield project, Pando was implemented **in Rust and without legacy dependencies**.
- A **conformance test suite** let agents test their changes against standard Git behavior.
- **Deterministic simulation testing** harnesses checked invariants and properties of the system, finding and mitigating subtle race conditions and regressions in negotiation and pack planning.
- Many models contributed; as new ones became available they were used to improve performance and reliability. Using GPT-6 Astra, agents wrote **Lean and TLA+** to formalize a "theory of Pando" used to find and fix implementation bugs and prove properties of the system.
- Multiple continuous sessions ran for hundreds of hours finding and fixing edge cases, and agents run around the clock to **red-team** Git and Pando.

### Deploying Pando

The initial deployment was a **read- and write-through proxy** to the existing source control system, keeping Pando and the previous system in sync so traffic could move without downtime.

As part of its caching design, Pando can also **deduplicate and combine requests** before proxying, which kept existing tools healthy while systems moved one at a time. As more workloads migrated, their pushes populated Pando's cache and improved the reliability of the previous backend.

To optimize performance on Pando, OpenAI began shipping its public distribution of Git to developer machines and within the ChatGPT desktop app. Clients were migrated in phases through an internal wrapper around the Git CLI. OpenAI also built tools for change requests, code review, and automation APIs, and migrated hundreds of integrations that depended on legacy APIs, webhooks, and repository downloads alongside Git traffic.

Codex itself helped developers move: OpenAI created skills for preparing existing checkouts and for guiding agents to use the new system, so developers could simply ask Codex to migrate their environments and services.

**Results.** Switching to Pando improved merge reliability and reduced median push latency by nearly 80%. Pando can deliver a petabyte of Git data per day with a handful of CPU cores, and has served more than 57 terabytes of Git packs in a single hour, with more than 99% of those bytes from local disk cache. Pack reuse lets many clients download the same history with little computation on serving nodes; data delivery and Git negotiation scale independently, and Pando is designed to support many repositories, not only the one monorepo.

Source: [Scaling Git at OpenAI](https://openai.com/index/scaling-git-at-openai/#building-pando) by OpenAI, 2026-11-02. Captured via the Internet Archive (`source_fetched_via=wayback`, the canonical host returned HTTP 403); content SHA-256 `f93cf33c`.
