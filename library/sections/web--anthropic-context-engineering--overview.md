---
title: "Effective context engineering for AI agents (overview)"
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

Anthropic's framing post for **context engineering** (published 2025-09-29): the emerging discipline of curating and maintaining the optimal set of tokens available to a large language model during inference. Its thesis is that building with language models has moved from *finding the right words for a prompt* to answering the broader question **"what configuration of context is most likely to generate our model's desired behavior?"** Context is defined as the set of tokens included when sampling from an LLM, and the engineering problem is optimizing the utility of those tokens against the model's inherent constraints to consistently achieve a desired outcome. This overview section carries the post's opening framing; the sections that follow develop context-engineering-vs-prompt-engineering, why context is a finite resource, the anatomy of effective context (system prompts, tools, examples), just-in-time context retrieval, and the long-horizon techniques (compaction, structured note-taking, sub-agent architectures).

## Overview

Context is a critical but finite resource for AI agents. In this post, we explore strategies for effectively curating and managing the context that powers them.

After a few years of prompt engineering being the focus of attention in applied AI, a new term has come to prominence: *context engineering*. Building with language models is becoming less about finding the right words and phrases for your prompts, and more about answering the broader question of "what configuration of context is most likely to generate our model's desired behavior?"

Context refers to the set of tokens included when sampling from a large-language model (LLM). The engineering problem at hand is optimizing the utility of those tokens against the inherent constraints of LLMs in order to consistently achieve a desired outcome. Effectively wrangling LLMs often requires thinking in context — in other words: considering the holistic state available to the LLM at any given time and what potential behaviors that state might yield.

In this post, we'll explore the emerging art of context engineering and offer a refined mental model for building steerable, effective agents.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
