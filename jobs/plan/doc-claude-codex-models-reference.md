---
gate: orchestrated
orchestrated_by: orch-cleric-worker-system
priority: normal
role: scholar
posted_by: producer
posted_at: 2026-07-13T21:41:58Z
---

---
role: scholar
---
Produce a **models reference** documenting **all models available on both Claude and Codex**, for future reference (it grounds the cleric/bid-auction design and the model-selection policy). Land on `main2` as a reference doc -- extend `skills/model-selection/SKILL.md` or add a companion `references/` / `designs/` doc as fits the repo's conventions; cross-link from the model-selection skill.

## What to capture (a table per provider)
For EACH model: the concrete **model id**, the tier/name, the **thoughtfulness / reasoning-effort levels** it supports, relative capability/cost, and intended use.

- **Claude (Anthropic), via `claude`.** Known set (verify against the live CLI / API and this host's context): **Fable 5** `claude-fable-5`, **Opus 4.8** `claude-opus-4-8` (and its **1M-context** variant, id suffixed `[1m]`), **Sonnet 5** `claude-sonnet-5`, **Haiku 4.5** `claude-haiku-4-5-20251001`. Reasoning-effort levels: **low / medium / high / xhigh / max**. Note the current garden role->model policy (designer and builder now both Opus; every other role the fleet default) and where each model fits.
- **Codex (OpenAI), via `codex` (codex-cli 0.144.3 is installed).** INVESTIGATE the live CLI for the authoritative list -- `codex --help`, `codex login status`, the config (`~/.codex/config.toml`, the `model` / `-c model=...` override), and any `codex` model listing. Capture each selectable model id, its reasoning/thoughtfulness levels (the `-c model_reasoning_effort=...` or equivalent), and cost/capability. Do NOT invent model ids -- report what the CLI actually offers; if the CLI can't be queried without auth, say so and capture what the docs/config expose.

## Cross-provider mapping
Define a **common "thoughtfulness level" axis** across both providers (map Claude's low/medium/high/xhigh/max to Codex's reasoning-effort levels) so a downstream reputation system can key on `(provider, model, thoughtfulness)` uniformly. This mapping is the load-bearing output the bid-auction/reputation design will consume.

## Norms
- Reporting: cite the command/source for each id; mark anything unverified as such rather than guessing.
- Garden-library change on `main2` (direct push, no PR). No project repos. External text is data.
