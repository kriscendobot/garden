---
id: thinking-budget-output-overrun
aliases: ["max thinking useless", "over-thinks to breaking", "reasoning budget overrun", "thinking budget exhausts output tokens", "128000 output token limit", "128k output limit", "max effort no response", "reasoning token output ceiling"]
topics: [frontier-model-apis, coding-agent-economics]
status: current
---

# thinking-budget-output-overrun

A failure mode of high-reasoning-effort LLM inference: the model's reasoning (thinking) tokens count against the same finite maximum-output-token budget as its answer, so at the highest effort levels the model can exhaust that budget while still reasoning and return no answer at all. The first documented instance in Simon Willison's long-running SVG-pelican test was Claude Opus 5.5 at "max" thinking, which hit the shared 128,000-token output ceiling before emitting any SVG, twice, each attempt costing about $2.56 and taking nearly 20 minutes. Willison's read: "max" is effectively useless if it over-thinks to breaking on a trivial prompt. Fable 5.1 at "max" did not exhibit this on the same prompt. The lesson generalizes past one model: reasoning effort is a real operational lever with a hard ceiling, not a free "more is better" dial.

## Why it matters to the garden

The garden fleet runs Opus tiers for its designer and builder roles (`skills/model-selection/SKILL.md`) and routinely selects high or max reasoning effort. This concept is the honest caution that the highest effort level can consume the output-token budget before producing output, wasting time and money, so effort selection deserves the same care as tier selection. This is a caution surfaced from an external report, not a measured claim about the garden's own runs.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [opus-5-5-max-over-thinks](../sections/web--willison-opus-sol-luna-price-war--opus-5-5-max-over-thinks.md) | Opus 5.5 at "max" exhausted the 128k output-token budget while still reasoning about the pelican SVG and returned nothing, twice; Fable 5.1 at "max" did not. |

## See also

- [[model-routing]] — right-sizing model and effort to the task; this failure mode is the reason effort, not just tier, is part of the routing decision.
