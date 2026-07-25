---
title: "Structured note-taking"
source_kind: web-essay
source_url: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents
source_content_sha256: 71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2
source_author: "Anthropic Applied AI team (Prithvi Rajasekaran, Ethan Dixon, Carly Ryan, Jeremy Hadfield)"
source_date: 2025-09-29
ingested: 2026-07-25
ingested_by: scholar
topics: [context-engineering]
status: current
---

## Abstract

**Structured note-taking** (agentic memory) is the technique of having the agent regularly write notes persisted to memory *outside* the context window, then pull them back in later — persistent memory with minimal overhead. The pattern is simple: Claude Code maintaining a to-do list, or a custom agent maintaining a `NOTES.md` file, lets the agent track progress across complex tasks and preserve critical context and dependencies that would otherwise be lost across dozens of tool calls. The post's vivid demonstration is **Claude playing Pokémon**: across thousands of game steps the agent maintains precise tallies (for example, tracking that it has spent 1,234 steps training a Pokémon toward a target level), develops maps of explored regions, remembers unlocked achievements, and keeps strategic combat notes — all without any prompting about memory structure. After a context reset it reads its own notes and resumes multi-hour training or dungeon sequences, achieving coherence across summarization steps that would be impossible keeping everything in-context. As part of the Sonnet 4.5 launch, Anthropic released a file-based **memory tool** in public beta on the Claude Developer Platform, letting agents build knowledge bases over time, maintain project state across sessions, and reference prior work without keeping it all in context.

## Structured note-taking

Structured note-taking, or agentic memory, is a technique where the agent regularly writes notes persisted to memory outside of the context window. These notes get pulled back into the context window at later times.

This strategy provides persistent memory with minimal overhead. Like Claude Code creating a to-do list, or your custom agent maintaining a `NOTES.md` file, this simple pattern allows the agent to track progress across complex tasks, maintaining critical context and dependencies that would otherwise be lost across dozens of tool calls.

Claude playing Pokémon demonstrates how memory transforms agent capabilities in non-coding domains. The agent maintains precise tallies across thousands of game steps — tracking objectives like "for the last 1,234 steps I've been training my Pokémon in Route 1, Pikachu has gained 8 levels toward the target of 10." Without any prompting about memory structure, it develops maps of explored regions, remembers which key achievements it has unlocked, and maintains strategic notes of combat strategies that help it learn which attacks work best against different opponents.

After context resets, the agent reads its own notes and continues multi-hour training sequences or dungeon explorations. This coherence across summarization steps enables long-horizon strategies that would be impossible when keeping all the information in the LLM's context window alone.

As part of our Sonnet 4.5 launch, we released a memory tool in public beta on the Claude Developer Platform that makes it easier to store and consult information outside the context window through a file-based system. This allows agents to build up knowledge bases over time, maintain project state across sessions, and reference previous work without keeping everything in context.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
