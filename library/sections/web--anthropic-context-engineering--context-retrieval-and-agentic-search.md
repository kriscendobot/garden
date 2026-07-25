---
title: "Context retrieval and agentic search"
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

The shift from pre-inference retrieval to **just-in-time context**. Anthropic's working definition of an agent: *LLMs autonomously using tools in a loop*, whose autonomy scales as the underlying models get smarter. Where many AI-native applications use embedding-based, pre-inference-time retrieval to surface context up front, the field is increasingly augmenting this with a **just-in-time** strategy: rather than pre-processing all relevant data, the agent maintains lightweight identifiers (file paths, stored queries, web links) and loads data into context at runtime using tools. Claude Code exemplifies this — writing targeted queries and using Bash commands like `head` and `tail` to analyze large datasets without loading full objects into context — mirroring human cognition, which relies on external indexing (file systems, inboxes, bookmarks) rather than memorizing corpuses. The metadata of these references (folder hierarchy, naming conventions, timestamps) carries signal, and autonomous navigation enables **progressive disclosure**: the agent discovers context incrementally, assembling understanding layer by layer while keeping only what is necessary in working memory. The trade-off is that runtime exploration is slower than retrieving pre-computed data and demands careful tool/heuristic design to avoid dead-ends. The most effective agents often use a **hybrid** strategy — Claude Code drops `CLAUDE.md` files into context up front while using `glob`/`grep` to retrieve files just-in-time — with "do the simplest thing that works" as the enduring advice.

## Context retrieval and agentic search

In *Building effective AI agents*, we highlighted the differences between LLM-based workflows and agents. Since we wrote that post, we've gravitated towards a simple definition for agents: LLMs autonomously using tools in a loop.

Working alongside our customers, we've seen the field converging on this simple paradigm. As the underlying models become more capable, the level of autonomy of agents can scale: smarter models allow agents to independently navigate nuanced problem spaces and recover from errors.

We're now seeing a shift in how engineers think about designing context for agents. Today, many AI-native applications employ some form of embedding-based pre-inference time retrieval to surface important context for the agent to reason over. As the field transitions to more agentic approaches, we increasingly see teams augmenting these retrieval systems with "just in time" context strategies.

Rather than pre-processing all relevant data up front, agents built with the "just in time" approach maintain lightweight identifiers (file paths, stored queries, web links, etc.) and use these references to dynamically load data into context at runtime using tools. Anthropic's agentic coding solution Claude Code uses this approach to perform complex data analysis over large databases. The model can write targeted queries, store results, and leverage Bash commands like `head` and `tail` to analyze large volumes of data without ever loading the full data objects into context. This approach mirrors human cognition: we generally don't memorize entire corpuses of information, but rather introduce external organization and indexing systems like file systems, inboxes, and bookmarks to retrieve relevant information on demand.

Beyond storage efficiency, the metadata of these references provides a mechanism to efficiently refine behavior, whether explicitly provided or intuitive. To an agent operating in a file system, the presence of a file named `test_utils.py` in a tests folder implies a different purpose than a file with the same name located in `src/core_logic/`. Folder hierarchies, naming conventions, and timestamps all provide important signals that help both humans and agents understand how and when to utilize information.

Letting agents navigate and retrieve data autonomously also enables progressive disclosure — in other words, allows agents to incrementally discover relevant context through exploration. Each interaction yields context that informs the next decision: file sizes suggest complexity; naming conventions hint at purpose; timestamps can be a proxy for relevance. Agents can assemble understanding layer by layer, maintaining only what's necessary in working memory and leveraging note-taking strategies for additional persistence. This self-managed context window keeps the agent focused on relevant subsets rather than drowning in exhaustive but potentially irrelevant information.

Of course, there's a trade-off: runtime exploration is slower than retrieving pre-computed data. Not only that, but opinionated and thoughtful engineering is required to ensure that an LLM has the right tools and heuristics for effectively navigating its information landscape. Without proper guidance, an agent can waste context by misusing tools, chasing dead-ends, or failing to identify key information.

In certain settings, the most effective agents might employ a hybrid strategy, retrieving some data up front for speed, and pursuing further autonomous exploration at its discretion. The decision boundary for the 'right' level of autonomy depends on the task. Claude Code is an agent that employs this hybrid model: `CLAUDE.md` files are naively dropped into context up front, while primitives like `glob` and `grep` allow it to navigate its environment and retrieve files just-in-time, effectively bypassing the issues of stale indexing and complex syntax trees.

The hybrid strategy might be better suited for contexts with less dynamic content, such as legal or finance work. As model capabilities improve, agentic design will trend towards letting intelligent models act intelligently, with progressively less human curation. Given the rapid pace of progress in the field, "do the simplest thing that works" will likely remain our best advice for teams building agents on top of Claude.

Source: [Effective context engineering for AI agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) by Anthropic's Applied AI team, published 2025-09-29; content SHA-256 `71b3783e68a1437558b2d970b1e309735401dc318c934bed501aa5b62b626dd2`.
