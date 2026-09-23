---
title: Outcomes — exploration, the economics of change, and monorepo shepherding
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

Abstract: What changed once the team worked through Symphony. The headline was output — a **500% increase in landed PRs** among some teams in the first three weeks — but the deeper shift was in how teams *think about work*: when engineers no longer supervise sessions, the perceived cost of each change drops, so speculative tasks become trivial to spin up and throw away. It also **broadens who can initiate work** (a PM or designer files a feature request directly and gets back a review packet with a video walkthrough) and it shines in large **monorepos** where the last mile of landing a PR is slow and fragile — Symphony watches CI, rebases, resolves conflicts, retries flaky checks, and shepherds changes to merge without human babysitting.

The most obvious change from working with Symphony was **output**: among some teams at OpenAI, the number of landed PRs increased by **500% in the first three weeks**. (Outside OpenAI, Linear's founder Karri Saarinen highlighted a spike in workspaces created as Symphony was released.) But the deeper shift is how teams think about work.

**The economics of change.** When engineers no longer spend time supervising Codex sessions, the economics of code changes shifts completely: the perceived cost of each change drops because human effort is no longer invested in driving the implementation. That changed behavior — it became trivial to spin up speculative tasks: try an idea, explore a refactor, test a hypothesis, and keep only the results that look promising.

**Broadening who initiates work.** The product manager and designer can now file feature requests directly into Symphony without checking out the repo or managing a Codex session. They describe the feature and get back a **review packet** that includes a video walkthrough of the feature working inside the real product.

**Monorepo shepherding.** Symphony also shines in large monorepos (like OpenAI's) where the last mile of landing a PR is slow and fragile. The system watches CI, rebases when needed, resolves conflicts, retries flaky checks, and generally shepherds changes through the pipeline. By the time a ticket reaches "Merging," there is high confidence the change will make it into the main branch without human babysitting. Overall, the team delegates more work to agents and focuses on harder, more exploratory tasks.

> The monorepo-shepherding behavior maps directly onto the garden's [shepherd](../../../roles/shepherd/AGENT.md) role (drive CI to green) and [weaver](../../../roles/weaver/AGENT.md) role (rebase/conflict-resolution), which the fleet posts as jobs on the same board — an in-corpus analogue of Symphony folding CI-shepherding into the orchestrated pipeline.

Source: [An open-source spec for Codex orchestration: Symphony](https://openai.com/index/open-source-codex-orchestration-symphony/) — OpenAI, 2026-04-27. Captured via the Internet Archive (`source_fetched_via=wayback`); content SHA-256 `b7c17d55`.
