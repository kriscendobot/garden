---
id: model-routing
aliases: ["model routing", "model router", "right-sizing the model", "right-sized model", "task difficulty routing", "cheaper tokens", "model selection by difficulty", "query routing"]
topics: [coding-agent-economics]
---

# model-routing

**Model routing** is the "cheaper tokens" lever on [[coding-agent-spend]]: assign each task (and subtask) to the smallest-and-cheapest model that can actually do it, rather than sending everything to the frontier model. The premise, from Allen Pike's essay, is that the long-standing advice to use frontier models for everything is breaking down as cheaper-but-capable models arrive (his mid-2026 snapshot spans roughly $10/Mtok Claude Fable down to $0.50/Mtok Cursor Composer, one-twentieth the cost, with Sonnet 5 at $3, GPT 5.6 small/medium at $1/$2.50, and GLM 5.2 around $1).

The hard part is **assessing task difficulty in advance**, which the essay frames with the junior-engineer analogy: you pick a batch of "easy" tickets, most are easy, but one turns out fiendishly difficult once dug into. A cheap model that throws up its hands on a too-hard task is a fine outcome; a cheap model that instead spins for ages producing confidently-incorrect PRs wastes time and money, or ships bugs to users. Startups are building routers to score difficulty and assign a right-sized model per task, but the essay is skeptical third parties will out-route the labs themselves, so until the labs ship effective routers a combination of **automatic and human routing** is needed to balance performance against cost.

The garden's coarse, deterministic analogue is its per-role model-tier map (`skills/model-selection/SKILL.md`): designer on Fable, builder on the latest Opus, other roles the fleet default. That is right-sizing decided per role up front rather than by a runtime difficulty router.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Cheaper tokens](../sections/web--allen-pike-coding-agent-spend--cheaper-tokens.md) | Right-size the model to the task; the mid-2026 price spread and the hard problem of routing by difficulty. |

## See also

- [[coding-agent-spend]] — the cost `token_cost × token_count`; model-routing is the first factor.
- [[context-pruning]] — the complementary "fewer tokens" lever on the second factor.
