---
id: objectives-over-state-machine
aliases: ["objectives over state machines", "objectives not transitions", "give agents objectives", "agents as rigid nodes", "don't treat agents as state-machine nodes", "give them tools and let them cook", "goal not transition"]
topics: [agent-fleet-orchestration]
status: current
---

# objectives-over-state-machine

The central design lesson OpenAI drew from running a fleet of coding agents at the ticket level: **give agents objectives, not strict state transitions.** Treating an agent as a rigid node in a state machine works poorly because models keep getting smarter and outgrow the box built for them — an early version that only asked the agent to "implement the task" proved too limiting, when the same agent is capable of creating multiple PRs, reading and addressing review feedback, closing old PRs, and pulling reports. The fix is to hand the agent tools and context and assign it a goal, the way a good manager assigns a goal to a direct report, then let it reason. The complement is that losing mid-flight steering is repaired not by patching results by hand but by adding **guardrails and skills** (end-to-end tests, driving the app through Chrome DevTools, QA smoke tests, clearer docs of "what good looks like") so the agent succeeds next time — the same feedback loop the garden runs through its self-improvement channel and bounded-authority role briefs (a definition of done plus skills, not a transition table).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [objectives over state machines](../sections/web--openai-symphony-codex-orchestration--objectives-over-state-machines.md) | The lesson in full: agents as objectives not rigid nodes; guardrails/skills so they succeed next time. |
| [SPEC §7–§8 orchestration state machine](../sections/web--openai-symphony-codex-orchestration--spec-orchestration-state-machine.md) | The claim-state machine Symphony does keep — coordination state, distinct from constraining the agent's task. |

## See also

- [[symphony-orchestrator]] — the system this lesson emerged from.
- [[ticket-as-control-plane]] — the operating model that made the lesson necessary.
