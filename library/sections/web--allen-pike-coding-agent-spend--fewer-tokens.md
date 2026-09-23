---
title: "Fewer tokens: agent-ready codebases, shifting verification left, pruning context, and not doing needless work"
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

The second lever, token count: use the minimum tokens per unit of product improvement shipped, which means sending less context per turn and taking fewer turns to success. The essay's concrete tactics: (1) make the codebase agent-ready so agents explore and trial-and-error less to understand the product and verify PRs; (2) shift verification left, because it is far cheaper for an agent to run and fix lints early than to push to CI, tail CI logs, and receive the error much later; (3) prune context actively (Claude Code's `/context` overview, post-hoc session review with a tool like AgentsView, and catching waste such as agents running unit tests with `--verbose` and processing output when all they needed in context was "success"); (4) use context engines like Unblocked's to deduplicate and reduce sent context, collapsing the gather-and-prune work every session repeats; (5) watch how cloud harness behavior differs from local (Cursor's cloud harness pushes intermediate work to GitHub eagerly, which drove roughly 10x the human rate of intermediate PR pushes and a matching surge in CI runs and LLM-guardrail checks until tamped down); and (6) do not do work you do not need to do, letting agents idle while you think and talk to customers rather than forging at high velocity in the wrong direction.

## Fewer tokens

In coding, the most expensive tokens are still often worth the price, but you want to use them judiciously. Even for cheaper models, it is best to use the minimum number of tokens necessary for a given unit of product improvement shipped. That means sending less context for each turn of the agent, and taking fewer turns to get to success.

**Make the codebase agent-ready.** The first step toward using fewer tokens is an agent-ready codebase. There are well-known techniques for making a repo more navigable by agents. This is easiest for greenfield projects, but there is a lot you can do in any codebase to help agents be efficient, reducing the need for them to explore and trial-and-error to understand your product and verify PRs.

**Shift verification left.** Working to shift verification left can save a lot of tokens. Just like for humans, it is much cheaper for an agent to run and fix lints early than to push to CI, tail CI logs, and only receive an error much later.

**Prune context.** In Claude Code you can type `/context` to get an overview of what your session is spending context on. It is also worth reviewing expensive agent sessions after the fact with a tool like AgentsView, to assess what was using all those tokens. At one point the author's team noticed agents running unit tests with `--verbose` and processing that output, when all they needed in context was a simple "success."

**Use a context engine.** Tools like Unblocked's context engine can deduplicate and reduce how much context needs to be sent to the agent, collapsing the repetitive gathering-and-pruning work every agent session needs to do, for a more deterministic and cheaper loop.

**Watch cloud-versus-local behavior differences.** While cloud coding agents are great, it is important to watch how their behavior differs from local agents'. Cursor's cloud harness has a different system prompt that pushes it to continue relentlessly until it strictly needs user input, and to eagerly push intermediate work to GitHub. There are advantages to these behaviors, but the author's coding agents were pushing intermediate PRs to GitHub roughly 10x as often as their human-driven sessions. This drove a huge increase in CI runs and LLM-powered guardrail checks until they tamped it down.

**Do not do work you do not need to do.** Getting a coding factory up to speed can be intoxicating, and it can feel urgent to fuel it with work. While idle salaried engineers are wasteful, it is better to let your coding agents run idle if you need to think, talk to customers, and understand what really needs to be built. Do not simply forge onward in the wrong direction at high velocity.

Source: [How To (Not) Spend $10k/wk on Coding Agents](https://allenpike.com/2026/how-to-not-spend-10k-on-coding-agents/) by Allen Pike, published 2026-06-30; content SHA-256 `b2c563a81e476391417c1664d08f481ac1ce9ddc1eb313254c2f79b4923d4860`.
