---
role: builder
model: gpt-5.6-terra
priority: urgent
---
Implement and deploy-ready test a reversible multi-provider inference handler for Garden autonomous foreman on kriskowal/garden main2.

Today scripts/jobs/handlers/foreman-claude.sh is hardwired to claude -p. Add an operational provider-order control, preferably GARDEN_FOREMAN_PROVIDER_ORDER, supporting openai,local,anthropic: Codex first, then local Ollama/Qwen, then Claude only as final fallback. Reuse existing Codex/local invocation, model-routing, metering, response extraction, and provider-availability conventions rather than cloning incompatible command logic. Preserve the exact JOB/MAINTAINER output contract, injection defenses, timeout behavior, and deterministic tests. A quota or availability failure must advance to the next provider; malformed semantic output must not silently multiply work. Document restoring the normal order next week.

The deployed host will set GARDEN_FOREMAN_PROVIDER_ORDER=openai,local,anthropic while Claude quota is constrained. Garden changes land directly on main2; no garden PR. Do not alter worker role model routing or the qwen-only hermit classification.
