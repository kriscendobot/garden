---
title: "Cheaper tokens: right-sizing the model and the hard problem of routing tasks by difficulty"
source_kind: web-essay
source_url: https://allenpike.com/2026/how-to-not-spend-10k-on-coding-agents/
source_content_sha256: b2c563a81e476391417c1664d08f481ac1ce9ddc1eb313254c2f79b4923d4860
source_author: Allen Pike
source_date: 2026-06-30
ingested: 2026-07-08
ingested_by: scholar
topics: [coding-agent-economics]
status: current
---

## Abstract

The first lever, token cost: use cheaper models where you can. The long-standing advice to use frontier models for everything is starting to change as cheaper-but-capable models arrive (the essay's mid-2026 price snapshot: Anthropic's Sonnet 5 at $3/Mtok, GPT 5.6 medium/small variants at $2.50 and $1, GLM 5.2 offered around $1, and Cursor's Composer at $0.50/Mtok, one-twentieth of Claude Fable's $10/Mtok). The catch is routing: sending each task to the right-sized model is hard, exactly like assigning "easy" tickets to a junior engineer only to find one is fiendishly difficult. A cheap model that throws up its hands on a too-hard task is fine; one that instead spins for ages coding confidently-incorrect PRs wastes time and money, or worse ships to users. Startups are building model routers to assess task difficulty, but the author is skeptical that third parties will out-route the model labs themselves, so until the labs ship effective routers a combination of automatic and human routing is necessary to balance performance against cost.

## Cheaper tokens

The typical advice for coding has long been to use frontier models for everything, and model labs have mostly focused on those most-expensive models (with Claude Fable hitting $10/Mtok). That is starting to change. The essay's mid-2026 price points:

- Anthropic announced Sonnet 5 at $3/Mtok.
- GPT 5.6 will offer medium and small variants at $2.50 and $1 respectively.
- GLM 5.2 is perhaps the most frontier-competitive open coding model in years, offered around $1.
- Cursor's Composer is only $0.50/Mtok, one-twentieth of Fable's cost. (Composer also has a Fast variant at $3/Mtok, but for cloud coding you often do not need to pay for the extra speed. Another wrinkle: Composer cache hits consume a full 40% of uncached token cost, versus Claude's 10%.)

While these smaller models can be much cheaper for easy tasks, it can be a pain to route queries to the right-sized model. Anybody who has run an engineering team has lived this: you select a set of tasks for a junior dev, thinking "these should be easy ones." Most are easy enough, but one turns out to be fiendishly difficult once they dig in.

If you are lucky, a cheap model like Composer or GLM will throw up its hands on an overly difficult task without wasting too much money. If you are unlucky, it will spin for ages, coding confidently-incorrect PRs that waste your time and money, or worse, get deployed to users.

Various startups are working on model routers that attempt to assess how hard an issue is and assign a right-sized model to each task and subtask. The author is a bit skeptical that third parties will produce better routers than the model labs themselves, but until the labs have effective routers of their own, a combination of automatic and human routing is necessary to balance performance and costs.

Source: [How To (Not) Spend $10k/wk on Coding Agents](https://allenpike.com/2026/how-to-not-spend-10k-on-coding-agents/) by Allen Pike, published 2026-06-30; content SHA-256 `b2c563a81e476391417c1664d08f481ac1ce9ddc1eb313254c2f79b4923d4860`.
