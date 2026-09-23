---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: The *partially satisfied* Status — six-axis scope refinement
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Status block is the most operationally interesting paragraph.
Like cycle 124's `endopi-iterative-compaction`, this design uses
the *partially-satisfied* lifecycle pattern. The §opening
observation:

> *`packages/genie` (pre-release, 2026 Q2) already depends on
> `@mariozechner/pi-ai` directly and ships an ollama provider
> adaptor (`buildOllamaModel` in
> `packages/genie/src/agent/index.js`) that masquerades the local
> ollama HTTP endpoint as the `openai-completions` API style.
> Genie therefore exposes `pi-ai`'s full provider registry inside
> Endo today, without the registry-shape refactor this design
> proposes for Lal.*

Cycle 121's §What Genie's existence tells us already made this
point: *the provider-registry gap is partially closed today;
Genie ships pi-ai's full registry by transitive dependency*.

The §What this means for the milestone enumerates *six axes* and
their satisfaction status:

| Phase | Axis | Status |
|-------|------|--------|
| 1 | Registry shape | Partially — Genie has a working consumer; Lal refactor still needed if Lal stays parallel |
| 2 | API-key providers (30+) | Available via Genie today through `pi-ai` |
| 3 | OAuth — Claude subscription | **Genuinely missing**; highest-leverage |
| 4 | OAuth — ChatGPT Plus + Copilot | **Genuinely missing** |
| 5 | Cross-provider handoff | Missing; Genie inherits the registry but doesn't exercise mid-session switching |
| 6 | Image input | Inherits from pi-ai per provider; Endo-side daemon-value-message plumbing unchanged |

The §scope-reduction observation:

> *The original "30+ providers" framing is no longer the headline.*

The design's *headline-has-moved* discipline is the same as cycle
124's iterative-compaction: the algorithm/registry already exists;
the design's role shifts to *picking which substrate-already-
exists-via-Genie pieces to harmonise into Lal vs leave to Genie's
embedding path*.
