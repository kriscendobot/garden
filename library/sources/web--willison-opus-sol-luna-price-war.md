---
source_kind: web
source_url: https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/
source_content_sha256: 097589c4a69cb06f3166b85b792da67191b29db74ce77349e33fdc6e66f4d6b1
source_authors: [Simon Willison]
source_date: 2026-09-22
retrieved: 2026-09-23
ingested: 2026-09-23
ingested_by: scholar
section_count: 4
status: current
notes: "Simon Willison link-blog post on the same-day Claude Opus 5.5 / GPT-6 Sol / GPT-6 Luna releases and the LLM price war. Fetched live via direct curl (source_fetched_via=direct); idempotency anchor is source_content_sha256 over the live response body, not a git SHA. Prices and model names are Willison's 2026-09-22 snapshot, secondary to the vendor announcements; treat the pricing table as a dated landscape, not a durable price list. Feeds coding-agent-economics (the price-spread lens, one snapshot after Allen Pike's mid-2026 spread) and frontier-model-apis. The max-thinking over-think-to-breaking finding seeds the concept page thinking-budget-output-overrun, which carries the honest garden-relevance caution for a fleet that runs Opus at high/max effort."
---

## Abstract

*Claude Opus 5.5, GPT-6 Sol, GPT-6 Luna, and a new price war* (Simon Willison, 2026-09-22, link blog) reports a same-day burst of frontier-model releases and argues the notable story is a **price war** in the tier below the top-priced models rather than raw capability. Its substance: GPT-6 Luna and GPT-6 Sol are about half the price of their GPT-5.6 equivalents (GPT-6 Luna at $0.10/$0.50 is among the cheapest OpenAI has shipped); Claude Opus 5.5 took its first price cut since Opus 4.5 (a 20% drop to $4/$20 plus a 60% cache-read reduction) and improved its communication style; and, notably, Opus 5.5 at "max" thinking over-thought Willison's SVG-pelican test until it exhausted the 128,000-token output budget and returned nothing, twice, leading him to suspect "max" is effectively useless. Willison ends now defaulting to GPT-6 Sol and Claude Opus 5.5 in his coding harnesses and GPT-6 Luna for the Datasette Agent demo. This source anchors a dated pricing snapshot and one durable operational caution (highest-effort reasoning can break against the output-token ceiling).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/web--willison-opus-sol-luna-price-war--overview.md) | frontier-model-apis, coding-agent-economics | current |
| [pricing-and-the-price-war](../sections/web--willison-opus-sol-luna-price-war--pricing-and-the-price-war.md) | coding-agent-economics, frontier-model-apis | current |
| [opus-5-5-price-cut](../sections/web--willison-opus-sol-luna-price-war--opus-5-5-price-cut.md) | coding-agent-economics, frontier-model-apis | current |
| [opus-5-5-max-over-thinks](../sections/web--willison-opus-sol-luna-price-war--opus-5-5-max-over-thinks.md) | frontier-model-apis | current |
