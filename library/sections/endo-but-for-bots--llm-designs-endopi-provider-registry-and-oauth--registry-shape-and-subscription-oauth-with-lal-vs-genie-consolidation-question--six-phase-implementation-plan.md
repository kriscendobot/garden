---
section: registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
source: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth
topics: [agent-conventions]
status: current
title: Six-phase implementation plan
parent: endo-but-for-bots--llm-designs-endopi-provider-registry-and-oauth--registry-shape-and-subscription-oauth-with-lal-vs-genie-consolidation-question
---

The §Phased implementation lists six phases, in dependency order:

1. **Registry shape, existing five providers re-registered.** No
   new provider yet; the goal is to retire the static dispatch
   and prove the registry surface.
2. **API-key providers via the registry.** Add 5 to 10 new
   providers (DeepSeek, Mistral, Groq, Cerebras, xAI, OpenRouter,
   Vercel AI Gateway). Each is a small module.
3. **OAuth: Claude subscription.** First subscription provider.
   Defines the OAuth-flow plumbing.
4. **OAuth: ChatGPT Plus (Codex), GitHub Copilot.** The remaining
   two subscription providers Pi supports.
5. **Cross-provider handoff.** `/model` mid-session switches the
   agent to a new provider; the transcript carries forward.
6. **Image input.** Where the provider supports it, image
   attachments on user messages flow through to the LLM.

Phases 1+2 are *partially satisfied via Genie* per the §Status
block. Phases 3+4 (OAuth) are the *genuinely missing* core of the
remaining work. Phases 5+6 are *plumbing on top of the registry*.
