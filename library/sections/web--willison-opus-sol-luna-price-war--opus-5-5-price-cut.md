---
title: Claude Opus 5.5 got a price cut too
source_kind: web
source_url: https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/
source_content_sha256: 097589c4a69cb06f3166b85b792da67191b29db74ce77349e33fdc6e66f4d6b1
source_authors: [Simon Willison]
source_date: 2026-09-22
ingested: 2026-09-23
ingested_by: scholar
topics: [coding-agent-economics, frontier-model-apis]
status: current
---

## Abstract

Claude Opus 5.5's own pricing and positioning as Willison reported it: the first Opus price change since Opus 4.5, a 20% cut from the long-held $5/$25-per-million to $4/$20, plus a 60% drop in the cache-read price that matters most for long agentic conversations (where 90%+ of input tokens are cached). Willison relays that Opus 5.5 also addresses the communication-style complaints about earlier Opus, is more token-efficient, and works across every effort level. This section is the Anthropic-side counterpart to the GPT-6 pricing section and is directly relevant to the garden fleet, which runs Opus tiers for its designer and builder roles.

## Content

Willison reports that Opus 5.5 "looks like it addresses the biggest complaints people had about Opus in terms of its communication style," quoting Thariq Shihipar of Anthropic: "Opus 5.5 is the result of your feedback. It communicates clearly, it's cheaper per token than Opus 5.0 with the intelligence of Fable 5.1, it's very token efficient and works across every effort level." Willison adds that Opus 5.5 is also reported to be better at Blender, which he looks forward to testing.

On price:

- Opus 4.5, 4.6, 4.7, 4.8, and 5 all shared the same price: $5/million input tokens and $25/million output. Opus 5.5 is a 20% reduction, to $4/million and $20/million.
- The cache-read price fell 60%. Willison flags this as significant for longer agentic conversations, where 90%+ of input tokens are processed at cached-token prices.
- The new Opus 5.5 price ($4/$20) matches GPT-5.6 Sol, but that comparison was set before OpenAI halved the Sol price with GPT-6 (so Opus 5.5 is above GPT-6 Sol's $2/$10 on the current landscape).

Willison places the price war one tier below Opus 5.5 and Fable 5.1: GPT-6 Astra and Claude Fable 5.1 are both $10/M input and $50/M output, and "the price war currently affects the next tier of models below that." He also notes Anthropic say Sonnet 5.5 and Haiku 5.5 are coming soon, and wonders whether Haiku can regain low-end price competitiveness given current Haiku 4.5 is $1/$5 while GPT-6 Luna is one tenth of that at $0.10/$0.50.

Source: [opus-and-sol-and-luna](https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/) (Simon Willison, 2026-09-22), content sha256 `097589c4`.
