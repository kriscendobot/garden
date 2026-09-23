---
title: A three-family same-day release and a new price war
source_kind: web
source_url: https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/
source_content_sha256: 097589c4a69cb06f3166b85b792da67191b29db74ce77349e33fdc6e66f4d6b1
source_authors: [Simon Willison]
source_date: 2026-09-22
ingested: 2026-09-23
ingested_by: scholar
topics: [frontier-model-apis, coding-agent-economics]
status: current
---

## Abstract

The framing overview of Simon Willison's 2026-09-22 link-blog post *Claude Opus 5.5, GPT-6 Sol, GPT-6 Luna, and a new price war*: three frontier-model families shipped inside a two-day window (Grok 4.7 and MiMo v2.6 Flash/Pro the day before; Anthropic's Claude Opus 5.5 and, about an hour later, OpenAI's GPT-6 Sol and GPT-6 Luna on the 22nd), and the post's thesis is that the notable story is not raw capability but a **price war** in the tier just below the top-priced models. Willison flags that a good read on the new models will take a while and offers first impressions. This section captures the post's identity and the release timeline; the pricing detail, the Opus 5.5 price cut, and the "max over-thinks to breaking" failure are separate sections.

## Content

Willison opens by noting the pace of releases: the day before the post it was Grok 4.7 (with its pelican renders) and MiMo v2.6 Flash/Pro (more pelicans). On 2026-09-22 Anthropic released Claude Opus 5.5, and around an hour later OpenAI released GPT-6 Sol and GPT-6 Luna. He writes that "it's going to take a while to get a good read on all of these new models, but here are my impressions so far."

The post is a practitioner link-blog entry, not a benchmark study. Its three substantive threads are:

- The GPT-6 Sol/Luna pricing, which is roughly half the price of the GPT-5.6 equivalents and is the headline "price war" story (see [pricing-and-the-price-war](web--willison-opus-sol-luna-price-war--pricing-and-the-price-war.md)).
- Claude Opus 5.5's own price cut and its improved communication style (see [opus-5-5-price-cut](web--willison-opus-sol-luna-price-war--opus-5-5-price-cut.md)).
- A first-ever failure of Willison's "generate an SVG of a pelican riding a bicycle" test: Opus 5.5 at "max" thinking over-thought until it hit the output-token limit and returned nothing (see [opus-5-5-max-over-thinks](web--willison-opus-sol-luna-price-war--opus-5-5-max-over-thinks.md)).

By the end of the post Willison reports he is now using GPT-6 Sol and Claude Opus 5.5 as his default models in Codex and Claude Code, and has upgraded the Datasette Agent demo to GPT-6 Luna.

Note on provenance: this is Simon Willison's summary of vendor announcements, not the vendors' primary material. The concrete prices and the model names are as Willison reported them on the ingest date; treat them as a snapshot of the 2026-09-22 landscape rather than a durable price list.

Source: [opus-and-sol-and-luna](https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/) (Simon Willison, 2026-09-22), content sha256 `097589c4`.
