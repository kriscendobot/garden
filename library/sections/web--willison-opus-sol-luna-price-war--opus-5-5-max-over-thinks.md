---
title: Claude Opus 5.5 max over-thinks to the point of breaking
source_kind: web
source_url: https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/
source_content_sha256: 097589c4a69cb06f3166b85b792da67191b29db74ce77349e33fdc6e66f4d6b1
source_authors: [Simon Willison]
source_date: 2026-09-22
ingested: 2026-09-23
ingested_by: scholar
topics: [frontier-model-apis]
status: current
---

## Abstract

The post's most operationally interesting finding: Claude Opus 5.5 at the "max" thinking level failed to return any response to Willison's "generate an SVG of a pelican riding a bicycle" test, a first in the history of that test. Opus 5.5 reasoned so long that it exhausted the 128,000-token maximum output budget (shared by the other Claude models) while still thinking, before emitting any answer. It reproduced on a second try. Willison concludes he suspects "max" is effectively useless: if it over-thinks to breaking on a trivial prompt, he does not trust it not to do the same on real work. This is the failure mode the concept page [[thinking-budget-output-overrun]] indexes, and it carries a direct caution for any fleet that runs Opus at high or max effort.

## Content

For the first time in Willison's long-running SVG-pelican test, a model failed to return a response. Opus 5.5 at "max" thinking started by calling the prompt "a classic test request," then thought "really, *really* hard" about it. Willison quotes several reasoning excerpts: planning a well-composed pelican with proper beak, pouch, wheels, frame, and pedals; "verifying the shin length checks out at roughly 95.2, close enough"; working out leg paths and foot shape "around y=478-494"; deciding a fish sticking out of the basket is "a fun detail worth keeping"; and checking chainring teeth and layer ordering.

Then it stopped. Willison explains: "Opus 5.5 has a 128,000 maximum output token limit (as do the other Claude models), and it hit that while it was still reasoning about the SVG." He tried a second time and got the same result. His conclusion: "This makes me suspect that 'max' is effectively useless: if it over-thinks to breaking point on a stupid SVG prompt I don't trust it not to do the same for more interesting work."

The two failures cost him $2.56 each and took nearly 20 minutes apiece. By contrast, Fable 5.1 on "max" did not over-think and gave him the best pelican he had seen from any Anthropic model.

Willison reports the rest of the Opus 5.5 pelican grid (excluding 5.5 max) rendered fine, and that comparing vendors by pelican quality may make little sense now, though he still finds value in comparing the same model family across reasoning levels. He closes by noting he is now defaulting to GPT-6 Sol and Claude Opus 5.5 in Codex and Claude Code, and has moved the Datasette Agent demo to GPT-6 Luna.

Curatorial note (garden relevance): the garden fleet runs Opus for its designer and builder roles (`skills/model-selection/SKILL.md`) and routinely selects high or max reasoning effort. This finding is a concrete caution that the highest effort level can exhaust the output-token budget before producing output, wasting both time and money, so effort selection is a real operational lever rather than a free "more is better" dial. Stated as a caution, not a measured claim about the garden's own runs.

Source: [opus-and-sol-and-luna](https://simonwillison.net/2026/Sep/22/opus-and-sol-and-luna/) (Simon Willison, 2026-09-22), content sha256 `097589c4`.
