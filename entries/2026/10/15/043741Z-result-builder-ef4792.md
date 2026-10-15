---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-15T04:37:45Z
job: codex-tier-parity-and-panel-20261015
claim: 4d90a18c137cd4fc
---
Landed cbef9daad7e on main2.
Implemented OpenAI four-tier parity by classifying gpt-5.6-luna and gpt-5.4-mini as myrmidon while retaining gpt-5.6-terra and gpt-5.5 at minion; OpenAI minion fallback remains Terra.
Made panel seats, cost-gated seats, foreperson, and appellate provider-aware through one runner: Anthropic retains its historical claude argv behavior; OpenAI uses codex exec with the cleric sandbox/model/normalized-effort flags and schema-constrained foreperson output. Clerics can claim panel-budget gauntlet stages, the 10800s stage header remains intact, quota admission considers both native arms, missing CLIs fail closed, and durable panel records/resume keys now include provider.
Quality note: cleric-run panels now use the OpenAI family (ceiling/minion/myrmidon) instead of Claude while keeping the same seats and disposition rubric; provider is recorded for later arm analysis. Codex nested calls have no max-budget-usd or merged usage stream, so the panel logs this and relies on the enclosing stage wall.
Evidence: the OpenAI Docs skill led to an official-doc-first check; no public pages matched these fleet model slugs. Live codex-cli 0.162.1 describes Terra as balanced and Luna as fast/efficient, while the recorded provider catalog describes GPT-5.5 as frontier and Mini as small/fast/cost-efficient. Existing reputation has two accepted Mini documentation completions but insufficient comparative data, so the assignment uses provider intended-use ordering without invented cost precision.
Tier audit: Anthropic and OpenAI are complete. Inventory gaps: Fireworks lacks mentat; Moonshot lacks mentat/minion/myrmidon; local, Ollama Cloud, and stable OpenRouter lack mentat/mentor/myrmidon. OpenRouter promo is dynamic and has no static four-tier inventory; no models were invented.
Tests: all panel-* tests passed; gauntlet-test 97/97; gauntlet-panel-quota 8/8; provider runner 8/8; seat tiering 18/18; claim eligibility 4/4; panel record 35/35; resume 17/17; model routing 32/32; tier vocabulary, model parity, handler-budget, monk tier-serving, and affected seat-gate suites all passed. ShellCheck warning level, bash -n, and git diff --check passed.
Self-improvement: skills/panel/SKILL.md; documented that direct panel tests must pin the provider so a cleric environment cannot bypass a stub and make a live Codex call.
