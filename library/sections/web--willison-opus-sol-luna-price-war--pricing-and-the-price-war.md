---
title: GPT-6 Sol and Luna are half the price of their GPT-5.6 equivalents
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

The pricing landscape as Willison reported it on 2026-09-22 and the "price war" this ingest is named for: GPT-6 Luna prices at $0.10/M input and $0.50/M output, roughly half of GPT-5.6 Luna, and GPT-6 Sol took a similar cut over GPT-5.6 Sol. Willison calls GPT-6 Luna "one of the cheapest models OpenAI have ever released" (beaten only by the far weaker GPT-4.1 Nano and GPT-5 Nano), and notes the competitive pressure has pulled Grok 4.7 and GPT-6 Sol to the same input price ($2/M). This is the price-spread material the library's `coding-agent-economics` topic tracks, one snapshot later than Allen Pike's mid-2026 spread.

## Content

GPT-5.6 Luna was already Willison's favorite model for building applications against, combining strong performance with being "really cheap." GPT-6 Luna is roughly half that price again, and GPT-6 Sol saw a similar reduction against GPT-5.6 Sol.

The pricing table Willison published (per million tokens):

| Model | Input | Cached input | Output |
|---|---|---|---|
| GPT-6 Luna | $0.10/M | $0.01/M | $0.50/M |
| GPT-5.6 Luna | $0.20/M | $0.02/M | $1.20/M |
| Grok 4.7 | $2/M | $0.50/M | $6/M |
| GPT-6 Sol | $2/M | $0.20/M | $10/M |
| GPT-5.6 Terra | $2/M | $0.20/M | $12/M |
| Claude Opus 5.5 | $4/M | $0.20/M | $20/M |
| GPT-5.6 Sol | $4/M | $0.40/M | $20/M |
| Claude Fable 5.1 | $10/M | $0.25/M | $50/M |
| GPT-6 Astra | $10/M | $1/M | $50/M |

Willison's observations on the table:

- GPT-5.6 has a scheduled 25% price increase for November, so GPT-6 is half the price of the *promotional* pricing for the 5.6 models.
- With GPT-5.6 Terra priced the same as GPT-6 Sol, any remaining reason to use Terra evaporated.
- The pricing is hard to overstate as competitive. Grok 4.7 launched at $2/$6, less than half the price of GPT-5.6 Sol, but is now equally priced to GPT-6 Sol on input and closer on output.
- At $0.10/$0.50, GPT-6 Luna is one of the cheapest models OpenAI have released, beaten only by the far weaker GPT-4.1 Nano ($0.10/$0.40, April 2025) and GPT-5 Nano ($0.05/$0.40, August 2025).

The price war sits in the tier below the top-priced models: GPT-6 Astra and Claude Fable 5.1 are both $10/M input and $50/M output and are untouched by it. The competition is concentrated in the next tier down (the Sol / Opus / Grok band).

Source: [opus-and-sol-and-luna](https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/) (Simon Willison, 2026-09-22), content sha256 `097589c4`.
